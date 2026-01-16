import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/ui/common/app_theme.dart';

/// État de chargement
class CollectionLoadingState extends StatelessWidget {
  const CollectionLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
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
              color: AppColors.secondary.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
