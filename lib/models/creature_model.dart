import 'package:json_annotation/json_annotation.dart';

part 'creature_model.g.dart';

enum CreatureStage {
  egg,
  baby,
  teen,
  adult,
  legendary,
}

enum CreatureType {
  fire,
  water,
  earth,
  air,
  nature,
}

@JsonSerializable()
class CreatureModel {
  final String id;
  final String userId;
  final String name;
  final CreatureType type;
  final CreatureStage stage;
  final int level;
  final int experience;
  final int experienceToNextLevel;
  final DateTime obtainedAt;
  final DateTime? lastFed;

  CreatureModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    this.stage = CreatureStage.egg,
    this.level = 1,
    this.experience = 0,
    int? experienceToNextLevel,
    required this.obtainedAt,
    this.lastFed,
  }) : experienceToNextLevel =
            experienceToNextLevel ?? _calculateExpToNextLevel(1);

  static int _calculateExpToNextLevel(int level) {
    return (level * 100 * 1.5).round();
  }

  factory CreatureModel.fromJson(Map<String, dynamic> json) =>
      _$CreatureModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreatureModelToJson(this);

  CreatureModel copyWith({
    String? id,
    String? userId,
    String? name,
    CreatureType? type,
    CreatureStage? stage,
    int? level,
    int? experience,
    int? experienceToNextLevel,
    DateTime? obtainedAt,
    DateTime? lastFed,
  }) {
    return CreatureModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      type: type ?? this.type,
      stage: stage ?? this.stage,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      experienceToNextLevel:
          experienceToNextLevel ?? this.experienceToNextLevel,
      obtainedAt: obtainedAt ?? this.obtainedAt,
      lastFed: lastFed ?? this.lastFed,
    );
  }

  /// Ajoute de l'expérience et retourne une créature mise à jour
  CreatureModel addExperience(int exp) {
    int newExp = experience + exp;
    int newLevel = level;
    int expNeeded = experienceToNextLevel;
    CreatureStage newStage = stage;

    // Level up logic
    while (newExp >= expNeeded) {
      newExp -= expNeeded;
      newLevel++;
      expNeeded = _calculateExpToNextLevel(newLevel);

      // Evolution logic basée sur le niveau
      if (newLevel >= 50 && stage != CreatureStage.legendary) {
        newStage = CreatureStage.legendary;
      } else if (newLevel >= 30 && stage == CreatureStage.teen) {
        newStage = CreatureStage.adult;
      } else if (newLevel >= 15 && stage == CreatureStage.baby) {
        newStage = CreatureStage.teen;
      } else if (newLevel >= 5 && stage == CreatureStage.egg) {
        newStage = CreatureStage.baby;
      }
    }

    return copyWith(
      experience: newExp,
      level: newLevel,
      experienceToNextLevel: expNeeded,
      stage: newStage,
      lastFed: DateTime.now(),
    );
  }

  double get progressToNextLevel {
    return experience / experienceToNextLevel;
  }
}
