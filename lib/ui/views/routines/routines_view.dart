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
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checklist_rounded,
              size: 100,
              color: Colors.deepPurple.shade200,
            ),
            const SizedBox(height: 24),
            const Text(
              'Bienvenue sur MOONGO!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Créez vos premières routines et faites évoluer vos créatures!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade700),
                  const SizedBox(height: 8),
                  Text(
                    '⚠️ Firebase non configuré',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pour activer toutes les fonctionnalités:\n1. Créez un projet Firebase\n2. Ajoutez google-services.json\n3. Consultez MOONGO_SETUP.md',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
