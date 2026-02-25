import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:moongo/ui/common/creature_image.dart';

/// Galerie des créatures
class CreatureGallery extends StatelessWidget {
  final List<CreatureModel> creatures;
  final void Function(CreatureModel creature) onCreatureTap;

  const CreatureGallery({
    super.key,
    required this.creatures,
    required this.onCreatureTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.72,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: creatures.length,
      itemBuilder: (context, index) {
        final creature = creatures[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + (index * 80)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value.clamp(0.0, 1.5),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: CreatureCard(
                  creature: creature,
                  onTap: () => onCreatureTap(creature),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Carte de créature style vitrine de musée
class CreatureCard extends StatelessWidget {
  final CreatureModel creature;
  final VoidCallback onTap;

  const CreatureCard({super.key, required this.creature, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = CreatureModel.rarityColors[creature.rarity]!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(colors[0]).withValues(alpha: isDark ? 0.3 : 0.2),
              Color(colors[1]).withValues(alpha: isDark ? 0.2 : 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Color(colors[0]).withValues(alpha: isDark ? 0.4 : 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(colors[0]).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Contenu principal
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cadre de la créature avec glow
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Color(colors[0]).withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: CreatureImageWithGlow(
                        creature: creature,
                        size: 52,
                        useParcImage: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Nom
                  Text(
                    creature.name,
                    style: GoogleFonts.fraunces(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Badge niveau
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Nv. ${creature.level}',
                      style: GoogleFonts.dmSans(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Badge rareté
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    creature.rarityEmoji,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),

            // Indicateur niveau max
            if (creature.isMaxLevel)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.tertiary.withValues(alpha: 0.5),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Text('👑', style: TextStyle(fontSize: 10)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
