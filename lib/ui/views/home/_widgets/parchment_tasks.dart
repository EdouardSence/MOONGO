import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/models/task_model.dart';
import 'package:moongo/ui/common/app_theme.dart';

class ParchmentTasks extends StatelessWidget {
  final AppThemeExtension appTheme;
  final bool isDark;
  final List<TaskModel> tasks;
  final int completedCount;
  final VoidCallback onTaskTap;

  const ParchmentTasks({
    super.key,
    required this.appTheme,
    required this.isDark,
    required this.tasks,
    required this.completedCount,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: appTheme.postItBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : AppColors.secondary.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: appTheme.postItBorder.withValues(alpha: 0.6),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec style parchemin
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: appTheme.postItBorder.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('📜', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Quêtes du jour',
                style: GoogleFonts.fraunces(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: appTheme.postItText,
                ),
              ),
              const Spacer(),
              // Badge compteur
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      appTheme.postItBorder,
                      appTheme.postItBorder.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.postItBorder.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '$completedCount/${tasks.length}',
                  style: GoogleFonts.fraunces(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Divider organique
          Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  appTheme.postItBorder.withValues(alpha: 0.1),
                  appTheme.postItBorder.withValues(alpha: 0.4),
                  appTheme.postItBorder.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Liste des tâches
          Expanded(
            child: tasks.isEmpty
                ? NoTasksState(appTheme: appTheme)
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: tasks.take(4).length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskItem(
                        task: task,
                        appTheme: appTheme,
                        isDark: isDark,
                        onTap: onTaskTap,
                      );
                    },
                  ),
          ),

          if (tasks.length > 4)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${tasks.length - 4} autres quêtes',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: appTheme.postItText.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class NoTasksState extends StatelessWidget {
  final AppThemeExtension appTheme;

  const NoTasksState({super.key, required this.appTheme});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: appTheme.postItBorder.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🎊', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Repos bien mérité !',
            style: GoogleFonts.fraunces(
              color: appTheme.postItText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Aucune quête aujourd\'hui',
            style: GoogleFonts.dmSans(
              color: appTheme.postItText.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final AppThemeExtension appTheme;
  final bool isDark;
  final VoidCallback onTap;

  const TaskItem({
    super.key,
    required this.task,
    required this.appTheme,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: task.completed
                ? (isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.03))
                : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.6)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: task.completed
                  ? Colors.transparent
                  : appTheme.postItBorder.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Navigation Arrow
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: appTheme.postItBorder.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: appTheme.postItText.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Contenu de la tâche
              Expanded(
                child: Text(
                  task.title,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration:
                        task.completed ? TextDecoration.lineThrough : null,
                    color: task.completed
                        ? appTheme.postItText.withValues(alpha: 0.5)
                        : appTheme.postItText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Icône de la tâche
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: appTheme.postItBorder.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(task.icon, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
