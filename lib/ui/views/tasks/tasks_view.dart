import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/models/task_model.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:stacked/stacked.dart';

import 'tasks_viewmodel.dart';

/// Tasks View avec esthétique "Enchanted Forest" - Style grimoire ancien
class TasksView extends StackedView<TasksViewModel> {
  const TasksView({super.key});

  @override
  Widget builder(
      BuildContext context, TasksViewModel viewModel, Widget? child) {
    final theme = Theme.of(context);
    final appTheme = theme.appTheme;
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            // Fond avec texture subtile
            _buildEnchantedBackground(context),

            // Contenu principal
            Column(
              children: [
                // En-tête style grimoire
                _buildGrimoireHeader(context),

                // Onglets style parchemin
                _buildParchmentTabs(context, isDark),

                // Liste des tâches
                Expanded(
                  child: viewModel.isBusy
                      ? _buildLoadingState(context)
                      : TabBarView(
                          children: [
                            _buildTaskList(
                                context, viewModel, viewModel.allTasks),
                            _buildTaskList(
                                context, viewModel, viewModel.todayTasks),
                            _buildTaskList(
                                context, viewModel, viewModel.weekTasks),
                            _buildTaskList(
                                context, viewModel, viewModel.monthTasks),
                          ],
                        ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: _buildEnchantedFAB(context, viewModel),
      ),
    );
  }

  /// Fond enchanté avec dégradé forestier
  Widget _buildEnchantedBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColors.darkBackground,
                  AppColors.darkSurface,
                  AppColors.darkBackground.withOpacity(0.95),
                ]
              : [
                  AppColors.lightBackground,
                  AppColors.lightSurface,
                  AppColors.lightBackground,
                ],
        ),
      ),
      child: CustomPaint(
        painter: _ScrollTexturePainter(isDark: isDark),
        child: const SizedBox.expand(),
      ),
    );
  }

  /// En-tête style grimoire avec titre orné
  Widget _buildGrimoireHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 24,
        right: 24,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary.withOpacity(0.6)
                ]
              : [AppColors.primary, AppColors.primary.withOpacity(0.85)],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône livre/grimoire
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Text('📜', style: TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),

          // Titre avec typographie distinctive
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grimoire',
                  style: GoogleFonts.fraunces(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'des Quêtes',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.85),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

          // Ornement décoratif
          const Text('✨', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }

  /// Onglets style parchemin avec icônes
  Widget _buildParchmentTabs(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withOpacity(0.8)
            : AppColors.secondary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.secondary.withOpacity(isDark ? 0.3 : 0.4),
          width: 1.5,
        ),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        labelStyle: GoogleFonts.dmSans(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.dmSans(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: '✨ Tous'),
          Tab(text: '🌅 Jour'),
          Tab(text: '🌙 Sem.'),
          Tab(text: '🌿 Mois'),
        ],
      ),
    );
  }

  /// État de chargement avec animation
  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 6.28,
                child: const Text('🌿', style: TextStyle(fontSize: 48)),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Consultation du grimoire...',
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Liste des tâches avec style parchemin
  Widget _buildTaskList(
      BuildContext context, TasksViewModel viewModel, List<TaskModel> tasks) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (tasks.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildTaskCard(context, viewModel, task, index),
              ),
            );
          },
        );
      },
    );
  }

  /// État vide avec illustration
  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration parchemin vide
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(isDark ? 0.2 : 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.secondary.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Text('📜', style: TextStyle(fontSize: 64)),
          ),
          const SizedBox(height: 24),
          Text(
            'Parchemin vierge',
            style: GoogleFonts.fraunces(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inscrivez votre première quête\ndans ce grimoire sacré',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          // Bouton avec style organique
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('✨', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  'Créer une quête',
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Carte de tâche style parchemin
  Widget _buildTaskCard(BuildContext context, TasksViewModel viewModel,
      TaskModel task, int index) {
    final color = Color(int.parse(task.color.replaceFirst('#', '0xFF')));
    final theme = Theme.of(context);
    final appTheme = theme.appTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: appTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(isDark ? 0.3 : 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isDark ? 0.15 : 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header avec bannière colorée et ornements
          _buildTaskHeader(task, color, isDark),

          // Contenu de la tâche
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (task.type == TaskType.objective || task.subTasks.isNotEmpty)
                  _buildProgressSection(context, viewModel, task, isDark)
                else
                  _buildTaskActions(context, viewModel, task, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// En-tête de la carte tâche
  Widget _buildTaskHeader(TaskModel task, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(isDark ? 0.25 : 0.12),
            color.withOpacity(isDark ? 0.15 : 0.06),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
        border: Border(
          bottom: BorderSide(
            color: color.withOpacity(isDark ? 0.2 : 0.15),
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
              color: color.withOpacity(isDark ? 0.3 : 0.2),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
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

          // Badge type
          _buildTypeChip(task.type, isDark),
        ],
      ),
    );
  }

  /// Badge du type de tâche
  Widget _buildTypeChip(TaskType type, bool isDark) {
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
        label = 'Épopée';
        color = AppColors.secondary;
        emoji = '🏆';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.25 : 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(isDark ? 0.4 : 0.3),
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

  /// Section progression pour les objectifs
  Widget _buildProgressSection(BuildContext context, TasksViewModel viewModel,
      TaskModel task, bool isDark) {
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
                  color: AppColors.primary.withOpacity(0.1),
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
                        color: Colors.white.withOpacity(0.5),
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
            (subTask) => _buildSubTaskItem(viewModel, task, subTask, isDark)),

        const SizedBox(height: 12),

        // Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bouton ajouter sous-tâche
            GestureDetector(
              onTap: () => _showAddSubTaskDialog(context, viewModel, task),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.3),
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
            _buildRewardBadge(task.seedsReward, isDark),
          ],
        ),

        // Bouton compléter si objectif atteint
        if (task.progress >= 1.0 && !task.completed)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GestureDetector(
              onTap: () => viewModel.completeTask(task),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.tertiary,
                      AppColors.tertiary.withOpacity(0.8)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.tertiary.withOpacity(0.4),
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

  /// Item de sous-tâche
  Widget _buildSubTaskItem(
      TasksViewModel viewModel, TaskModel task, SubTask subTask, bool isDark) {
    return GestureDetector(
      onTap: subTask.completed
          ? null
          : () => viewModel.completeSubTask(task, subTask.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: subTask.completed
              ? AppColors.primary.withOpacity(isDark ? 0.15 : 0.08)
              : (isDark ? Colors.grey[850] : Colors.grey[50]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: subTask.completed
                ? AppColors.primary.withOpacity(0.3)
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

  /// Badge de récompense
  Widget _buildRewardBadge(int seeds, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.tertiary.withOpacity(0.2),
            AppColors.tertiary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.tertiary.withOpacity(0.3),
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

  /// Actions pour les tâches simples
  Widget _buildTaskActions(BuildContext context, TasksViewModel viewModel,
      TaskModel task, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRewardBadge(task.seedsReward, isDark),
        Row(
          children: [
            if (!task.completed)
              GestureDetector(
                onTap: () => viewModel.completeTask(task),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.85)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
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
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
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
              onTap: () => viewModel.deleteTask(task.taskId),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
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

  /// Dialogue pour ajouter une sous-tâche
  void _showAddSubTaskDialog(
      BuildContext context, TasksViewModel viewModel, TaskModel task) {
    final controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            const Text('📝', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              'Nouvelle étape',
              style: GoogleFonts.fraunces(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.dmSans(
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Décrivez cette étape...',
            hintStyle: GoogleFonts.dmSans(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            filled: true,
            fillColor:
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: GoogleFonts.dmSans(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                viewModel.addSubTaskToObjective(task.taskId, controller.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Ajouter',
              style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// FAB enchanté pour créer une tâche
  Widget _buildEnchantedFAB(BuildContext context, TasksViewModel viewModel) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accent, AppColors.accent.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.5),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => _showCreateTaskSheet(context, viewModel),
        backgroundColor: Colors.transparent,
        elevation: 0,
        icon: const Text('✨', style: TextStyle(fontSize: 20)),
        label: Text(
          'Nouvelle quête',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showCreateTaskSheet(BuildContext context, TasksViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateTaskSheet(viewModel: viewModel),
    );
  }

  @override
  TasksViewModel viewModelBuilder(BuildContext context) => TasksViewModel();

  @override
  void onViewModelReady(TasksViewModel viewModel) => viewModel.init();
}

/// Painter pour texture de parchemin
class _ScrollTexturePainter extends CustomPainter {
  final bool isDark;

  _ScrollTexturePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : AppColors.secondary).withOpacity(0.03)
      ..style = PaintingStyle.fill;

    // Motif subtil de parchemin
    for (var i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint..strokeWidth = 0.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Sheet de création de tâche avec style enchanté
class _CreateTaskSheet extends StatefulWidget {
  final TasksViewModel viewModel;

  const _CreateTaskSheet({required this.viewModel});

  @override
  State<_CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<_CreateTaskSheet> {
  TaskType _selectedType = TaskType.single;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedIcon = '✨';
  String _selectedColor = '#2D5A47';
  int _seedsReward = 10;
  DateTime? _dueDate;
  RecurrenceFrequency? _recurrenceFrequency;
  List<int> _selectedDays = [];
  bool _isGroupedTask = false;

  final List<String> _icons = [
    '✨',
    '🌟',
    '💪',
    '🎯',
    '📚',
    '🧘',
    '🏃',
    '💤',
    '🎨',
    '🎵',
    '🌿',
    '🦋'
  ];

  final List<String> _colors = [
    '#2D5A47',
    '#D4A574',
    '#7C3AED',
    '#F59E0B',
    '#059669',
    '#0EA5E9'
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poignée
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Titre avec ornements
            Row(
              children: [
                const Text('📜', style: TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Text(
                  'Nouvelle Quête',
                  style: GoogleFonts.fraunces(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Type de quête
            Text(
              'Type de quête',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTypeButton('⚡ Unique', TaskType.single, isDark),
                const SizedBox(width: 10),
                _buildTypeButton('🔄 Rituel', TaskType.recurring, isDark),
                const SizedBox(width: 10),
                _buildTypeButton('🏆 Épopée', TaskType.objective, isDark),
              ],
            ),
            const SizedBox(height: 24),

            // Titre
            TextField(
              controller: _titleController,
              style: GoogleFonts.dmSans(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'Titre de la quête',
                labelStyle: GoogleFonts.dmSans(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                prefixIcon: Icon(Icons.edit_outlined, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descriptionController,
              style: GoogleFonts.dmSans(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              decoration: InputDecoration(
                labelText: 'Description (optionnel)',
                labelStyle: GoogleFonts.dmSans(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                filled: true,
                fillColor: isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
                prefixIcon:
                    Icon(Icons.notes_outlined, color: AppColors.secondary),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Icônes
            Text(
              'Emblème',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _icons.map((icon) {
                final isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.15)
                          : (isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(icon, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Couleurs
            Text(
              'Aura',
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: _colors.map((color) {
                final isSelected = _selectedColor == color;
                final colorValue =
                    Color(int.parse(color.replaceFirst('#', '0xFF')));
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorValue,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorValue.withOpacity(isSelected ? 0.5 : 0.3),
                          blurRadius: isSelected ? 12 : 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 24)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Récompense
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.tertiary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Text('🌱', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(
                    'Récompense:',
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<int>(
                    value: _seedsReward,
                    dropdownColor:
                        isDark ? AppColors.darkSurface : Colors.white,
                    style: GoogleFonts.fraunces(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.tertiary,
                    ),
                    underline: const SizedBox(),
                    items: [5, 10, 15, 20, 25, 30, 50].map((v) {
                      return DropdownMenuItem(
                        value: v,
                        child: Text('$v graines'),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _seedsReward = v ?? 10),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Options spécifiques selon le type
            if (_selectedType == TaskType.single) ...[
              _buildDatePicker(isDark),
            ],

            if (_selectedType == TaskType.recurring) ...[
              _buildRecurrenceOptions(isDark),
            ],

            const SizedBox(height: 32),

            // Bouton créer
            GestureDetector(
              onTap: _titleController.text.isEmpty
                  ? null
                  : () {
                      widget.viewModel.createTask(
                        title: _titleController.text,
                        description: _descriptionController.text.isEmpty
                            ? null
                            : _descriptionController.text,
                        icon: _selectedIcon,
                        color: _selectedColor,
                        type: _selectedType,
                        seedsReward: _seedsReward,
                        dueDate: _dueDate,
                        recurrence: _selectedType == TaskType.recurring &&
                                _recurrenceFrequency != null
                            ? RecurrenceConfig(
                                frequency: _recurrenceFrequency!,
                                daysOfWeek: _recurrenceFrequency ==
                                            RecurrenceFrequency.custom &&
                                        _selectedDays.isNotEmpty
                                    ? _selectedDays
                                    : null,
                              )
                            : null,
                      );
                      Navigator.pop(context);
                    },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.85)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('✨', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Text(
                      'Inscrire la quête',
                      style: GoogleFonts.fraunces(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String label, TaskType type, bool isDark) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(bool isDark) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: isDark ? AppColors.darkSurface : Colors.white,
                ),
              ),
              child: child!,
            );
          },
        );
        if (date != null) setState(() => _dueDate = date);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _dueDate != null ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, color: AppColors.accent),
            const SizedBox(width: 12),
            Text(
              _dueDate == null
                  ? 'Ajouter une échéance'
                  : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
              style: GoogleFonts.dmSans(
                color: _dueDate != null
                    ? (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary)
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              ),
            ),
            const Spacer(),
            if (_dueDate != null)
              GestureDetector(
                onTap: () => setState(() => _dueDate = null),
                child: Icon(Icons.close_rounded, color: Colors.grey[500]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecurrenceOptions(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fréquence du rituel',
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: RecurrenceFrequency.values.map((freq) {
            final isSelected = _recurrenceFrequency == freq;
            String label;
            String emoji;
            switch (freq) {
              case RecurrenceFrequency.daily:
                label = 'Quotidien';
                emoji = '🌅';
              case RecurrenceFrequency.weekly:
                label = 'Hebdo';
                emoji = '📅';
              case RecurrenceFrequency.monthly:
                label = 'Mensuel';
                emoji = '🌙';
              case RecurrenceFrequency.custom:
                label = 'Perso';
                emoji = '⚙️';
            }
            return GestureDetector(
              onTap: () {
                setState(() {
                  _recurrenceFrequency = freq;
                  if (freq != RecurrenceFrequency.custom) {
                    _selectedDays = [];
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.tertiary
                      : (isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.tertiary.withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emoji),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: GoogleFonts.dmSans(
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (_recurrenceFrequency == RecurrenceFrequency.custom) ...[
          const SizedBox(height: 16),
          Text(
            'Jours de répétition',
            style: GoogleFonts.dmSans(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDayButton('L', 1, isDark),
              _buildDayButton('M', 2, isDark),
              _buildDayButton('M', 3, isDark),
              _buildDayButton('J', 4, isDark),
              _buildDayButton('V', 5, isDark),
              _buildDayButton('S', 6, isDark),
              _buildDayButton('D', 7, isDark),
            ],
          ),
        ],
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() => _isGroupedTask = !_isGroupedTask),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _isGroupedTask
                  ? AppColors.accent.withOpacity(0.15)
                  : (isDark
                      ? AppColors.darkBackground
                      : AppColors.lightBackground),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isGroupedTask ? AppColors.accent : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color:
                        _isGroupedTask ? AppColors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _isGroupedTask
                          ? AppColors.accent
                          : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
                      width: 2,
                    ),
                  ),
                  child: _isGroupedTask
                      ? const Icon(Icons.check_rounded,
                          size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rituel groupé',
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'Permet d\'ajouter plusieurs étapes',
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayButton(String label, int dayNumber, bool isDark) {
    final isSelected = _selectedDays.contains(dayNumber);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedDays.remove(dayNumber);
          } else {
            _selectedDays.add(dayNumber);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
