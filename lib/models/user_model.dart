import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final DateTime? birthDate;
  final int seeds;
  final int totalSeedsEarned;
  final int totalSeedsSpent;
  final int totalTasksCompleted;
  final int currentStreak;
  final int longestStreak;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final DateTime? lastDailyReset;

  UserModel({
    required this.userId,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.birthDate,
    this.seeds = 0,
    this.totalSeedsEarned = 0,
    this.totalSeedsSpent = 0,
    this.totalTasksCompleted = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.createdAt,
    required this.lastLoginAt,
    this.lastDailyReset,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: data['userId'] ?? doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? 'Utilisateur',
      avatarUrl: data['avatarUrl'],
      birthDate: (data['birthDate'] as Timestamp?)?.toDate(),
      seeds: data['seeds'] ?? 0,
      totalSeedsEarned: data['totalSeedsEarned'] ?? 0,
      totalSeedsSpent: data['totalSeedsSpent'] ?? 0,
      totalTasksCompleted: data['totalTasksCompleted'] ?? 0,
      currentStreak: data['currentStreak'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLoginAt:
          (data['lastLoginAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastDailyReset: (data['lastDailyReset'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'birthDate': birthDate != null ? Timestamp.fromDate(birthDate!) : null,
      'seeds': seeds,
      'totalSeedsEarned': totalSeedsEarned,
      'totalSeedsSpent': totalSeedsSpent,
      'totalTasksCompleted': totalTasksCompleted,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      'lastDailyReset':
          lastDailyReset != null ? Timestamp.fromDate(lastDailyReset!) : null,
    };
  }

  UserModel copyWith({
    String? userId,
    String? email,
    String? displayName,
    String? avatarUrl,
    DateTime? birthDate,
    int? seeds,
    int? totalSeedsEarned,
    int? totalSeedsSpent,
    int? totalTasksCompleted,
    int? currentStreak,
    int? longestStreak,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    DateTime? lastDailyReset,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      birthDate: birthDate ?? this.birthDate,
      seeds: seeds ?? this.seeds,
      totalSeedsEarned: totalSeedsEarned ?? this.totalSeedsEarned,
      totalSeedsSpent: totalSeedsSpent ?? this.totalSeedsSpent,
      totalTasksCompleted: totalTasksCompleted ?? this.totalTasksCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastDailyReset: lastDailyReset ?? this.lastDailyReset,
    );
  }
}
