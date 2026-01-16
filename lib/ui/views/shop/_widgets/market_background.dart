import 'package:flutter/material.dart';
import 'package:moongo/ui/common/app_theme.dart';

/// Painter pour la texture du marché
class MarketTexturePainter extends CustomPainter {
  final bool isDark;

  MarketTexturePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          (isDark ? Colors.white : AppColors.tertiary).withValues(alpha: 0.03)
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

/// Fond atmosphérique du marché
class MarketBackground extends StatelessWidget {
  final bool isDark;

  const MarketBackground({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
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
                  AppColors.tertiary.withValues(alpha: 0.15),
                  AppColors.lightBackground,
                  AppColors.secondary.withValues(alpha: 0.1),
                ],
        ),
      ),
      child: CustomPaint(
        painter: MarketTexturePainter(isDark: isDark),
        child: const SizedBox.expand(),
      ),
    );
  }
}
