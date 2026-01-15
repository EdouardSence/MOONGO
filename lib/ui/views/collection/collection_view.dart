import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:stacked/stacked.dart';

import 'collection_viewmodel.dart';

/// Collection View avec esthétique "Cabinet de Curiosités" - Galerie mystique
class CollectionView extends StackedView<CollectionViewModel> {
  const CollectionView({super.key});

  @override
  Widget builder(
      BuildContext context, CollectionViewModel viewModel, Widget? child) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Fond avec texture de galerie
          _buildGalleryBackground(context),

          // Contenu
          Column(
            children: [
              // En-tête de la galerie
              _buildGalleryHeader(context, viewModel),

              // Contenu principal
              Expanded(
                child: viewModel.isBusy
                    ? _buildLoadingState(context)
                    : viewModel.creatures.isEmpty
                        ? _buildEmptyState(context)
                        : _buildCreatureGallery(context, viewModel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Fond avec texture de galerie antique
  Widget _buildGalleryBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF1A2836),
                  AppColors.darkBackground,
                  const Color(0xFF0F1A24),
                ]
              : [
                  const Color(0xFFF5F0E8),
                  AppColors.lightBackground,
                  const Color(0xFFF8F4EC),
                ],
        ),
      ),
      child: CustomPaint(
        painter: _GalleryTexturePainter(isDark: isDark),
        child: const SizedBox.expand(),
      ),
    );
  }

  /// En-tête de la galerie
  Widget _buildGalleryHeader(
      BuildContext context, CollectionViewModel viewModel) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 24,
        right: 24,
        bottom: 20,
      ),
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
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icône ornée
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: const Text('🏛️', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 16),

              // Titre
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cabinet',
                      style: GoogleFonts.fraunces(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      'des Curiosités',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              // Badge compteur
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Text('🐾', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      '${viewModel.creatures.length}',
                      style: GoogleFonts.fraunces(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Ornement décoratif
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOrnamentLine(true),
              const SizedBox(width: 12),
              Text(
                '✦',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 12),
              _buildOrnamentLine(false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrnamentLine(bool leftToRight) {
    return Container(
      width: 60,
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: leftToRight
              ? [Colors.transparent, Colors.white.withOpacity(0.5)]
              : [Colors.white.withOpacity(0.5), Colors.transparent],
        ),
      ),
    );
  }

  /// État de chargement
  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.8 + (value * 0.2),
                child: Opacity(
                  opacity: 0.5 + (value * 0.5),
                  child: const Text('🔮', style: TextStyle(fontSize: 56)),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Inventaire des curiosités...',
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  /// État vide avec illustration
  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Vitrine vide
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(isDark ? 0.15 : 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.secondary.withOpacity(0.3),
                      width: 3,
                    ),
                  ),
                ),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🥚', style: TextStyle(fontSize: 56)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Text(
              'Vitrine vide',
              style: GoogleFonts.fraunces(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Votre cabinet attend ses premiers\nspécimens extraordinaires',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 15,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // Bouton vers la boutique
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.tertiary,
                    AppColors.tertiary.withOpacity(0.85)
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.tertiary.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🥚', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Text(
                    'Découvrir la boutique',
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Galerie des créatures
  Widget _buildCreatureGallery(
      BuildContext context, CollectionViewModel viewModel) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.72,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: viewModel.creatures.length,
      itemBuilder: (context, index) {
        final creature = viewModel.creatures[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 400 + (index * 80)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: _buildCreatureCard(context, creature, viewModel),
              ),
            );
          },
        );
      },
    );
  }

  /// Carte de créature style vitrine de musée
  Widget _buildCreatureCard(BuildContext context, CreatureModel creature,
      CollectionViewModel viewModel) {
    final colors = CreatureModel.rarityColors[creature.rarity]!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showCreatureDetail(context, creature, viewModel),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(colors[0]).withOpacity(isDark ? 0.3 : 0.2),
              Color(colors[1]).withOpacity(isDark ? 0.2 : 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: Color(colors[0]).withOpacity(isDark ? 0.4 : 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(colors[0]).withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Contenu principal
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cadre de la créature avec glow
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Color(colors[0]).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(isDark ? 0.15 : 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(colors[0]).withOpacity(0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(colors[0]).withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          creature.emoji,
                          style: const TextStyle(fontSize: 34),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Nom
                  Text(
                    creature.name,
                    style: GoogleFonts.fraunces(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Badge niveau
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Nv. ${creature.level}',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
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
                  color: Colors.white.withOpacity(0.3),
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
                    color: AppColors.tertiary.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.tertiary.withOpacity(0.5),
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

  /// Détail de la créature
  void _showCreatureDetail(BuildContext context, CreatureModel creature,
      CollectionViewModel viewModel) {
    final colors = CreatureModel.rarityColors[creature.rarity]!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
          boxShadow: [
            BoxShadow(
              color: Color(colors[0]).withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Poignée
            Container(
              margin: const EdgeInsets.only(top: 14),
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 28),

            // Créature avec aura épique
            Stack(
              alignment: Alignment.center,
              children: [
                // Aura externe
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Color(colors[0]).withOpacity(0.3),
                        Color(colors[0]).withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                // Créature principale
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(colors[0]), Color(colors[1])],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 3,
                    ),
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
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Nom et rareté
            Text(
              creature.name,
              style: GoogleFonts.fraunces(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      fontSize: 14,
                      color: Color(colors[0]),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Progression
            if (!creature.isMaxLevel) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    // Niveau et XP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('⚔️', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(
                              'Niveau ${creature.level}',
                              style: GoogleFonts.fraunces(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${creature.currentXp}/${creature.xpToNextLevel} XP',
                          style: GoogleFonts.dmSans(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Barre de progression
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: creature.progressToNextLevel,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(colors[0]),
                                      Color(colors[1])
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Brillance
                            Positioned(
                              right: 2,
                              top: 2,
                              bottom: 2,
                              child: Container(
                                width: 8,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Info évolution
                    if (!creature.isMaxEvolution)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              AppColors.accent.withOpacity(isDark ? 0.15 : 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('✨', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Text(
                              'Évolue en ${creature.nextEvolutionName}',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Nv. ${creature.levelForNextEvolution}',
                                style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primary
                              .withOpacity(isDark ? 0.15 : 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🌟', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            Text(
                              'Évolution complète !',
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ] else ...[
              // Niveau maximum
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.tertiary.withOpacity(0.2),
                      AppColors.tertiary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.tertiary.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('👑', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 10),
                    Text(
                      'Niveau Maximum !',
                      style: GoogleFonts.fraunces(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  @override
  CollectionViewModel viewModelBuilder(BuildContext context) =>
      CollectionViewModel();

  @override
  void onViewModelReady(CollectionViewModel viewModel) => viewModel.init();
}

/// Painter pour la texture de galerie
class _GalleryTexturePainter extends CustomPainter {
  final bool isDark;

  _GalleryTexturePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : AppColors.secondary).withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Cadres décoratifs subtils
    for (var i = 40.0; i < size.width; i += 100) {
      for (var j = 60.0; j < size.height; j += 120) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(i, j, 60, 80),
          const Radius.circular(8),
        );
        canvas.drawRRect(rect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
