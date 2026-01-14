import 'creature_model.dart';

enum ShopItemType {
  food,
  egg,
}

class FoodItem {
  final String id;
  final String name;
  final String emoji;
  final int price;
  final int xpGiven;
  final String description;

  const FoodItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    required this.xpGiven,
    required this.description,
  });

  // Les 3 types de nourriture
  static const FoodItem sprout = FoodItem(
    id: 'sprout',
    name: 'Pousse',
    emoji: '🌱',
    price: 20,
    xpGiven: 25,
    description: 'Une petite pousse nutritive',
  );

  static const FoodItem berry = FoodItem(
    id: 'berry',
    name: 'Baie',
    emoji: '🫐',
    price: 50,
    xpGiven: 75,
    description: 'Des baies savoureuses',
  );

  static const FoodItem cake = FoodItem(
    id: 'cake',
    name: 'Gâteau',
    emoji: '🍰',
    price: 100,
    xpGiven: 200,
    description: 'Un délicieux gâteau',
  );

  static List<FoodItem> get allFoods => [sprout, berry, cake];
}

class EggItem {
  final String id;
  final String name;
  final String emoji;
  final int price;
  final Map<CreatureRarity, double> dropRates;
  final String description;

  const EggItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    required this.dropRates,
    required this.description,
  });

  // Œuf Basique
  static const EggItem basic = EggItem(
    id: 'basic_egg',
    name: 'Œuf Basique',
    emoji: '🥚',
    price: 50,
    dropRates: {
      CreatureRarity.common: 0.70,
      CreatureRarity.rare: 0.25,
      CreatureRarity.epic: 0.04,
      CreatureRarity.legendary: 0.01,
    },
    description: 'Un œuf mystérieux',
  );

  // Œuf Premium
  static const EggItem premium = EggItem(
    id: 'premium_egg',
    name: 'Œuf Premium',
    emoji: '🥚',
    price: 150,
    dropRates: {
      CreatureRarity.common: 0.40,
      CreatureRarity.rare: 0.40,
      CreatureRarity.epic: 0.15,
      CreatureRarity.legendary: 0.05,
    },
    description: 'Un œuf de qualité supérieure',
  );

  // Œuf Légendaire
  static const EggItem legendary = EggItem(
    id: 'legendary_egg',
    name: 'Œuf Légendaire',
    emoji: '🥚',
    price: 300,
    dropRates: {
      CreatureRarity.common: 0.10,
      CreatureRarity.rare: 0.30,
      CreatureRarity.epic: 0.40,
      CreatureRarity.legendary: 0.20,
    },
    description: 'Un œuf extrêmement rare',
  );

  static List<EggItem> get allEggs => [basic, premium, legendary];

  // Tire une rareté aléatoire selon les taux
  CreatureRarity rollRarity() {
    final random = DateTime.now().millisecondsSinceEpoch % 10000 / 10000;
    double cumulative = 0;

    for (final entry in dropRates.entries) {
      cumulative += entry.value;
      if (random < cumulative) {
        return entry.key;
      }
    }
    return CreatureRarity.common;
  }

  String getDropRateText(CreatureRarity rarity) {
    final rate = dropRates[rarity] ?? 0;
    return '${(rate * 100).toInt()}%';
  }
}
