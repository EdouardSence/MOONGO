import 'package:cloud_firestore/cloud_firestore.dart';

enum CreatureRarity {
  common,
  rare,
  epic,
  legendary,
}

class CreatureModel {
  final String creatureId;
  final String userId;
  final String name;
  final CreatureRarity rarity;
  final int evolutionStage; // 1 à 5
  final int currentXp;
  final int totalXp;
  final String obtainedFrom; // basic_egg, premium_egg, legendary_egg
  final DateTime obtainedAt;
  final DateTime createdAt;
  final DateTime? lastFedAt;

  CreatureModel({
    required this.creatureId,
    required this.userId,
    required this.name,
    required this.rarity,
    this.evolutionStage = 1,
    this.currentXp = 0,
    this.totalXp = 0,
    required this.obtainedFrom,
    required this.obtainedAt,
    required this.createdAt,
    this.lastFedAt,
  });

  // Noms aléatoires pour les créatures
  static const List<String> randomNames = [
    'Moongo',
    'Seedling',
    'Sprout',
    'Bloom',
    'Petal',
    'Flora',
    'Leafy',
    'Blossom',
    'Fern',
    'Ivy',
    'Clover',
    'Daisy',
    'Tulip',
    'Rose',
    'Lily',
    'Orchid',
    'Violet',
    'Jasmine',
  ];

  // Emojis par stade d'évolution
  static const Map<int, String> stageEmojis = {
    1: '🥚',
    2: '🐣',
    3: '🐥',
    4: '🐤',
    5: '🦜',
  };

  // XP requis pour passer au stade suivant
  static int xpRequiredForStage(int stage) {
    return stage * 50; // 50, 100, 150, 200
  }

  // Couleurs par rareté
  static Map<CreatureRarity, List<int>> rarityColors = {
    CreatureRarity.common: [0xFF9CA3AF, 0xFF6B7280], // Gris
    CreatureRarity.rare: [0xFF60A5FA, 0xFF3B82F6], // Bleu
    CreatureRarity.epic: [0xFFA855F7, 0xFFEC4899], // Violet-Rose
    CreatureRarity.legendary: [0xFFFBBF24, 0xFFF97316], // Jaune-Orange
  };

  String get emoji => stageEmojis[evolutionStage] ?? '🥚';

  bool get isMaxLevel => evolutionStage >= 5;

  int get xpToNextStage => isMaxLevel ? 0 : xpRequiredForStage(evolutionStage);

  double get progressToNextStage {
    if (isMaxLevel) return 1.0;
    return currentXp / xpToNextStage;
  }

  String get rarityLabel {
    switch (rarity) {
      case CreatureRarity.common:
        return 'Commun';
      case CreatureRarity.rare:
        return 'Rare';
      case CreatureRarity.epic:
        return 'Épique';
      case CreatureRarity.legendary:
        return 'Légendaire';
    }
  }

  String get rarityEmoji {
    switch (rarity) {
      case CreatureRarity.common:
        return '🔘';
      case CreatureRarity.rare:
        return '🔵';
      case CreatureRarity.epic:
        return '🟣';
      case CreatureRarity.legendary:
        return '🟡';
    }
  }

  factory CreatureModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CreatureModel(
      creatureId: data['creatureId'] ?? doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? 'Créature',
      rarity: CreatureRarity.values.firstWhere(
        (e) => e.name == data['rarity'],
        orElse: () => CreatureRarity.common,
      ),
      evolutionStage: data['evolutionStage'] ?? 1,
      currentXp: data['currentXp'] ?? 0,
      totalXp: data['totalXp'] ?? 0,
      obtainedFrom: data['obtainedFrom'] ?? 'basic_egg',
      obtainedAt:
          (data['obtainedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastFedAt: (data['lastFedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'creatureId': creatureId,
      'userId': userId,
      'name': name,
      'rarity': rarity.name,
      'evolutionStage': evolutionStage,
      'currentXp': currentXp,
      'totalXp': totalXp,
      'obtainedFrom': obtainedFrom,
      'obtainedAt': Timestamp.fromDate(obtainedAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'lastFedAt': lastFedAt != null ? Timestamp.fromDate(lastFedAt!) : null,
    };
  }

  CreatureModel copyWith({
    String? creatureId,
    String? userId,
    String? name,
    CreatureRarity? rarity,
    int? evolutionStage,
    int? currentXp,
    int? totalXp,
    String? obtainedFrom,
    DateTime? obtainedAt,
    DateTime? createdAt,
    DateTime? lastFedAt,
  }) {
    return CreatureModel(
      creatureId: creatureId ?? this.creatureId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      evolutionStage: evolutionStage ?? this.evolutionStage,
      currentXp: currentXp ?? this.currentXp,
      totalXp: totalXp ?? this.totalXp,
      obtainedFrom: obtainedFrom ?? this.obtainedFrom,
      obtainedAt: obtainedAt ?? this.obtainedAt,
      createdAt: createdAt ?? this.createdAt,
      lastFedAt: lastFedAt ?? this.lastFedAt,
    );
  }

  // Ajouter de l'XP et gérer l'évolution
  CreatureModel addXp(int xpAmount) {
    if (isMaxLevel) return this;

    int newXp = currentXp + xpAmount;
    int newTotalXp = totalXp + xpAmount;
    int newStage = evolutionStage;

    // Vérifier si on peut évoluer
    while (newStage < 5 && newXp >= xpRequiredForStage(newStage)) {
      newXp -= xpRequiredForStage(newStage);
      newStage++;
    }

    return copyWith(
      currentXp: newStage >= 5 ? 0 : newXp,
      totalXp: newTotalXp,
      evolutionStage: newStage,
      lastFedAt: DateTime.now(),
    );
  }
}
