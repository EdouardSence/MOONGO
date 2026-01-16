import 'package:flutter/material.dart';
import 'package:moongo/models/task_model.dart';

import 'empty_state.dart';
import 'task_card.dart';

/// Liste des tâches avec style parchemin
class TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  final bool isDark;
  final void Function(TaskModel task) onCompleteTask;
  final void Function(String taskId) onDeleteTask;
  final void Function(TaskModel task, String subTaskId) onCompleteSubTask;
  final void Function(TaskModel task) onAddSubTask;

  const TaskList({
    super.key,
    required this.tasks,
    required this.isDark,
    required this.onCompleteTask,
    required this.onDeleteTask,
    required this.onCompleteSubTask,
    required this.onAddSubTask,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return EmptyState(isDark: isDark);
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
                child: TaskCard(
                  task: task,
                  isDark: isDark,
                  onCompleteTask: onCompleteTask,
                  onDeleteTask: onDeleteTask,
                  onCompleteSubTask: onCompleteSubTask,
                  onAddSubTask: onAddSubTask,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
