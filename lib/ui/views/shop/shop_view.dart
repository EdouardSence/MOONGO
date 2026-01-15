import 'package:flutter/material.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/models/shop_item_model.dart';
import 'package:stacked/stacked.dart';

import 'shop_viewmodel.dart';

class ShopView extends StackedView<ShopViewModel> {
  const ShopView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, ShopViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Boutique',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF10B981),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bannière graines
            _buildSeedsBanner(viewModel),

            const SizedBox(height: 16),

            // Section Nourriture
            _buildSectionTitle('Nourriture', '🌱'),
            _buildFoodGrid(context, viewModel),

            const SizedBox(height: 24),

            // Section Œufs
            _buildSectionTitle('Œufs Mystères', '🥚'),
            _buildEggsGrid(context, viewModel),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSeedsBanner(ShopViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vos Graines',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                '${viewModel.seeds}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String emoji) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodGrid(BuildContext context, ShopViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: FoodItem.allFoods.map((food) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildFoodCard(context, food, viewModel),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFoodCard(
      BuildContext context, FoodItem food, ShopViewModel viewModel) {
    final canAfford = viewModel.seeds >= food.price;
    final hasCreatures = viewModel.creatures.isNotEmpty;
    final isEnabled = canAfford && hasCreatures;

    return GestureDetector(
      onTap: isEnabled
          ? () => _showFeedCreatureDialog(context, food, viewModel)
          : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(food.emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(
              food.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              '+${food.xpGiven} XP',
              style: TextStyle(fontSize: 10, color: Colors.purple[400]),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isEnabled ? const Color(0xFF10B981) : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🌱', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 2),
                  Text(
                    '${food.price}',
                    style: TextStyle(
                      color: isEnabled ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (!hasCreatures)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Pas de créature',
                  style: TextStyle(fontSize: 8, color: Colors.grey[500]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEggsGrid(BuildContext context, ShopViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: EggItem.allEggs.map((egg) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildEggCard(context, egg, viewModel),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEggCard(
      BuildContext context, EggItem egg, ShopViewModel viewModel) {
    final canAfford = viewModel.seeds >= egg.price;

    Color eggColor;
    switch (egg.id) {
      case 'basic_egg':
        eggColor = Colors.grey;
        break;
      case 'premium_egg':
        eggColor = Colors.blue;
        break;
      case 'legendary_egg':
        eggColor = Colors.amber;
        break;
      default:
        eggColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Œuf
          Container(
            width: 60,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [eggColor.withOpacity(0.3), eggColor.withOpacity(0.1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Center(
              child: Text('🥚', style: TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(width: 16),

          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  egg.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                _buildDropRates(egg),
              ],
            ),
          ),

          // Bouton acheter
          GestureDetector(
            onTap: canAfford ? () => _buyEgg(context, egg, viewModel) : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: canAfford ? const Color(0xFF10B981) : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text('🌱', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '${egg.price}',
                    style: TextStyle(
                      color: canAfford ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropRates(EggItem egg) {
    return Wrap(
      spacing: 4,
      runSpacing: 2,
      children: [
        _buildRateChip(
            '🔘', egg.getDropRateText(CreatureRarity.common), Colors.grey),
        _buildRateChip(
            '🔵', egg.getDropRateText(CreatureRarity.rare), Colors.blue),
        _buildRateChip(
            '🟣', egg.getDropRateText(CreatureRarity.epic), Colors.purple),
        _buildRateChip(
            '🟡', egg.getDropRateText(CreatureRarity.legendary), Colors.amber),
      ],
    );
  }

  Widget _buildRateChip(String emoji, String rate, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 10)),
          Text(rate, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  void _showFeedCreatureDialog(
      BuildContext context, FoodItem food, ShopViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nourrir avec ${food.emoji} ${food.name}'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: viewModel.creatures.length,
            itemBuilder: (context, index) {
              final creature = viewModel.creatures[index];
              final colors = CreatureModel.rarityColors[creature.rarity]!;

              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(colors[0]), Color(colors[1])],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                      child: Text(creature.emoji,
                          style: const TextStyle(fontSize: 20))),
                ),
                title: Text(creature.name),
                subtitle: creature.isMaxLevel
                    ? const Text('Niveau max !',
                        style: TextStyle(color: Colors.amber))
                    : Text(
                        'Nv. ${creature.level} - ${creature.currentXp}/${creature.xpToNextLevel} XP'),
                enabled: !creature.isMaxLevel,
                onTap: creature.isMaxLevel
                    ? null
                    : () {
                        Navigator.pop(context);
                        viewModel.feedCreature(creature, food);
                      },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  Future<void> _buyEgg(
      BuildContext context, EggItem egg, ShopViewModel viewModel) async {
    final creature = await viewModel.buyEgg(egg);

    if (creature != null && context.mounted) {
      final colors = CreatureModel.rarityColors[creature.rarity]!;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              const Text(
                'Félicitations !',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(colors[0]), Color(colors[1])],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(creature.emoji,
                      style: const TextStyle(fontSize: 40)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                creature.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(creature.rarityEmoji),
                  const SizedBox(width: 4),
                  Text(
                    creature.rarityLabel,
                    style: TextStyle(
                        color: Color(colors[0]), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Super !'),
            ),
          ],
        ),
      );
    }
  }

  @override
  ShopViewModel viewModelBuilder(BuildContext context) => ShopViewModel();

  @override
  void onViewModelReady(ShopViewModel viewModel) => viewModel.init();
}
