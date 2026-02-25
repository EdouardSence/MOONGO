import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/ui/common/app_theme.dart';

/// État de chargement réutilisable avec animation
class LoadingState extends StatelessWidget {
  final String emoji;
  final String message;
  final Color? color;
  final bool animated;

  const LoadingState({
    super.key,
    this.emoji = '📜',
    this.message = 'Chargement...',
    this.color,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (animated)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (value * 0.2),
                  child: Opacity(
                    opacity: 0.5 + (value * 0.5),
                    child: Text(emoji, style: const TextStyle(fontSize: 56)),
                  ),
                );
              },
            )
          else
            Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: effectiveColor.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
