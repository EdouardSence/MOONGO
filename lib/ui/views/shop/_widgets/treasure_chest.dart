import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/ui/common/app_theme.dart';

import '../shop_viewmodel.dart';

/// Étoile flottante décorative
class FloatingStar extends StatelessWidget {
  final double size;
  final double opacity;

  const FloatingStar({super.key, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Text(
      '✦',
      style: TextStyle(
        fontSize: size,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

/// Coffre au trésor pour les graines
class TreasureChest extends StatelessWidget {
  final ShopViewModel viewModel;
  final bool isDark;

  const TreasureChest({
    super.key,
    required this.viewModel,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.secondary,
            AppColors.secondary.withValues(alpha: 0.85),
            const Color(0xFFB8956D),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
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
                    color: Colors.white.withValues(alpha: 0.85),
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
                            color: Colors.black.withValues(alpha: 0.2),
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
          const Column(
            children: [
              FloatingStar(size: 12, opacity: 0.8),
              SizedBox(height: 8),
              FloatingStar(size: 8, opacity: 0.5),
              SizedBox(height: 6),
              FloatingStar(size: 10, opacity: 0.7),
            ],
          ),
        ],
      ),
    );
  }
}
