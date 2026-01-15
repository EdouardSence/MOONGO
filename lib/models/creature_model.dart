import 'package:cloud_firestore/cloud_firestore.dart';

enum CreatureRarity {
  common,
  rare,
  epic,
  legendary,
}

/// Représente une espèce de créature avec sa chaîne d'évolution
/// Les données sont chargées depuis Firestore (collection: creature_species)
class CreatureSpecies {
  final String speciesId;
  final List<String> evolutionNames;
  final List<int> evolutionLevels;
  final List<String> evolutionEmojis;
  final CreatureRarity baseRarity;
  final int baseLevel;
  final String basePicture; // URL de l'image principale (grande)
  final String parcPicture; // URL de l'image pour le parc (petite)

  const CreatureSpecies({
    required this.speciesId,
    required this.evolutionNames,
    required this.evolutionLevels,
    required this.evolutionEmojis,
    required this.baseRarity,
    this.baseLevel = 1,
    this.basePicture = '',
    this.parcPicture = '',
  });

  /// Espèce par défaut (fallback)
  static const CreatureSpecies defaultSpecies = CreatureSpecies(
    speciesId: 'unknown',
    evolutionNames: ['Créature'],
    evolutionLevels: [],
    evolutionEmojis: ['❓'],
    baseRarity: CreatureRarity.common,
  );

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

  /// Vérifie si l'espèce a une image configurée
  bool get hasBasePicture => basePicture.isNotEmpty;
  bool get hasParcPicture => parcPicture.isNotEmpty;

  /// Crée une espèce depuis un document Firestore
  factory CreatureSpecies.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CreatureSpecies.fromMap(data, doc.id);
  }

  /// Crée une espèce depuis une Map
  factory CreatureSpecies.fromMap(Map<String, dynamic> data, [String? docId]) {
    return CreatureSpecies(
      speciesId: data['speciesId'] ?? docId ?? 'unknown',
      evolutionNames: List<String>.from(data['evolutionNames'] ?? ['Créature']),
      evolutionLevels: List<int>.from(data['evolutionLevels'] ?? []),
      evolutionEmojis: List<String>.from(data['evolutionEmojis'] ?? ['❓']),
      baseRarity: CreatureRarity.values.firstWhere(
        (e) => e.name == data['baseRarity'],
        orElse: () => CreatureRarity.common,
      ),
      baseLevel: data['baseLevel'] ?? 1,
      basePicture: data['basePicture'] ?? '',
      parcPicture: data['parcPicture'] ?? '',
    );
  }

  /// Convertit l'espèce en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'speciesId': speciesId,
      'evolutionNames': evolutionNames,
      'evolutionLevels': evolutionLevels,
      'evolutionEmojis': evolutionEmojis,
      'baseRarity': baseRarity.name,
      'baseLevel': baseLevel,
      'basePicture': basePicture,
      'parcPicture': parcPicture,
    };
  }
}

/// Modèle d'une créature possédée par un utilisateur
class CreatureModel {
  final String creatureId;
  final String userId;
  final String speciesId;
  final String name;
  final CreatureRarity rarity;
  final int evolutionStage;
  final int level;
  final int currentXp;
  final int totalXp;
  final String obtainedFrom;
  final DateTime obtainedAt;
  final DateTime createdAt;
  final DateTime? lastFedAt;

  // Données de l'espèce (chargées depuis Firestore)
  final CreatureSpecies? _speciesData;

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
    CreatureSpecies? speciesData,
  }) : _speciesData = speciesData;

  /// Récupère les données de l'espèce (fallback si non chargées)
  CreatureSpecies get species => _speciesData ?? CreatureSpecies.defaultSpecies;

  /// Met à jour les données de l'espèce
  CreatureModel withSpeciesData(CreatureSpecies speciesData) {
    return copyWith(speciesData: speciesData);
  }

  // ═══════════════════════════════════════════
  // IMAGES
  // ═══════════════════════════════════════════

  /// URL de l'image principale (ou null si pas disponible)
  String? get basePictureUrl {
    final url = species.basePicture;
    return url.isNotEmpty ? url : null;
  }

  /// URL de l'image du parc (ou null si pas disponible)
  String? get parcPictureUrl {
    final url = species.parcPicture;
    return url.isNotEmpty ? url : null;
  }

  /// Vérifie si une image principale est disponible
  bool get hasBasePicture => basePictureUrl != null;

  /// Vérifie si une image de parc est disponible
  bool get hasParcPicture => parcPictureUrl != null;

  // ═══════════════════════════════════════════
  // XP & NIVEAUX
  // ═══════════════════════════════════════════

  /// XP requis pour passer au niveau suivant
  static int xpRequiredForLevel(int level) {
    return 10 + (level * 5);
  }

  /// Couleurs par rareté [couleur1, couleur2] pour les dégradés
  static Map<CreatureRarity, List<int>> rarityColors = {
    CreatureRarity.common: [0xFF9CA3AF, 0xFF6B7280],
    CreatureRarity.rare: [0xFF60A5FA, 0xFF3B82F6],
    CreatureRarity.epic: [0xFFA855F7, 0xFFEC4899],
    CreatureRarity.legendary: [0xFFFBBF24, 0xFFF97316],
  };

  String get emoji => species.getEmojiForStage(evolutionStage);

  bool get isMaxEvolution => evolutionStage >= species.maxStage;

  bool get isMaxLevel => level >= 100;

  int get xpToNextLevel => isMaxLevel ? 0 : xpRequiredForLevel(level);

  double get progressToNextLevel {
    if (isMaxLevel) return 1.0;
    if (xpToNextLevel <= 0) return 0.0;
    return (currentXp / xpToNextLevel).clamp(0.0, 1.0);
  }

  bool get canEvolve {
    if (isMaxEvolution) return false;
    final requiredLevel = species.getLevelForNextEvolution(evolutionStage);
    if (requiredLevel == null) return false;
    return level >= requiredLevel;
  }

  int? get levelForNextEvolution =>
      species.getLevelForNextEvolution(evolutionStage);

  String? get nextEvolutionName {
    if (isMaxEvolution) return null;
    return species.getNameForStage(evolutionStage + 1);
  }

  // ═══════════════════════════════════════════
  // LABELS
  // ═══════════════════════════════════════════

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
        return '⚪';
      case CreatureRarity.rare:
        return '🔵';
      case CreatureRarity.epic:
        return '🟣';
      case CreatureRarity.legendary:
        return '🟡';
    }
  }

  // ═══════════════════════════════════════════
  // FIRESTORE
  // ═══════════════════════════════════════════

  factory CreatureModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Essayer de déduire le speciesId à partir du nom si non présent
    String speciesId = data['speciesId'] ?? 'unknown';
    if (speciesId == 'unknown' && data['name'] != null) {
      // Convertir le nom en speciesId (ex: "Moongo" -> "moongo"),
      // mais uniquement si le résultat correspond au format attendu.
      final candidateSpeciesId = (data['name'] as String).toLowerCase().trim();
      final validSpeciesIdPattern = RegExp(r'^[a-z0-9_]+$');
      if (validSpeciesIdPattern.hasMatch(candidateSpeciesId)) {
        speciesId = candidateSpeciesId;
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

  // ═══════════════════════════════════════════
  // COPY & UPDATE
  // ═══════════════════════════════════════════

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
    CreatureSpecies? speciesData,
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
      speciesData: speciesData ?? _speciesData,
    );
  }

  /// Ajouter de l'XP, gérer les niveaux et l'évolution
  CreatureModel addXp(int xpAmount) {
    if (isMaxLevel) return this;

    int newXp = currentXp + xpAmount;
    int newTotalXp = totalXp + xpAmount;
    int newLevel = level;
    int newStage = evolutionStage;
    String newName = name;

    while (newLevel < 100 && newXp >= xpRequiredForLevel(newLevel)) {
      newXp -= xpRequiredForLevel(newLevel);
      newLevel++;

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
