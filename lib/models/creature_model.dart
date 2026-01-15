import 'package:cloud_firestore/cloud_firestore.dart';

enum CreatureRarity {
  common,
  rare,
  epic,
  legendary,
}

/// Représente une espèce de créature avec sa chaîne d'évolution
class CreatureSpecies {
  final String speciesId;
  final List<String>
      evolutionNames; // Noms à chaque stade (ex: ['Moongo', 'Ivy', 'Daisy'])
  final List<int>
      evolutionLevels; // Niveaux requis pour évoluer (ex: [10, 25] = évolue au niveau 10 puis 25)
  final List<String> evolutionEmojis; // Emojis à chaque stade
  final CreatureRarity baseRarity;

  const CreatureSpecies({
    required this.speciesId,
    required this.evolutionNames,
    required this.evolutionLevels,
    required this.evolutionEmojis,
    required this.baseRarity,
  });

  int get maxStage => evolutionNames.length;
  bool get canEvolve => evolutionNames.length > 1;

  String getNameForStage(int stage) {
    final index = (stage - 1).clamp(0, evolutionNames.length - 1);
    return evolutionNames[index];
  }

  String getEmojiForStage(int stage) {
    final index = (stage - 1).clamp(0, evolutionEmojis.length - 1);
    return evolutionEmojis[index];
  }

  /// Retourne le niveau requis pour passer du stade actuel au stade suivant
  int? getLevelForNextEvolution(int currentStage) {
    if (currentStage >= maxStage) return null;
    if (currentStage - 1 >= evolutionLevels.length) return null;
    return evolutionLevels[currentStage - 1];
  }
}

/// Définition de toutes les espèces de créatures disponibles
class CreatureSpeciesData {
  static const Map<String, CreatureSpecies> species = {
    // ═══════════════════════════════════════════
    // CRÉATURES COMMUNES (3 stades max)
    // ═══════════════════════════════════════════
    'moongo': CreatureSpecies(
      speciesId: 'moongo',
      evolutionNames: ['Moongo', 'Ivy', 'Daisy'],
      evolutionLevels: [10, 25],
      evolutionEmojis: ['🌱', '🌿', '🌸'],
      baseRarity: CreatureRarity.common,
    ),
    'seedling': CreatureSpecies(
      speciesId: 'seedling',
      evolutionNames: ['Seedling', 'Sprout', 'Bloom'],
      evolutionLevels: [8, 20],
      evolutionEmojis: ['🌰', '🌱', '🌻'],
      baseRarity: CreatureRarity.common,
    ),
    'pebble': CreatureSpecies(
      speciesId: 'pebble',
      evolutionNames: ['Pebble', 'Boulder'],
      evolutionLevels: [15],
      evolutionEmojis: ['🪨', '⛰️'],
      baseRarity: CreatureRarity.common,
    ),
    'droplet': CreatureSpecies(
      speciesId: 'droplet',
      evolutionNames: ['Droplet', 'Splash', 'Tsunami'],
      evolutionLevels: [12, 28],
      evolutionEmojis: ['💧', '🌊', '🌀'],
      baseRarity: CreatureRarity.common,
    ),
    'ember': CreatureSpecies(
      speciesId: 'ember',
      evolutionNames: ['Ember', 'Flame', 'Inferno'],
      evolutionLevels: [10, 30],
      evolutionEmojis: ['🔥', '🔶', '☀️'],
      baseRarity: CreatureRarity.common,
    ),

    // ═══════════════════════════════════════════
    // CRÉATURES RARES (2-3 stades)
    // ═══════════════════════════════════════════
    'glimmer': CreatureSpecies(
      speciesId: 'glimmer',
      evolutionNames: ['Glimmer', 'Sparkle', 'Radiant'],
      evolutionLevels: [15, 35],
      evolutionEmojis: ['✨', '💫', '⭐'],
      baseRarity: CreatureRarity.rare,
    ),
    'breeze': CreatureSpecies(
      speciesId: 'breeze',
      evolutionNames: ['Breeze', 'Gust', 'Cyclone'],
      evolutionLevels: [12, 30],
      evolutionEmojis: ['🍃', '💨', '🌪️'],
      baseRarity: CreatureRarity.rare,
    ),
    'crystal': CreatureSpecies(
      speciesId: 'crystal',
      evolutionNames: ['Crystal', 'Prism'],
      evolutionLevels: [20],
      evolutionEmojis: ['💎', '🔮'],
      baseRarity: CreatureRarity.rare,
    ),
    'frosty': CreatureSpecies(
      speciesId: 'frosty',
      evolutionNames: ['Frosty', 'Glacier', 'Blizzard'],
      evolutionLevels: [14, 32],
      evolutionEmojis: ['❄️', '🧊', '☃️'],
      baseRarity: CreatureRarity.rare,
    ),

    // ═══════════════════════════════════════════
    // CRÉATURES ÉPIQUES (2 stades)
    // ═══════════════════════════════════════════
    'shadow': CreatureSpecies(
      speciesId: 'shadow',
      evolutionNames: ['Shadow', 'Phantom'],
      evolutionLevels: [25],
      evolutionEmojis: ['👤', '👻'],
      baseRarity: CreatureRarity.epic,
    ),
    'thunder': CreatureSpecies(
      speciesId: 'thunder',
      evolutionNames: ['Thunder', 'Storm', 'Tempest'],
      evolutionLevels: [18, 40],
      evolutionEmojis: ['⚡', '🌩️', '⛈️'],
      baseRarity: CreatureRarity.epic,
    ),
    'nebula': CreatureSpecies(
      speciesId: 'nebula',
      evolutionNames: ['Nebula', 'Galaxy'],
      evolutionLevels: [30],
      evolutionEmojis: ['🌌', '🪐'],
      baseRarity: CreatureRarity.epic,
    ),

    // ═══════════════════════════════════════════
    // CRÉATURES LÉGENDAIRES (1-2 stades, n'évoluent pas ou peu)
    // ═══════════════════════════════════════════
    'phoenix': CreatureSpecies(
      speciesId: 'phoenix',
      evolutionNames: ['Phoenix', 'Eternal Phoenix'],
      evolutionLevels: [50],
      evolutionEmojis: ['🦅', '🔥'],
      baseRarity: CreatureRarity.legendary,
    ),
    'dragon': CreatureSpecies(
      speciesId: 'dragon',
      evolutionNames: ['Wyrmling', 'Dragon', 'Elder Dragon'],
      evolutionLevels: [30, 60],
      evolutionEmojis: ['🐉', '🐲', '👑'],
      baseRarity: CreatureRarity.legendary,
    ),
    'celestial': CreatureSpecies(
      speciesId: 'celestial',
      evolutionNames: ['Celestial'],
      evolutionLevels: [],
      evolutionEmojis: ['🌟'],
      baseRarity: CreatureRarity.legendary,
    ),
    'unicorn': CreatureSpecies(
      speciesId: 'unicorn',
      evolutionNames: ['Unicorn'],
      evolutionLevels: [],
      evolutionEmojis: ['🦄'],
      baseRarity: CreatureRarity.legendary,
    ),
  };

  /// Récupère une espèce par son ID
  static CreatureSpecies? getSpecies(String speciesId) {
    return species[speciesId];
  }

  /// Récupère toutes les espèces d'une rareté donnée
  static List<CreatureSpecies> getSpeciesByRarity(CreatureRarity rarity) {
    return species.values.where((s) => s.baseRarity == rarity).toList();
  }

  /// Récupère une espèce aléatoire selon la rareté
  static CreatureSpecies getRandomSpeciesByRarity(CreatureRarity rarity) {
    final speciesList = getSpeciesByRarity(rarity);
    if (speciesList.isEmpty) {
      // Fallback sur Moongo si aucune espèce trouvée
      return species['moongo']!;
    }
    speciesList.shuffle();
    return speciesList.first;
  }
}

class CreatureModel {
  final String creatureId;
  final String userId;
  final String speciesId; // ID de l'espèce (ex: 'moongo')
  final String name; // Nom actuel selon le stade d'évolution
  final CreatureRarity rarity;
  final int evolutionStage; // 1 à 3 (max selon l'espèce)
  final int level; // Niveau de la créature (1-100)
  final int currentXp;
  final int totalXp;
  final String obtainedFrom; // basic_egg, premium_egg, legendary_egg
  final DateTime obtainedAt;
  final DateTime createdAt;
  final DateTime? lastFedAt;

  CreatureModel({
    required this.creatureId,
    required this.userId,
    required this.speciesId,
    required this.name,
    required this.rarity,
    this.evolutionStage = 1,
    this.level = 1,
    this.currentXp = 0,
    this.totalXp = 0,
    required this.obtainedFrom,
    required this.obtainedAt,
    required this.createdAt,
    this.lastFedAt,
  });

  /// Récupère les données de l'espèce
  CreatureSpecies get species =>
      CreatureSpeciesData.getSpecies(speciesId) ??
      CreatureSpeciesData.species['moongo']!;

  // Emojis par stade d'évolution (legacy, pour compatibilité)
  static const Map<int, String> stageEmojis = {
    1: '🌱',
    2: '🌿',
    3: '🌸',
  };

  // XP requis pour passer au niveau suivant
  static int xpRequiredForLevel(int level) {
    // Formule progressive: les niveaux supérieurs demandent plus d'XP
    return 10 + (level * 5);
  }

  // Couleurs par rareté
  static Map<CreatureRarity, List<int>> rarityColors = {
    CreatureRarity.common: [0xFF9CA3AF, 0xFF6B7280], // Gris
    CreatureRarity.rare: [0xFF60A5FA, 0xFF3B82F6], // Bleu
    CreatureRarity.epic: [0xFFA855F7, 0xFFEC4899], // Violet-Rose
    CreatureRarity.legendary: [0xFFFBBF24, 0xFFF97316], // Jaune-Orange
  };

  String get emoji => species.getEmojiForStage(evolutionStage);

  bool get isMaxEvolution => evolutionStage >= species.maxStage;

  bool get isMaxLevel => level >= 100;

  int get xpToNextLevel => isMaxLevel ? 0 : xpRequiredForLevel(level);

  double get progressToNextLevel {
    if (isMaxLevel) return 1.0;
    return currentXp / xpToNextLevel;
  }

  /// Vérifie si la créature peut évoluer au niveau actuel
  bool get canEvolve {
    if (isMaxEvolution) return false;
    final requiredLevel = species.getLevelForNextEvolution(evolutionStage);
    if (requiredLevel == null) return false;
    return level >= requiredLevel;
  }

  /// Retourne le niveau requis pour la prochaine évolution
  int? get levelForNextEvolution =>
      species.getLevelForNextEvolution(evolutionStage);

  /// Retourne le nom de la prochaine évolution
  String? get nextEvolutionName {
    if (isMaxEvolution) return null;
    return species.getNameForStage(evolutionStage + 1);
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

    // Récupérer le speciesId ou le déduire du nom pour rétrocompatibilité
    String speciesId = data['speciesId'] ?? 'moongo';

    // Si pas de speciesId stocké, essayer de le déduire du nom
    if (data['speciesId'] == null && data['name'] != null) {
      final nameToCheck = (data['name'] as String).toLowerCase();
      for (final entry in CreatureSpeciesData.species.entries) {
        for (final evolutionName in entry.value.evolutionNames) {
          if (evolutionName.toLowerCase() == nameToCheck) {
            speciesId = entry.key;
            break;
          }
        }
      }
    }

    return CreatureModel(
      creatureId: data['creatureId'] ?? doc.id,
      userId: data['userId'] ?? '',
      speciesId: speciesId,
      name: data['name'] ?? 'Créature',
      rarity: CreatureRarity.values.firstWhere(
        (e) => e.name == data['rarity'],
        orElse: () => CreatureRarity.common,
      ),
      evolutionStage: data['evolutionStage'] ?? 1,
      level: data['level'] ?? 1,
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
      'speciesId': speciesId,
      'name': name,
      'rarity': rarity.name,
      'evolutionStage': evolutionStage,
      'level': level,
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
    String? speciesId,
    String? name,
    CreatureRarity? rarity,
    int? evolutionStage,
    int? level,
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
      speciesId: speciesId ?? this.speciesId,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      evolutionStage: evolutionStage ?? this.evolutionStage,
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      totalXp: totalXp ?? this.totalXp,
      obtainedFrom: obtainedFrom ?? this.obtainedFrom,
      obtainedAt: obtainedAt ?? this.obtainedAt,
      createdAt: createdAt ?? this.createdAt,
      lastFedAt: lastFedAt ?? this.lastFedAt,
    );
  }

  /// Ajouter de l'XP, gérer les niveaux et l'évolution
  /// Retourne la créature mise à jour avec éventuellement un nouveau niveau/stade
  CreatureModel addXp(int xpAmount) {
    if (isMaxLevel) return this;

    int newXp = currentXp + xpAmount;
    int newTotalXp = totalXp + xpAmount;
    int newLevel = level;
    int newStage = evolutionStage;
    String newName = name;

    // Monter de niveau tant qu'on a assez d'XP
    while (!isMaxLevel &&
        newLevel < 100 &&
        newXp >= xpRequiredForLevel(newLevel)) {
      newXp -= xpRequiredForLevel(newLevel);
      newLevel++;

      // Vérifier si on peut évoluer à ce niveau
      final requiredLevel = species.getLevelForNextEvolution(newStage);
      if (requiredLevel != null &&
          newLevel >= requiredLevel &&
          newStage < species.maxStage) {
        newStage++;
        newName = species.getNameForStage(newStage);
      }
    }

    return copyWith(
      currentXp: newLevel >= 100 ? 0 : newXp,
      totalXp: newTotalXp,
      level: newLevel,
      evolutionStage: newStage,
      name: newName,
      lastFedAt: DateTime.now(),
    );
  }
}
