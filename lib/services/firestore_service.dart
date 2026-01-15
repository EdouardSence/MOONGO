import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/models/shop_item_model.dart';
import 'package:moongo/models/task_model.dart';
import 'package:moongo/models/user_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // ═══════════════════════════════════════════
  // USERS
  // ═══════════════════════════════════════════

  /// Récupère le profil utilisateur
  Future<UserModel?> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  /// Stream du profil utilisateur (temps réel)
  Stream<UserModel?> userStream(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserModel.fromFirestore(doc);
    });
  }

  /// Crée un nouveau profil utilisateur
  Future<UserModel> createUser({
    required String userId,
    required String email,
    String? displayName,
  }) async {
    final now = DateTime.now();
    final user = UserModel(
      userId: userId,
      email: email,
      displayName: displayName ?? 'Joueur',
      seeds: 100, // Bonus de départ
      createdAt: now,
      lastLoginAt: now,
    );
    await _db.collection('users').doc(userId).set(user.toFirestore());
    return user;
  }

  /// Crée un utilisateur avec avatar emoji (onboarding)
  Future<UserModel> createUserWithAvatar({
    required String userId,
    required String email,
    required String displayName,
    required String avatarEmoji,
    DateTime? birthDate,
  }) async {
    final now = DateTime.now();
    final user = UserModel(
      userId: userId,
      email: email,
      displayName: displayName,
      avatarUrl: avatarEmoji, // On utilise avatarUrl pour stocker l'emoji
      birthDate: birthDate,
      seeds: 100, // Bonus de départ
      createdAt: now,
      lastLoginAt: now,
    );
    await _db.collection('users').doc(userId).set(user.toFirestore());
    return user;
  }

  /// Vérifie si l'utilisateur existe dans Firestore
  Future<bool> userExists(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.exists;
  }

  /// Met à jour le profil utilisateur
  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.userId).update(user.toFirestore());
  }

  /// Met à jour les graines de l'utilisateur
  Future<void> updateSeeds(String userId, int seedsDelta,
      {bool isSpending = false}) async {
    final updates = <String, dynamic>{
      'seeds': FieldValue.increment(seedsDelta),
    };

    if (isSpending) {
      updates['totalSeedsSpent'] = FieldValue.increment(-seedsDelta);
    } else {
      updates['totalSeedsEarned'] = FieldValue.increment(seedsDelta);
    }

    await _db.collection('users').doc(userId).update(updates);
  }

  /// Met à jour la streak
  Future<void> updateStreak(String userId, int newStreak) async {
    final userDoc = await _db.collection('users').doc(userId).get();
    final currentLongest = userDoc.data()?['longestStreak'] ?? 0;

    await _db.collection('users').doc(userId).update({
      'currentStreak': newStreak,
      'longestStreak': newStreak > currentLongest ? newStreak : currentLongest,
    });
  }

  // ═══════════════════════════════════════════
  // TASKS
  // ═══════════════════════════════════════════

  /// Récupère toutes les tâches de l'utilisateur
  Stream<List<TaskModel>> tasksStream(String userId) {
    return _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where('isArchived', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    });
  }

  /// Crée une nouvelle tâche
  Future<TaskModel> createTask({
    required String userId,
    required String title,
    String? description,
    String icon = '✨',
    String color = '#6366F1',
    required TaskType type,
    RecurrenceConfig? recurrence,
    DateTime? dueDate,
    int seedsReward = 10,
    List<SubTask>? subTasks,
  }) async {
    final now = DateTime.now();
    final taskId = _uuid.v4();

    final task = TaskModel(
      taskId: taskId,
      userId: userId,
      title: title,
      description: description,
      icon: icon,
      color: color,
      type: type,
      recurrence: recurrence,
      dueDate: dueDate,
      seedsReward: seedsReward,
      subTasks: subTasks ?? [],
      createdAt: now,
      updatedAt: now,
    );

    await _db.collection('tasks').doc(taskId).set(task.toFirestore());
    return task;
  }

  /// Met à jour une tâche
  Future<void> updateTask(TaskModel task) async {
    await _db.collection('tasks').doc(task.taskId).update(
          task.copyWith(updatedAt: DateTime.now()).toFirestore(),
        );
  }

  /// Complète une tâche et retourne les graines gagnées
  Future<int> completeTask(String userId, TaskModel task) async {
    final now = DateTime.now();

    // Marquer la tâche comme complétée
    await _db.collection('tasks').doc(task.taskId).update({
      'completed': true,
      'completedAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    });

    // Ajouter les graines à l'utilisateur
    await updateSeeds(userId, task.seedsReward);

    // Incrémenter le compteur de tâches
    await _db.collection('users').doc(userId).update({
      'totalTasksCompleted': FieldValue.increment(1),
    });

    return task.seedsReward;
  }

  /// Complète une sous-tâche d'un objectif
  Future<void> completeSubTask(TaskModel task, String subTaskId) async {
    final updatedSubTasks = task.subTasks.map((st) {
      if (st.id == subTaskId) {
        return st.copyWith(completed: true, completedAt: DateTime.now());
      }
      return st;
    }).toList();

    // Vérifier si toutes les sous-tâches sont complétées
    final allCompleted = updatedSubTasks.every((st) => st.completed);

    await _db.collection('tasks').doc(task.taskId).update({
      'subTasks': updatedSubTasks.map((st) => st.toMap()).toList(),
      'completed': allCompleted,
      'completedAt': allCompleted ? Timestamp.fromDate(DateTime.now()) : null,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Ajoute une sous-tâche à un objectif
  Future<void> addSubTask(String taskId, SubTask subTask) async {
    await _db.collection('tasks').doc(taskId).update({
      'subTasks': FieldValue.arrayUnion([subTask.toMap()]),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Supprime une tâche (soft delete)
  Future<void> archiveTask(String taskId) async {
    await _db.collection('tasks').doc(taskId).update({
      'isArchived': true,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Supprime définitivement une tâche
  Future<void> deleteTask(String taskId) async {
    await _db.collection('tasks').doc(taskId).delete();
  }

  /// Reset quotidien des tâches récurrentes
  Future<void> resetRecurringTasks(String userId) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final tasksSnapshot = await _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: TaskType.recurring.name)
        .where('completed', isEqualTo: true)
        .get();

    final batch = _db.batch();

    for (final doc in tasksSnapshot.docs) {
      final completedAt = (doc.data()['completedAt'] as Timestamp?)?.toDate();
      if (completedAt != null) {
        final completedDate =
            DateTime(completedAt.year, completedAt.month, completedAt.day);
        if (completedDate.isBefore(today)) {
          // Réinitialiser les sous-tâches aussi
          final subTasks = (doc.data()['subTasks'] as List<dynamic>?) ?? [];
          final resetSubTasks = subTasks.map((st) {
            if (st is Map<String, dynamic>) {
              return {...st, 'completed': false, 'completedAt': null};
            }
            return st;
          }).toList();

          batch.update(doc.reference, {
            'completed': false,
            'completedAt': null,
            'subTasks': resetSubTasks,
            'updatedAt': Timestamp.fromDate(now),
          });
        }
      }
    }

    await batch.commit();

    // Mettre à jour la date du dernier reset
    await _db.collection('users').doc(userId).update({
      'lastDailyReset': Timestamp.fromDate(now),
    });
  }

  // ═══════════════════════════════════════════
  // CREATURES
  // ═══════════════════════════════════════════

  /// Récupère toutes les créatures de l'utilisateur
  Stream<List<CreatureModel>> creaturesStream(String userId) {
    return _db
        .collection('creatures')
        .where('userId', isEqualTo: userId)
        .orderBy('obtainedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CreatureModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Achète un œuf et retourne la créature obtenue
  Future<CreatureModel?> buyEgg(
      String userId, EggItem egg, int currentSeeds) async {
    if (currentSeeds < egg.price) return null;

    // Déduire les graines
    await updateSeeds(userId, -egg.price, isSpending: true);

    // Tirer la rareté
    final rarity = _rollRarity(egg.dropRates);

    // Récupérer une espèce aléatoire correspondant à la rareté
    final species = CreatureSpeciesData.getRandomSpeciesByRarity(rarity);

    // Créer la créature
    final now = DateTime.now();
    final creatureId = _uuid.v4();
    final name = species.getNameForStage(1); // Nom du stade 1

    final creature = CreatureModel(
      creatureId: creatureId,
      userId: userId,
      speciesId: species.speciesId,
      name: name,
      rarity: rarity,
      obtainedFrom: egg.id,
      obtainedAt: now,
      createdAt: now,
    );

    await _db
        .collection('creatures')
        .doc(creatureId)
        .set(creature.toFirestore());

    return creature;
  }

  /// Nourrit une créature et retourne si elle a évolué
  Future<bool> feedCreature(String userId, CreatureModel creature,
      FoodItem food, int currentSeeds) async {
    if (currentSeeds < food.price) return false;
    if (creature.isMaxLevel) return false;

    // Déduire les graines
    await updateSeeds(userId, -food.price, isSpending: true);

    // Ajouter l'XP
    final oldStage = creature.evolutionStage;
    final updatedCreature = creature.addXp(food.xpGiven);

    await _db.collection('creatures').doc(creature.creatureId).update(
          updatedCreature.toFirestore(),
        );

    return updatedCreature.evolutionStage > oldStage;
  }

  /// Tire une rareté selon les taux
  CreatureRarity _rollRarity(Map<CreatureRarity, double> dropRates) {
    final random = Random().nextDouble();
    double cumulative = 0;

    for (final entry in dropRates.entries) {
      cumulative += entry.value;
      if (random < cumulative) {
        return entry.key;
      }
    }
    return CreatureRarity.common;
  }

  // ═══════════════════════════════════════════
  // STATS
  // ═══════════════════════════════════════════

  /// Récupère les statistiques de l'utilisateur
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final user = await getUser(userId);
    if (user == null) return {};

    final tasksSnapshot = await _db
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where('isArchived', isEqualTo: false)
        .get();

    final creaturesSnapshot = await _db
        .collection('creatures')
        .where('userId', isEqualTo: userId)
        .get();

    final totalTasks = tasksSnapshot.docs.length;
    final completedTasks = tasksSnapshot.docs
        .where((doc) => doc.data()['completed'] == true)
        .length;

    return {
      'seeds': user.seeds,
      'totalSeedsEarned': user.totalSeedsEarned,
      'currentStreak': user.currentStreak,
      'longestStreak': user.longestStreak,
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'completionRate': totalTasks > 0 ? completedTasks / totalTasks : 0.0,
      'totalCreatures': creaturesSnapshot.docs.length,
      'memberSince': user.createdAt,
    };
  }
}
