import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_first_app/models/creature_model.dart';
import 'creatures_viewmodel.dart';

class CreaturesView extends StackedView<CreaturesViewModel> {
  const CreaturesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CreaturesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Créatures'),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.creatures.isEmpty
              ? _buildEmptyState()
              : _buildCreaturesList(viewModel),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 100, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Aucune créature',
            style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Complétez des tâches pour faire évoluer vos créatures !',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCreaturesList(CreaturesViewModel viewModel) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: viewModel.creatures.length,
      itemBuilder: (context, index) {
        final creature = viewModel.creatures[index];
        return _buildCreatureCard(creature);
      },
    );
  }

  Widget _buildCreatureCard(CreatureModel creature) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icône de la créature (placeholder)
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _getCreatureColor(creature.type),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCreatureIcon(creature.stage),
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Nom de la créature
            Text(
              creature.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            // Stage
            Text(
              _getStageLabel(creature.stage),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),

            // Niveau
            Text(
              'Niveau ${creature.level}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),

            // Barre de progression XP
            LinearProgressIndicator(
              value: creature.progressToNextLevel,
              backgroundColor: Colors.grey[200],
              valueColor:
                  AlwaysStoppedAnimation(_getCreatureColor(creature.type)),
            ),
            const SizedBox(height: 4),
            Text(
              '${creature.experience}/${creature.experienceToNextLevel} XP',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCreatureColor(CreatureType type) {
    switch (type) {
      case CreatureType.fire:
        return Colors.red;
      case CreatureType.water:
        return Colors.blue;
      case CreatureType.earth:
        return Colors.brown;
      case CreatureType.air:
        return Colors.cyan;
      case CreatureType.nature:
        return Colors.green;
    }
  }

  IconData _getCreatureIcon(CreatureStage stage) {
    switch (stage) {
      case CreatureStage.egg:
        return Icons.egg;
      case CreatureStage.baby:
        return Icons.child_care;
      case CreatureStage.teen:
        return Icons.sentiment_satisfied;
      case CreatureStage.adult:
        return Icons.star;
      case CreatureStage.legendary:
        return Icons.auto_awesome;
    }
  }

  String _getStageLabel(CreatureStage stage) {
    switch (stage) {
      case CreatureStage.egg:
        return 'Œuf';
      case CreatureStage.baby:
        return 'Bébé';
      case CreatureStage.teen:
        return 'Adolescent';
      case CreatureStage.adult:
        return 'Adulte';
      case CreatureStage.legendary:
        return 'Légendaire';
    }
  }

  @override
  CreaturesViewModel viewModelBuilder(BuildContext context) =>
      CreaturesViewModel();

  @override
  void onViewModelReady(CreaturesViewModel viewModel) => viewModel.initialize();
}
