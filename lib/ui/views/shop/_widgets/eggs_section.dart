import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/models/shop_item_model.dart';
import 'package:moongo/ui/common/app_theme.dart';

import '../shop_viewmodel.dart';

/// Section des œufs mystérieux
class EggsSection extends StatelessWidget {
  final ShopViewModel viewModel;
  final void Function(EggItem egg) onBuyEgg;

  const EggsSection({
    super.key,
    required this.viewModel,
    required this.onBuyEgg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: EggItem.allEggs.map((egg) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: EggCard(
              egg: egg,
              viewModel: viewModel,
              onBuy: () => onBuyEgg(egg),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Carte d'œuf mystérieux
class EggCard extends StatelessWidget {
  final EggItem egg;
  final ShopViewModel viewModel;
  final VoidCallback onBuy;

  const EggCard({
    super.key,
    required this.egg,
    required this.viewModel,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
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
          color: eggColor.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: eggColor.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
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
                      glowColor.withValues(alpha: 0.3),
                      glowColor.withValues(alpha: 0.1),
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
                      eggColor.withValues(alpha: 0.4),
                      eggColor.withValues(alpha: 0.2),
                      eggColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: eggColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text('🥚',
                      style: TextStyle(fontSize: 36, shadows: [
                        Shadow(
                          color: glowColor.withValues(alpha: 0.6),
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
                if (egg.id == 'premium_egg') ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 255, 255)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '💎 PREMIUM',
                      style: GoogleFonts.dmSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 0, 255, 255),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
                if (egg.id == 'legendary_egg') ...[
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary.withValues(alpha: 0.2),
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
                DropRates(egg: egg, isDark: isDark),
              ],
            ),
          ),

          // Bouton acheter
          GestureDetector(
            onTap: canAfford ? onBuy : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                gradient: canAfford
                    ? LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.85)
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
                          color: AppColors.primary.withValues(alpha: 0.4),
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
}

/// Taux de drop stylisés
class DropRates extends StatelessWidget {
  final EggItem egg;
  final bool isDark;

  const DropRates({super.key, required this.egg, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        RateChip(
          emoji: '⚪',
          rate: egg.getDropRateText(CreatureRarity.common),
          color: isDark ? Colors.grey[400]! : Colors.grey[600]!,
          isDark: isDark,
        ),
        RateChip(
          emoji: '🔵',
          rate: egg.getDropRateText(CreatureRarity.rare),
          color: Colors.blue[400]!,
          isDark: isDark,
        ),
        RateChip(
          emoji: '💜',
          rate: egg.getDropRateText(CreatureRarity.epic),
          color: AppColors.accent,
          isDark: isDark,
        ),
        RateChip(
          emoji: '⭐',
          rate: egg.getDropRateText(CreatureRarity.legendary),
          color: AppColors.tertiary,
          isDark: isDark,
        ),
      ],
    );
  }
}

/// Chip pour afficher un taux de drop
class RateChip extends StatelessWidget {
  final String emoji;
  final String rate;
  final Color color;
  final bool isDark;

  const RateChip({
    super.key,
    required this.emoji,
    required this.rate,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
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
}
