import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:moongo/models/task_model.dart';
import 'package:moongo/ui/common/app_theme.dart';

/// Carte de tâche style parchemin
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final bool isDark;
  final void Function(TaskModel task) onCompleteTask;
  final void Function(String taskId) onDeleteTask;
  final void Function(TaskModel task, String subTaskId) onCompleteSubTask;
  final void Function(TaskModel task) onAddSubTask;

  const TaskCard({
    super.key,
    required this.task,
    required this.isDark,
    required this.onCompleteTask,
    required this.onDeleteTask,
    required this.onCompleteSubTask,
    required this.onAddSubTask,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(task.color.replaceFirst('#', '0xFF')));
    final theme = Theme.of(context);
    final appTheme = theme.appTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: appTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: isDark ? 0.15 : 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header avec bannière colorée et ornements
          TaskHeader(task: task, color: color, isDark: isDark),

          // Contenu de la tâche
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (task.type == TaskType.objective || task.subTasks.isNotEmpty)
                  ProgressSection(
                    task: task,
                    isDark: isDark,
                    onAddSubTask: onAddSubTask,
                    onCompleteSubTask: onCompleteSubTask,
                    onCompleteTask: onCompleteTask,
                  )
                else
                  TaskActions(
                    task: task,
                    isDark: isDark,
                    onCompleteTask: onCompleteTask,
                    onDeleteTask: onDeleteTask,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// En-tête de la carte tâche
class TaskHeader extends StatelessWidget {
  final TaskModel task;
  final Color color;
  final bool isDark;

  const TaskHeader({
    super.key,
    required this.task,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isDark ? 0.25 : 0.12),
            color.withValues(alpha: isDark ? 0.15 : 0.06),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        border: Border(
          bottom: BorderSide(
            color: color.withValues(alpha: isDark ? 0.2 : 0.15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Icône avec glow
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.3 : 0.2),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(task.icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),

          // Titre et description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: GoogleFonts.fraunces(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    decoration:
                        task.completed ? TextDecoration.lineThrough : null,
                    color: task.completed
                        ? (isDark ? Colors.grey[500] : Colors.grey[400])
                        : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary),
                  ),
                ),
                if (task.description != null && task.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      task.description!,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),

          if (task.dueDate != null) ...[
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('dd/MM', 'fr_FR').format(task.dueDate!),
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Badge type
          TypeChip(type: task.type, isDark: isDark),
        ],
      ),
    );
  }
}

/// Badge du type de tâche
class TypeChip extends StatelessWidget {
  final TaskType type;
  final bool isDark;

  const TypeChip({super.key, required this.type, required this.isDark});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    String emoji;

    switch (type) {
      case TaskType.single:
        label = 'Unique';
        color = AppColors.accent;
        emoji = '⚡';
        break;
      case TaskType.recurring:
        label = 'Rituel';
        color = AppColors.tertiary;
        emoji = '🔄';
        break;
      case TaskType.objective:
        label = 'Tâche groupée';
        color = AppColors.secondary;
        emoji = '🏆';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.25 : 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.4 : 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Section progression pour les objectifs
class ProgressSection extends StatelessWidget {
  final TaskModel task;
  final bool isDark;
  final void Function(TaskModel task) onAddSubTask;
  final void Function(TaskModel task, String subTaskId) onCompleteSubTask;
  final void Function(TaskModel task) onCompleteTask;

  const ProgressSection({
    super.key,
    required this.task,
    required this.isDark,
    required this.onAddSubTask,
    required this.onCompleteSubTask,
    required this.onCompleteTask,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = (task.progress * 100).toInt();

    return Column(
      children: [
        // Barre de progression stylée
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              task.subTasks.isEmpty
                  ? 'Aucune étape'
                  : '$progressPercent% accompli',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (task.subTasks.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${task.subTasks.where((t) => t.completed).length}/${task.subTasks.length}',
                  style: GoogleFonts.fraunces(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Barre de progression avec style organique
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  width:
                      MediaQuery.of(context).size.width * task.progress * 0.75,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.tertiary],
                    ),
                  ),
                ),
                // Particules brillantes
                if (task.progress > 0)
                  Positioned(
                    right: 2,
                    top: 2,
                    bottom: 2,
                    child: Container(
                      width: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Sous-tâches
        ...task.subTasks.map(
          (subTask) => SubTaskItem(
            subTask: subTask,
            isDark: isDark,
            onComplete: () => onCompleteSubTask(task, subTask.id),
          ),
        ),

        const SizedBox(height: 12),

        // Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bouton ajouter sous-tâche
            GestureDetector(
              onTap: () => onAddSubTask(task),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, size: 18, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      'Étape',
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Récompense
            RewardBadge(seeds: task.seedsReward, isDark: isDark),
          ],
        ),

        // Bouton compléter si objectif atteint
        if (task.progress >= 1.0 && !task.completed)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GestureDetector(
              onTap: () => onCompleteTask(task),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.tertiary,
                      AppColors.tertiary.withValues(alpha: 0.8)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.tertiary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      'Épopée accomplie !',
                      style: GoogleFonts.fraunces(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Item de sous-tâche
class SubTaskItem extends StatelessWidget {
  final SubTask subTask;
  final bool isDark;
  final VoidCallback onComplete;

  const SubTaskItem({
    super.key,
    required this.subTask,
    required this.isDark,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: subTask.completed ? null : onComplete,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: subTask.completed
              ? AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.08)
              : (isDark ? Colors.grey[850] : Colors.grey[50]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: subTask.completed
                ? AppColors.primary.withValues(alpha: 0.3)
                : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            // Checkbox stylée
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color:
                    subTask.completed ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: subTask.completed
                      ? AppColors.primary
                      : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
                  width: 2,
                ),
              ),
              child: subTask.completed
                  ? const Icon(Icons.check_rounded,
                      size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),

            // Titre
            Expanded(
              child: Text(
                subTask.title,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  decoration:
                      subTask.completed ? TextDecoration.lineThrough : null,
                  color: subTask.completed
                      ? (isDark ? Colors.grey[500] : Colors.grey[400])
                      : (isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge de récompense
class RewardBadge extends StatelessWidget {
  final int seeds;
  final bool isDark;

  const RewardBadge({super.key, required this.seeds, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.tertiary.withValues(alpha: 0.2),
            AppColors.tertiary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.tertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '+$seeds',
            style: GoogleFonts.fraunces(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.tertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Actions pour les tâches simples
class TaskActions extends StatelessWidget {
  final TaskModel task;
  final bool isDark;
  final void Function(TaskModel task) onCompleteTask;
  final void Function(String taskId) onDeleteTask;

  const TaskActions({
    super.key,
    required this.task,
    required this.isDark,
    required this.onCompleteTask,
    required this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RewardBadge(seeds: task.seedsReward, isDark: isDark),
        Row(
          children: [
            if (!task.completed)
              GestureDetector(
                onTap: () => onCompleteTask(task),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.85)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_rounded,
                          size: 18, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        'Accomplir',
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Text('✅', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      'Accompli',
                      style: GoogleFonts.dmSans(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(width: 8),

            // Bouton supprimer
            GestureDetector(
              onTap: () => onDeleteTask(task.taskId),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: Colors.red[400],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
