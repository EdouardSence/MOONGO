import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/models/shop_item_model.dart';
import 'package:moongo/ui/common/app_theme.dart';

import '../shop_viewmodel.dart';

/// Section nourriture avec étalage
class FoodSection extends StatelessWidget {
  final ShopViewModel viewModel;
  final void Function(FoodItem food) onFeedCreature;

  const FoodSection({
    super.key,
    required this.viewModel,
    required this.onFeedCreature,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: FoodItem.allFoods.map((food) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: FoodCard(
                food: food,
                viewModel: viewModel,
                onTap: () => onFeedCreature(food),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Carte d'élixir/nourriture
class FoodCard extends StatelessWidget {
  final FoodItem food;
  final ShopViewModel viewModel;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.food,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final canAfford = viewModel.seeds >= food.price;
    final hasCreatures = viewModel.creatures.isNotEmpty;
    final isEnabled = canAfford && hasCreatures;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isEnabled
                ? AppColors.primary.withValues(alpha: 0.3)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isEnabled
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
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
                    AppColors.accent.withValues(alpha: isDark ? 0.2 : 0.1),
                    AppColors.accent.withValues(alpha: isDark ? 0.1 : 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isEnabled
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.3),
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
                color: AppColors.accent.withValues(alpha: 0.15),
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
                          AppColors.primary.withValues(alpha: 0.85)
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
                          color: AppColors.primary.withValues(alpha: 0.4),
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
}
