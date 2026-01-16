import 'package:flutter/material.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:moongo/ui/common/widgets/textured_background.dart';

/// Fond enchanté avec dégradé forestier
class EnchantedBackground extends StatelessWidget {
  final bool isDark;

  const EnchantedBackground({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return TexturedBackground(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [
                AppColors.darkBackground,
                AppColors.darkSurface,
                AppColors.darkBackground.withValues(alpha: 0.95),
              ]
            : [
                AppColors.lightBackground,
                AppColors.lightSurface,
                AppColors.lightBackground,
              ],
      ),
      painter: ScrollTexturePainter(isDark: isDark),
    );
  }
}

/// Painter pour texture de parchemin
class ScrollTexturePainter extends CustomPainter {
  final bool isDark;

  const ScrollTexturePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          (isDark ? Colors.white : AppColors.secondary).withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    // Motif subtil de parchemin
    for (var i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint..strokeWidth = 0.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
