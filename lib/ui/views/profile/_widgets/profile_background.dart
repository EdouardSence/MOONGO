import 'package:flutter/material.dart';
import 'package:moongo/ui/common/app_theme.dart';

/// Fond texturé style parchemin
class ProfileBackground extends StatelessWidget {
  final bool isDark;

  const ProfileBackground({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF1E3A2F),
                  AppColors.darkBackground,
                  const Color(0xFF1A2D26),
                ]
              : [
                  AppColors.secondary.withValues(alpha: 0.2),
                  AppColors.lightBackground,
                  AppColors.secondary.withValues(alpha: 0.1),
                ],
        ),
      ),
      child: CustomPaint(
        painter: ParchmentTexturePainter(isDark: isDark),
        child: const SizedBox.expand(),
      ),
    );
  }
}

/// Painter pour la texture de parchemin
class ParchmentTexturePainter extends CustomPainter {
  final bool isDark;

  const ParchmentTexturePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          (isDark ? Colors.white : AppColors.secondary).withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    // Motif de vieilles lignes de parchemin
    for (var i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(20, i.toDouble()),
        Offset(size.width - 20, i.toDouble()),
        paint..strokeWidth = 0.5,
      );
    }

    // Points décoratifs
    for (var i = 0; i < size.width; i += 60) {
      for (var j = 0; j < size.height; j += 80) {
        canvas.drawCircle(
          Offset(i.toDouble() + (j % 120 == 0 ? 30 : 0), j.toDouble()),
          1.5,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
