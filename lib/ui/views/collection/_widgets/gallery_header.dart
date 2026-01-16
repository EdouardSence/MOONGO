import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/ui/common/app_theme.dart';

/// En-tête de la galerie
class GalleryHeader extends StatelessWidget {
  final int creaturesCount;

  const GalleryHeader({super.key, required this.creaturesCount});

  @override
  Widget build(BuildContext context) {
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
            AppColors.secondary.withValues(alpha: 0.85),
            const Color(0xFFB8956D),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.4),
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
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
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
                        color: Colors.white.withValues(alpha: 0.9),
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
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Text('🐾', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Text(
                      '$creaturesCount',
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
            children: const [
              OrnamentLine(leftToRight: true),
              SizedBox(width: 12),
              Text(
                '✦',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 12),
              OrnamentLine(leftToRight: false),
            ],
          ),
        ],
      ),
    );
  }
}

class OrnamentLine extends StatelessWidget {
  final bool leftToRight;

  const OrnamentLine({super.key, required this.leftToRight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: leftToRight
              ? [Colors.transparent, Colors.white.withValues(alpha: 0.5)]
              : [Colors.white.withValues(alpha: 0.5), Colors.transparent],
        ),
      ),
    );
  }
}
