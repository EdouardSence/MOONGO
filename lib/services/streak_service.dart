import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moongo/models/user_model.dart';

/// Service de gestion des séries de jours (streaks)
/// Le jour se reset à 00h00 (minuit)
class StreakService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Vérifie et met à jour la streak de l'utilisateur au login
  /// Appelée à chaque fois que l'utilisateur se connecte ou ouvre l'app
  Future<StreakUpdateResult> checkAndUpdateStreak(String userId) async {
    final userDoc = await _db.collection('users').doc(userId).get();
    if (!userDoc.exists) {
      return StreakUpdateResult(
        previousStreak: 0,
        newStreak: 0,
        streakBroken: false,
        isNewDay: false,
      );
    }

    final user = UserModel.fromFirestore(userDoc);
    final now = DateTime.now();

    // Récupérer la dernière date d'activité (lastStreakDate)
    final lastActivityData = userDoc.data()?['lastStreakDate'];
    DateTime? lastStreakDate;

    if (lastActivityData != null) {
      lastStreakDate = (lastActivityData as Timestamp).toDate();
    }

    // Obtenir les dates à minuit pour comparaison
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final yesterdayMidnight = todayMidnight.subtract(const Duration(days: 1));

    DateTime? lastActivityMidnight;
    if (lastStreakDate != null) {
      lastActivityMidnight = DateTime(
          lastStreakDate.year, lastStreakDate.month, lastStreakDate.day);
    }

    int newStreak = user.currentStreak;
    bool streakBroken = false;
    bool isNewDay = false;

    if (lastActivityMidnight == null) {
      // Première activité de l'utilisateur
      newStreak = 1;
      isNewDay = true;
    } else if (lastActivityMidnight.isAtSameMomentAs(todayMidnight)) {
      // Même jour - pas de changement
      isNewDay = false;
    } else if (lastActivityMidnight.isAtSameMomentAs(yesterdayMidnight)) {
      // Jour consécutif - incrémenter la streak
      newStreak = user.currentStreak + 1;
      isNewDay = true;
    } else {
      // Plus d'un jour sans activité - streak cassée
      newStreak = 1;
      streakBroken = true;
      isNewDay = true;
    }

    // Mettre à jour Firestore seulement si c'est un nouveau jour
    if (isNewDay) {
      final longestStreak =
          newStreak > user.longestStreak ? newStreak : user.longestStreak;

      await _db.collection('users').doc(userId).update({
        'currentStreak': newStreak,
        'longestStreak': longestStreak,
        'lastStreakDate': Timestamp.fromDate(now),
        'lastLoginAt': Timestamp.fromDate(now),
      });
    } else {
      // Mettre à jour seulement le lastLoginAt
      await _db.collection('users').doc(userId).update({
        'lastLoginAt': Timestamp.fromDate(now),
      });
    }

    return StreakUpdateResult(
      previousStreak: user.currentStreak,
      newStreak: newStreak,
      streakBroken: streakBroken,
      isNewDay: isNewDay,
    );
  }

  /// Enregistre une activité pour la journée (appelée quand l'utilisateur complète une tâche)
  Future<void> recordActivity(String userId) async {
    final now = DateTime.now();
    await _db.collection('users').doc(userId).update({
      'lastStreakDate': Timestamp.fromDate(now),
    });
  }

  /// Calcule le temps restant avant le reset de minuit
  Duration getTimeUntilMidnight() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return tomorrow.difference(now);
  }

  /// Vérifie si l'utilisateur a été actif aujourd'hui
  Future<bool> hasActivityToday(String userId) async {
    final userDoc = await _db.collection('users').doc(userId).get();
    if (!userDoc.exists) return false;

    final lastActivityData = userDoc.data()?['lastStreakDate'];
    if (lastActivityData == null) return false;

    final lastStreakDate = (lastActivityData as Timestamp).toDate();
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    final lastActivityMidnight =
        DateTime(lastStreakDate.year, lastStreakDate.month, lastStreakDate.day);

    return lastActivityMidnight.isAtSameMomentAs(todayMidnight);
  }
}

/// Résultat de la mise à jour de la streak
class StreakUpdateResult {
  final int previousStreak;
  final int newStreak;
  final bool streakBroken;
  final bool isNewDay;

  StreakUpdateResult({
    required this.previousStreak,
    required this.newStreak,
    required this.streakBroken,
    required this.isNewDay,
  });

  bool get streakIncreased => newStreak > previousStreak && !streakBroken;
}
