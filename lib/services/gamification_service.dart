import 'package:my_first_app/models/creature_model.dart';
import 'package:my_first_app/models/routine_model.dart';
import 'package:my_first_app/services/firestore_service.dart';
import 'package:my_first_app/app/app.locator.dart';

class GamificationService {
  final FirestoreService _firestoreService;

  GamificationService(this._firestoreService);

  // Factory pour l'injection de dépendances
  static GamificationService fromLocator() {
    return GamificationService(locator<FirestoreService>());
  }

  /// Compléter une tâche et gagner de l'expérience
  Future<void> completeTask({
    required String userId,
    required String routineId,
    required TaskModel task,
    required String creatureId,
  }) async {
    try {
      // 1. Récupérer la créature
      final creatures = await _firestoreService.getUserCreatures(userId);
      final creature = creatures.firstWhere((c) => c.id == creatureId);

      // 2. Ajouter l'expérience à la créature
      final updatedCreature = creature.addExperience(task.experienceReward);

      // 3. Mettre à jour la créature dans Firestore
      await _firestoreService.updateCreature(creatureId, updatedCreature);

      // 4. Mettre à jour le total d'expérience de l'utilisateur
      final user = await _firestoreService.getUserProfile(userId);
      if (user != null) {
        await _firestoreService.updateUserProfile(userId, {
          'totalExperience': user.totalExperience + task.experienceReward,
        });
      }

      // TODO: Mettre à jour la routine avec la tâche complétée
    } catch (e) {
      throw Exception('Erreur lors de la complétion de la tâche: $e');
    }
  }

  /// Réinitialiser les tâches quotidiennes (à appeler chaque jour)
  Future<void> resetDailyTasks(String userId) async {
    // TODO: Implémenter la logique de réinitialisation des tâches quotidiennes
  }

  /// Calculer le niveau global de l'utilisateur basé sur l'expérience totale
  int calculateUserLevel(int totalExperience) {
    return (totalExperience / 1000).floor() + 1;
  }

  /// Créer une créature de départ pour un nouvel utilisateur
  Future<String> createStarterCreature({
    required String userId,
    required CreatureType type,
    String? customName,
  }) async {
    final creature = CreatureModel(
      id: '', // Sera généré par Firestore
      userId: userId,
      name: customName ?? _getDefaultCreatureName(type),
      type: type,
      stage: CreatureStage.egg,
      level: 1,
      experience: 0,
      obtainedAt: DateTime.now(),
    );

    return await _firestoreService.createCreature(creature);
  }

  /// Obtenir le nom par défaut d'une créature selon son type
  String _getDefaultCreatureName(CreatureType type) {
    switch (type) {
      case CreatureType.fire:
        return 'Flammy';
      case CreatureType.water:
        return 'Aqua';
      case CreatureType.earth:
        return 'Rocky';
      case CreatureType.air:
        return 'Windy';
      case CreatureType.nature:
        return 'Leafy';
    }
  }

  /// Vérifier si une créature a évolué après un gain d'expérience
  bool hasCreatureEvolved(
      CreatureModel oldCreature, CreatureModel newCreature) {
    return oldCreature.stage != newCreature.stage;
  }
}
