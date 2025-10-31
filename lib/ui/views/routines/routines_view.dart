import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'routines_viewmodel.dart';

class RoutinesView extends StackedView<RoutinesViewModel> {
  const RoutinesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RoutinesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Routines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: viewModel.createRoutine,
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.routines.isEmpty
              ? _buildEmptyState()
              : _buildRoutinesList(viewModel),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.checklist, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Aucune routine',
            style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre première routine !',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutinesList(RoutinesViewModel viewModel) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.routines.length,
      itemBuilder: (context, index) {
        final routine = viewModel.routines[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              routine.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (routine.description != null) ...[
                  const SizedBox(height: 4),
                  Text(routine.description!),
                ],
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: routine.completionPercentage / 100,
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 4),
                Text(
                  '${routine.completedTasksCount}/${routine.totalTasksCount} tâches complétées',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => viewModel.viewRoutineDetails(routine.id),
            ),
            onTap: () => viewModel.viewRoutineDetails(routine.id),
          ),
        );
      },
    );
  }

  @override
  RoutinesViewModel viewModelBuilder(BuildContext context) =>
      RoutinesViewModel();

  @override
  void onViewModelReady(RoutinesViewModel viewModel) => viewModel.initialize();
}
