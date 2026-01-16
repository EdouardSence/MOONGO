/// Script pour peupler Firestore avec les espèces de créatures
///
/// Usage:
///   cd scripts
///   dart pub get
///   dart seed_creatures.dart
///
/// Ce script doit être exécuté une seule fois pour initialiser la base de données.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../lib/firebase_options.dart';

// ═══════════════════════════════════════════
// DÉFINITION DES ESPÈCES DE CRÉATURES
// ═══════════════════════════════════════════

final Map<String, Map<String, dynamic>> creatureSpecies = {
  // ═══════════════════════════════════════════
  // CRÉATURES COMMUNES (3 stades max)
  // ═══════════════════════════════════════════
  'moongo': {
    'speciesId': 'moongo',
    'evolutionNames': ['Moongo', 'Ivy', 'Daisy'],
    'evolutionLevels': [10, 25],
    'evolutionEmojis': ['🌱', '🌿', '🌸'],
    'baseRarity': 'common',
  },
  'seedling': {
    'speciesId': 'seedling',
    'evolutionNames': ['Seedling', 'Sprout', 'Bloom'],
    'evolutionLevels': [8, 20],
    'evolutionEmojis': ['🌰', '🌱', '🌻'],
    'baseRarity': 'common',
  },
  'pebble': {
    'speciesId': 'pebble',
    'evolutionNames': ['Pebble', 'Boulder'],
    'evolutionLevels': [15],
    'evolutionEmojis': ['🪨', '⛰️'],
    'baseRarity': 'common',
  },
  'droplet': {
    'speciesId': 'droplet',
    'evolutionNames': ['Droplet', 'Splash', 'Tsunami'],
    'evolutionLevels': [12, 28],
    'evolutionEmojis': ['💧', '🌊', '🌀'],
    'baseRarity': 'common',
  },
  'ember': {
    'speciesId': 'ember',
    'evolutionNames': ['Ember', 'Flame', 'Inferno'],
    'evolutionLevels': [10, 30],
    'evolutionEmojis': ['🔥', '🔶', '☀️'],
    'baseRarity': 'common',
  },

  // ═══════════════════════════════════════════
  // CRÉATURES RARES (2-3 stades)
  // ═══════════════════════════════════════════
  'glimmer': {
    'speciesId': 'glimmer',
    'evolutionNames': ['Glimmer', 'Sparkle', 'Radiant'],
    'evolutionLevels': [15, 35],
    'evolutionEmojis': ['✨', '💫', '⭐'],
    'baseRarity': 'rare',
  },
  'breeze': {
    'speciesId': 'breeze',
    'evolutionNames': ['Breeze', 'Gust', 'Cyclone'],
    'evolutionLevels': [12, 30],
    'evolutionEmojis': ['🍃', '💨', '🌪️'],
    'baseRarity': 'rare',
  },
  'crystal': {
    'speciesId': 'crystal',
    'evolutionNames': ['Crystal', 'Prism'],
    'evolutionLevels': [20],
    'evolutionEmojis': ['💎', '🔮'],
    'baseRarity': 'rare',
  },
  'frosty': {
    'speciesId': 'frosty',
    'evolutionNames': ['Frosty', 'Glacier', 'Blizzard'],
    'evolutionLevels': [14, 32],
    'evolutionEmojis': ['❄️', '🧊', '☃️'],
    'baseRarity': 'rare',
  },

  // ═══════════════════════════════════════════
  // CRÉATURES ÉPIQUES (2 stades)
  // ═══════════════════════════════════════════
  'shadow': {
    'speciesId': 'shadow',
    'evolutionNames': ['Shadow', 'Phantom'],
    'evolutionLevels': [25],
    'evolutionEmojis': ['👤', '👻'],
    'baseRarity': 'epic',
  },
  'thunder': {
    'speciesId': 'thunder',
    'evolutionNames': ['Thunder', 'Storm', 'Tempest'],
    'evolutionLevels': [18, 40],
    'evolutionEmojis': ['⚡', '🌩️', '⛈️'],
    'baseRarity': 'epic',
  },
  'nebula': {
    'speciesId': 'nebula',
    'evolutionNames': ['Nebula', 'Galaxy'],
    'evolutionLevels': [30],
    'evolutionEmojis': ['🌌', '🪐'],
    'baseRarity': 'epic',
  },

  // ═══════════════════════════════════════════
  // CRÉATURES LÉGENDAIRES (1-2 stades)
  // ═══════════════════════════════════════════
  'phoenix': {
    'speciesId': 'phoenix',
    'evolutionNames': ['Phoenix', 'Eternal Phoenix'],
    'evolutionLevels': [50],
    'evolutionEmojis': ['🦅', '🔥'],
    'baseRarity': 'legendary',
  },
  'dragon': {
    'speciesId': 'dragon',
    'evolutionNames': ['Wyrmling', 'Dragon', 'Elder Dragon'],
    'evolutionLevels': [30, 60],
    'evolutionEmojis': ['🐉', '🐲', '👑'],
    'baseRarity': 'legendary',
  },
  'celestial': {
    'speciesId': 'celestial',
    'evolutionNames': ['Celestial'],
    'evolutionLevels': <int>[],
    'evolutionEmojis': ['🌟'],
    'baseRarity': 'legendary',
  },
  'unicorn': {
    'speciesId': 'unicorn',
    'evolutionNames': ['Unicorn'],
    'evolutionLevels': <int>[],
    'evolutionEmojis': ['🦄'],
    'baseRarity': 'legendary',
  },
};

Future<void> main() async {
  print('🚀 Initialisation de Firebase...');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final db = FirebaseFirestore.instance;

  print('📦 Peuplement de la collection creature_species...');

  final batch = db.batch();

  for (final entry in creatureSpecies.entries) {
    final docRef = db.collection('creature_species').doc(entry.key);
    batch.set(docRef, entry.value);
    print('  ✓ ${entry.key} (${entry.value['baseRarity']})');
  }

  await batch.commit();

  print('');
  print('✅ ${creatureSpecies.length} espèces ajoutées avec succès !');
  print('');
  print('Résumé par rareté:');

  final rarityCount = <String, int>{};
  for (final species in creatureSpecies.values) {
    final rarity = species['baseRarity'] as String;
    rarityCount[rarity] = (rarityCount[rarity] ?? 0) + 1;
  }

  for (final entry in rarityCount.entries) {
    print('  ${_getRarityEmoji(entry.key)} ${entry.key}: ${entry.value}');
  }
}

String _getRarityEmoji(String rarity) {
  switch (rarity) {
    case 'common':
      return '⚪';
    case 'rare':
      return '🔵';
    case 'epic':
      return '🟣';
    case 'legendary':
      return '🟡';
    default:
      return '❓';
  }
}
