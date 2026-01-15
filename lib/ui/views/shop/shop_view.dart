import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/models/shop_item_model.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:stacked/stacked.dart';

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
          _buildMarketBackground(context),

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
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2),
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
                  background: _buildMarketHeader(context, viewModel),
                ),
              ),

              // Bannière des graines
              SliverToBoxAdapter(
                child: _buildTreasureChest(viewModel, isDark),
              ),

              // Section Nourriture
              SliverToBoxAdapter(
                child:
                    _buildSectionHeader('Élixirs Nourrissants', '🧪', isDark),
              ),
              SliverToBoxAdapter(
                child: _buildFoodSection(context, viewModel),
              ),

              // Section Œufs
              SliverToBoxAdapter(
                child: _buildSectionHeader('Œufs Mystérieux', '🥚', isDark),
              ),
              SliverToBoxAdapter(
                child: _buildEggsSection(context, viewModel),
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

  /// Fond atmosphérique du marché
  Widget _buildMarketBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF1A3D32),
                  AppColors.darkBackground,
                  const Color(0xFF0D1F1A),
                ]
              : [
                  AppColors.tertiary.withOpacity(0.15),
                  AppColors.lightBackground,
                  AppColors.secondary.withOpacity(0.1),
                ],
        ),
      ),
      child: CustomPaint(
        painter: _MarketTexturePainter(isDark: isDark),
        child: const SizedBox.expand(),
      ),
    );
  }

  /// En-tête du marché avec enseigne
  Widget _buildMarketHeader(BuildContext context, ShopViewModel viewModel) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 24,
        right: 24,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.tertiary,
            AppColors.tertiary.withOpacity(0.85),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiary.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enseigne du marché
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏪', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Column(
                children: [
                  Text(
                    'Le Bazar',
                    style: GoogleFonts.fraunces(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'des Merveilles',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.white.withOpacity(0.9),
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              const Text('✨', style: TextStyle(fontSize: 24)),
            ],
          ),

          const SizedBox(height: 8),

          // Décoration ornementale
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.white.withOpacity(0.5)],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '◆',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.5), Colors.transparent],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Coffre au trésor pour les graines
  Widget _buildTreasureChest(ShopViewModel viewModel, bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondary,
            AppColors.secondary.withOpacity(0.85),
            const Color(0xFFB8956D),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône coffre avec glow
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Text('💰', style: TextStyle(fontSize: 36)),
          ),
          const SizedBox(width: 20),

          // Compteur de graines
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Votre Trésor',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('🌱', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 8),
                    Text(
                      '${viewModel.seeds}',
                      style: GoogleFonts.fraunces(
                        fontSize: 38,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Étoiles décoratives
          Column(
            children: [
              _buildFloatingStar(12, 0.8),
              const SizedBox(height: 8),
              _buildFloatingStar(8, 0.5),
              const SizedBox(height: 6),
              _buildFloatingStar(10, 0.7),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingStar(double size, double opacity) {
    return Text(
      '✦',
      style: TextStyle(
        fontSize: size,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }

  /// En-tête de section avec style parchemin
  Widget _buildSectionHeader(String title, String emoji, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          // Ligne décorative gauche
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.secondary.withOpacity(isDark ? 0.4 : 0.5),
                  ],
                ),
              ),
            ),
          ),

          // Titre avec emoji
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface.withOpacity(0.8)
                  : AppColors.secondary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.secondary.withOpacity(isDark ? 0.3 : 0.4),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.fraunces(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),

          // Ligne décorative droite
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary.withOpacity(isDark ? 0.4 : 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section nourriture avec étalage
  Widget _buildFoodSection(BuildContext context, ShopViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: FoodItem.allFoods.map((food) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: _buildFoodCard(context, food, viewModel),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Carte d'élixir/nourriture
  Widget _buildFoodCard(
      BuildContext context, FoodItem food, ShopViewModel viewModel) {
    final canAfford = viewModel.seeds >= food.price;
    final hasCreatures = viewModel.creatures.isNotEmpty;
    final isEnabled = canAfford && hasCreatures;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: isEnabled
          ? () => _showFeedCreatureDialog(context, food, viewModel)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isEnabled
                ? AppColors.primary.withOpacity(0.3)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isEnabled
                  ? AppColors.primary.withOpacity(0.15)
                  : Colors.black.withOpacity(isDark ? 0.2 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Fiole avec glow
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.accent.withOpacity(isDark ? 0.2 : 0.1),
                    AppColors.accent.withOpacity(isDark ? 0.1 : 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Text(food.emoji, style: const TextStyle(fontSize: 36)),
            ),
            const SizedBox(height: 10),

            // Nom de l'élixir
            Text(
              food.name,
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            // XP bonus
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${food.xpGiven} XP',
                style: GoogleFonts.fraunces(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ),

            // Prix
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: isEnabled
                    ? LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.85)
                        ],
                      )
                    : null,
                color: isEnabled
                    ? null
                    : (isDark ? Colors.grey[700] : Colors.grey[300]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🌱', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 4),
                  Text(
                    '${food.price}',
                    style: GoogleFonts.dmSans(
                      color: isEnabled
                          ? Colors.white
                          : (isDark ? Colors.grey[400] : Colors.grey),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Message si pas de créature
            if (!hasCreatures)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Pas de créature',
                  style: GoogleFonts.dmSans(
                    fontSize: 9,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Section des œufs mystérieux
  Widget _buildEggsSection(BuildContext context, ShopViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: EggItem.allEggs.map((egg) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildEggCard(context, egg, viewModel),
          );
        }).toList(),
      ),
    );
  }

  /// Carte d'œuf mystérieux
  Widget _buildEggCard(
      BuildContext context, EggItem egg, ShopViewModel viewModel) {
    final canAfford = viewModel.seeds >= egg.price;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Couleurs selon la rareté
    Color eggColor;
    Color glowColor;
    String auraEmoji;
    switch (egg.id) {
      case 'basic_egg':
        eggColor = const Color(0xFF8B9A8E);
        glowColor = Colors.grey;
        auraEmoji = '🌿';
        break;
      case 'premium_egg':
        eggColor = const Color(0xFF4A9ECF);
        glowColor = Colors.blue;
        auraEmoji = '💎';
        break;
      case 'legendary_egg':
        eggColor = AppColors.tertiary;
        glowColor = Colors.amber;
        auraEmoji = '👑';
        break;
      default:
        eggColor = Colors.grey;
        glowColor = Colors.grey;
        auraEmoji = '🌿';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: eggColor.withOpacity(isDark ? 0.3 : 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: eggColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Œuf avec aura
          Stack(
            alignment: Alignment.center,
            children: [
              // Aura externe
              Container(
                width: 80,
                height: 95,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      glowColor.withOpacity(0.3),
                      glowColor.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              // Œuf
              Container(
                width: 65,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      eggColor.withOpacity(0.4),
                      eggColor.withOpacity(0.2),
                      eggColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: eggColor.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text('🥚',
                      style: TextStyle(fontSize: 36, shadows: [
                        Shadow(
                          color: glowColor.withOpacity(0.6),
                          blurRadius: 12,
                        ),
                      ])),
                ),
              ),
              // Badge aura
              Positioned(
                top: 0,
                right: 0,
                child: Text(auraEmoji, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Infos de l'œuf
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  egg.name,
                  style: GoogleFonts.fraunces(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                if (egg.id == 'legendary_egg') ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '✨ LÉGENDAIRE',
                      style: GoogleFonts.dmSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.tertiary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                _buildDropRates(egg, isDark),
              ],
            ),
          ),

          // Bouton acheter
          GestureDetector(
            onTap: canAfford ? () => _buyEgg(context, egg, viewModel) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                gradient: canAfford
                    ? LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.85)
                        ],
                      )
                    : null,
                color: canAfford
                    ? null
                    : (isDark ? Colors.grey[700] : Colors.grey[300]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: canAfford
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  const Text('🌱', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    '${egg.price}',
                    style: GoogleFonts.fraunces(
                      color: canAfford
                          ? Colors.white
                          : (isDark ? Colors.grey[400] : Colors.grey),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  /// Taux de drop stylisés
  Widget _buildDropRates(EggItem egg, bool isDark) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _buildRateChip('⚪', egg.getDropRateText(CreatureRarity.common),
            isDark ? Colors.grey[400]! : Colors.grey[600]!, isDark),
        _buildRateChip('🔵', egg.getDropRateText(CreatureRarity.rare),
            Colors.blue[400]!, isDark),
        _buildRateChip('💜', egg.getDropRateText(CreatureRarity.epic),
            AppColors.accent, isDark),
        _buildRateChip('⭐', egg.getDropRateText(CreatureRarity.legendary),
            AppColors.tertiary, isDark),
      ],
    );
  }

  Widget _buildRateChip(String emoji, String rate, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 2),
          Text(
            rate,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
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
                        Row(
                          children: [
                            Text(food.emoji,
                                style: const TextStyle(fontSize: 28)),
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
                        ),
                        const SizedBox(height: 16),
                        // Barre d'info live (Graines &Prix)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: (viewModel.seeds >= food.price
                                    ? AppColors.primary
                                    : Colors.red)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: (viewModel.seeds >= food.price
                                        ? AppColors.primary
                                        : Colors.red)
                                    .withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text('🌱'),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${viewModel.seeds}',
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Coût: ',
                                    style: GoogleFonts.dmSans(
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54),
                                  ),
                                  Text(
                                    '${food.price}',
                                    style: GoogleFonts.dmSans(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: viewModel.creatures.map((creature) {
                            final colors =
                                CreatureModel.rarityColors[creature.rarity]!;

                            return GestureDetector(
                              onTap: creature.isMaxLevel
                                  ? null
                                  : () {
                                      viewModel.feedCreature(creature, food);
                                      Navigator.of(context).pop();
                                    },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: creature.isMaxLevel
                                      ? (isDark
                                          ? Colors.grey[800]
                                          : Colors.grey[100])
                                      : (isDark
                                          ? AppColors.darkBackground
                                          : AppColors.lightBackground),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: creature.isMaxLevel
                                        ? Colors.transparent
                                        : Color(colors[0]).withOpacity(0.3),
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
                                          colors: [
                                            Color(colors[0]),
                                            Color(colors[1])
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: creature.isMaxLevel
                                            ? null
                                            : [
                                                BoxShadow(
                                                  color: Color(colors[0])
                                                      .withOpacity(0.4),
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

                                    // Infos et Barre XP Animée
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            creature.name,
                                            style: GoogleFonts.fraunces(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: creature.isMaxLevel
                                                  ? (isDark
                                                      ? Colors.grey[500]
                                                      : Colors.grey[400])
                                                  : (isDark
                                                      ? AppColors
                                                          .darkTextPrimary
                                                      : AppColors
                                                          .lightTextPrimary),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          creature.isMaxLevel
                                              ? Row(
                                                  children: [
                                                    const Text('👑',
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Niveau maximum !',
                                                      style: GoogleFonts.dmSans(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.tertiary,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Text(
                                                      'Nv. ${creature.level}',
                                                      style: GoogleFonts.dmSans(
                                                        fontSize: 12,
                                                        color: isDark
                                                            ? AppColors
                                                                .darkTextSecondary
                                                            : AppColors
                                                                .lightTextSecondary,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Container(
                                                        height: 6,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: isDark
                                                              ? Colors.grey[700]
                                                              : Colors
                                                                  .grey[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                        ),
                                                        child: LayoutBuilder(
                                                          builder: (context,
                                                              constraints) {
                                                            final progress = creature
                                                                    .currentXp /
                                                                creature
                                                                    .xpToNextLevel;
                                                            return Stack(
                                                              children: [
                                                                AnimatedContainer(
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .easeOut,
                                                                  width: constraints
                                                                          .maxWidth *
                                                                      progress,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                                      colors: [
                                                                        Color(colors[
                                                                            0]),
                                                                        Color(colors[
                                                                            1])
                                                                      ],
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(3),
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
                                                            ? AppColors
                                                                .darkTextSecondary
                                                            : AppColors
                                                                .lightTextSecondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
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
        builder: (context) => AlertDialog(
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
              Stack(
                alignment: Alignment.center,
                children: [
                  // Aura externe animée
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Color(colors[0]).withOpacity(0.4),
                          Color(colors[0]).withOpacity(0.1),
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
                          color: Color(colors[0]).withOpacity(0.5),
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
              ),
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(colors[0]).withOpacity(0.2),
                      Color(colors[1]).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color(colors[0]).withOpacity(0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(creature.rarityEmoji,
                        style: const TextStyle(fontSize: 16)),
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
              ),
            ],
          ),
          actions: [
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(colors[0]), Color(colors[1])],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(colors[0]).withOpacity(0.4),
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
        ),
      );
    }
  }

  @override
  ShopViewModel viewModelBuilder(BuildContext context) => ShopViewModel();

  @override
  void onViewModelReady(ShopViewModel viewModel) => viewModel.init();
}

/// Painter pour la texture du marché
class _MarketTexturePainter extends CustomPainter {
  final bool isDark;

  _MarketTexturePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : AppColors.tertiary).withOpacity(0.03)
      ..style = PaintingStyle.fill;

    // Motif de lanternes/étoiles subtiles
    for (var i = 0; i < size.width; i += 80) {
      for (var j = 0; j < size.height; j += 100) {
        canvas.drawCircle(
          Offset(i.toDouble() + (j % 160 == 0 ? 40 : 0), j.toDouble()),
          2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
