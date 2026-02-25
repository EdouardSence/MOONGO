import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/models/task_model.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:stacked/stacked.dart';

import '_widgets/tasks_widgets.dart';
import 'tasks_viewmodel.dart';

/// Tasks View avec esthétique "Enchanted Forest" - Style grimoire ancien
class TasksView extends StackedView<TasksViewModel> {
  const TasksView({super.key});

  @override
  Widget builder(
      BuildContext context, TasksViewModel viewModel, Widget? child) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: TasksAppBar(onCalendarTap: viewModel.navigateToCalendar),
        body: Stack(
          children: [
            // Fond avec texture subtile
            EnchantedBackground(isDark: isDark),

            // Contenu principal (TabBarView)
            TabBarView(
              children: [
                TaskList(
                  tasks: viewModel.todayTasks,
                  isDark: isDark,
                  onCompleteTask: viewModel.completeTask,
                  onDeleteTask: viewModel.deleteTask,
                  onCompleteSubTask: viewModel.completeSubTask,
                  onAddSubTask: (task) =>
                      _showAddSubTaskDialog(context, viewModel, task),
                  onCreateTask: () => _showCreateTaskSheet(context, viewModel),
                ),
                TaskList(
                  tasks: viewModel.weekTasks,
                  isDark: isDark,
                  onCompleteTask: viewModel.completeTask,
                  onDeleteTask: viewModel.deleteTask,
                  onCompleteSubTask: viewModel.completeSubTask,
                  onAddSubTask: (task) =>
                      _showAddSubTaskDialog(context, viewModel, task),
                  onCreateTask: () => _showCreateTaskSheet(context, viewModel),
                ),
                TaskList(
                  tasks: viewModel.monthTasks,
                  isDark: isDark,
                  onCompleteTask: viewModel.completeTask,
                  onDeleteTask: viewModel.deleteTask,
                  onCompleteSubTask: viewModel.completeSubTask,
                  onAddSubTask: (task) =>
                      _showAddSubTaskDialog(context, viewModel, task),
                  onCreateTask: () => _showCreateTaskSheet(context, viewModel),
                ),
                TaskList(
                  tasks: viewModel.allTasks,
                  isDark: isDark,
                  onCompleteTask: viewModel.completeTask,
                  onDeleteTask: viewModel.deleteTask,
                  onCompleteSubTask: viewModel.completeSubTask,
                  onAddSubTask: (task) =>
                      _showAddSubTaskDialog(context, viewModel, task),
                  onCreateTask: () => _showCreateTaskSheet(context, viewModel),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: EnchantedFab(
          onPressed: () => _showCreateTaskSheet(context, viewModel),
        ),
      ),
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

  void _showCreateTaskSheet(BuildContext context, TasksViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateTaskSheet(viewModel: viewModel),
    );
  }

  @override
  TasksViewModel viewModelBuilder(BuildContext context) => TasksViewModel();

  @override
  void onViewModelReady(TasksViewModel viewModel) => viewModel.init();
}
