import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/models/shop_item_model.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:stacked/stacked.dart';

import '_widgets/shop_widgets.dart';
import 'shop_viewmodel.dart';

/// Shop View avec esthétique "Marché Enchanté" - Étalages mystiques
class ShopView extends StackedView<ShopViewModel> {
  const ShopView({super.key});

  @override
  Widget builder(BuildContext context, ShopViewModel viewModel, Widget? child) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Fond avec ambiance marché
          MarketBackground(isDark: isDark),

          // Contenu scrollable
          CustomScrollView(
            controller: viewModel.scrollController,
            slivers: [
              // En-tête du marché Sticky
              SliverAppBar(
                pinned: true,
                expandedHeight: 180,
                backgroundColor: AppColors.tertiary,
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: viewModel.showStickyHeader ? 1.0 : 0.0,
                  child: AnimatedBuilder(
                    animation: viewModel,
                    builder: (context, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Le Bazar des Merveilles',
                          style: GoogleFonts.fraunces(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1.5),
                          ),
                          child: Text(
                            '${viewModel.seeds} 🌱',
                            style: GoogleFonts.fraunces(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                centerTitle: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: MarketHeader(viewModel: viewModel),
                ),
              ),

              // Bannière des graines
              SliverToBoxAdapter(
                child: TreasureChest(viewModel: viewModel, isDark: isDark),
              ),

              // Section Nourriture
              SliverToBoxAdapter(
                child: SectionHeader(
                    title: 'Élixirs Nourrissants', emoji: '🧪', isDark: isDark),
              ),
              SliverToBoxAdapter(
                child: FoodSection(
                  viewModel: viewModel,
                  onFeedCreature: (food) =>
                      _showFeedCreatureDialog(context, food, viewModel),
                ),
              ),

              // Section Œufs
              SliverToBoxAdapter(
                child: SectionHeader(
                    title: 'Œufs Mystérieux', emoji: '🥚', isDark: isDark),
              ),
              SliverToBoxAdapter(
                child: EggsSection(
                  viewModel: viewModel,
                  onBuyEgg: (egg) => _buyEgg(context, egg, viewModel),
                ),
              ),

              // Espace en bas
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Dialogue pour nourrir une créature
  void _showFeedCreatureDialog(
      BuildContext context, FoodItem food, ShopViewModel viewModel) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              content: AnimatedBuilder(
                animation: viewModel,
                builder: (context, child) => SingleChildScrollView(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _FeedDialogHeader(food: food, isDark: isDark),
                        const SizedBox(height: 16),
                        _SeedsInfoBar(
                          seeds: viewModel.seeds,
                          price: food.price,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 16),
                        _CreaturesList(
                          creatures: viewModel.creatures,
                          isDark: isDark,
                          onFeed: (creature) {
                            viewModel.feedCreature(creature, food);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  /// Achat d'œuf avec animation de révélation
  Future<void> _buyEgg(
      BuildContext context, EggItem egg, ShopViewModel viewModel) async {
    final creature = await viewModel.buyEgg(egg);

    if (creature != null && context.mounted) {
      final colors = CreatureModel.rarityColors[creature.rarity]!;
      final isDark = Theme.of(context).brightness == Brightness.dark;

      showDialog(
        context: context,
        builder: (context) => _EggHatchDialog(
          creature: creature,
          colors: colors,
          isDark: isDark,
        ),
      );
    }
  }

  @override
  ShopViewModel viewModelBuilder(BuildContext context) => ShopViewModel();

  @override
  void onViewModelReady(ShopViewModel viewModel) => viewModel.init();
}

// ═══════════════════════════════════════════════════════════════════════════
// 🎭 DIALOGS WIDGETS (privés car spécifiques à cette view)
// ═══════════════════════════════════════════════════════════════════════════

/// En-tête du dialogue de nourriture
class _FeedDialogHeader extends StatelessWidget {
  final FoodItem food;
  final bool isDark;

  const _FeedDialogHeader({required this.food, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(food.emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nourrir avec',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              Text(
                food.name,
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Barre d'info des graines
class _SeedsInfoBar extends StatelessWidget {
  final int seeds;
  final int price;
  final bool isDark;

  const _SeedsInfoBar({
    required this.seeds,
    required this.price,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = seeds >= price;
    final color = canAfford ? AppColors.primary : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('🌱'),
              const SizedBox(width: 4),
              Text(
                '$seeds',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Coût: ',
                style: GoogleFonts.dmSans(
                    color: isDark ? Colors.white70 : Colors.black54),
              ),
              Text(
                '$price',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Liste des créatures à nourrir
class _CreaturesList extends StatelessWidget {
  final List<CreatureModel> creatures;
  final bool isDark;
  final void Function(CreatureModel creature) onFeed;

  const _CreaturesList({
    required this.creatures,
    required this.isDark,
    required this.onFeed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: creatures.map((creature) {
        return _CreatureListItem(
          creature: creature,
          isDark: isDark,
          onTap: creature.isMaxLevel ? null : () => onFeed(creature),
        );
      }).toList(),
    );
  }
}

/// Item de créature dans la liste
class _CreatureListItem extends StatelessWidget {
  final CreatureModel creature;
  final bool isDark;
  final VoidCallback? onTap;

  const _CreatureListItem({
    required this.creature,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = CreatureModel.rarityColors[creature.rarity]!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: creature.isMaxLevel
              ? (isDark ? Colors.grey[800] : Colors.grey[100])
              : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: creature.isMaxLevel
                ? Colors.transparent
                : Color(colors[0]).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            // Avatar créature
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(colors[0]), Color(colors[1])],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: creature.isMaxLevel
                    ? null
                    : [
                        BoxShadow(
                          color: Color(colors[0]).withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  creature.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Infos et Barre XP
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    creature.name,
                    style: GoogleFonts.fraunces(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: creature.isMaxLevel
                          ? (isDark ? Colors.grey[500] : Colors.grey[400])
                          : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary),
                    ),
                  ),
                  const SizedBox(height: 4),
                  creature.isMaxLevel
                      ? const _MaxLevelBadge()
                      : _XpProgressBar(creature: creature, isDark: isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge niveau maximum
class _MaxLevelBadge extends StatelessWidget {
  const _MaxLevelBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('👑', style: TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Text(
          'Niveau maximum !',
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: AppColors.tertiary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Barre de progression XP
class _XpProgressBar extends StatelessWidget {
  final CreatureModel creature;
  final bool isDark;

  const _XpProgressBar({required this.creature, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final colors = CreatureModel.rarityColors[creature.rarity]!;

    return Row(
      children: [
        Text(
          'Nv. ${creature.level}',
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : Colors.grey[200],
              borderRadius: BorderRadius.circular(3),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final progress = creature.currentXp / creature.xpToNextLevel;
                return Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      width: constraints.maxWidth * progress,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(colors[0]), Color(colors[1])],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${creature.currentXp}/${creature.xpToNextLevel}',
          style: GoogleFonts.dmSans(
            fontSize: 10,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

/// Dialogue d'éclosion d'œuf
class _EggHatchDialog extends StatelessWidget {
  final CreatureModel creature;
  final List<int> colors;
  final bool isDark;

  const _EggHatchDialog({
    required this.creature,
    required this.colors,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Célébration
          const Text('🎉', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            'Éclosion !',
            style: GoogleFonts.fraunces(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 24),

          // Créature avec aura
          _CreatureReveal(creature: creature, colors: colors),
          const SizedBox(height: 20),

          // Nom
          Text(
            creature.name,
            style: GoogleFonts.fraunces(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Rareté
          _RarityBadge(creature: creature, colors: colors),
        ],
      ),
      actions: [
        Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(colors[0]), Color(colors[1])],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(colors[0]).withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '✨ Magnifique !',
                style: GoogleFonts.fraunces(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Animation de révélation de créature
class _CreatureReveal extends StatelessWidget {
  final CreatureModel creature;
  final List<int> colors;

  const _CreatureReveal({required this.creature, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Aura externe
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(colors[0]).withValues(alpha: 0.4),
                Color(colors[0]).withValues(alpha: 0.1),
                Colors.transparent,
              ],
            ),
            shape: BoxShape.circle,
          ),
        ),
        // Créature
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(colors[0]), Color(colors[1])],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(colors[0]).withValues(alpha: 0.5),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Text(
              creature.emoji,
              style: const TextStyle(fontSize: 48),
            ),
          ),
        ),
      ],
    );
  }
}

/// Badge de rareté
class _RarityBadge extends StatelessWidget {
  final CreatureModel creature;
  final List<int> colors;

  const _RarityBadge({required this.creature, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(colors[0]).withValues(alpha: 0.2),
            Color(colors[1]).withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(colors[0]).withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(creature.rarityEmoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            creature.rarityLabel,
            style: GoogleFonts.dmSans(
              color: Color(colors[0]),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
