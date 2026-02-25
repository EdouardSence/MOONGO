import 'package:flutter/material.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:moongo/ui/common/widgets/textured_background.dart';

/// Fond avec texture de galerie antique
class GalleryBackground extends StatelessWidget {
  final bool isDark;

  const GalleryBackground({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return TexturedBackground(
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
      painter: GalleryTexturePainter(isDark: isDark),
    );
  }
}

/// Painter pour la texture de galerie
class GalleryTexturePainter extends CustomPainter {
  final bool isDark;

  const GalleryTexturePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          (isDark ? Colors.white : AppColors.secondary).withValues(alpha: 0.02)
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
