import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/ui/common/app_theme.dart';

/// État vide avec illustration
class EmptyState extends StatelessWidget {
  final bool isDark;

  const EmptyState({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration parchemin vide
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: isDark ? 0.2 : 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.secondary.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Text('📜', style: TextStyle(fontSize: 64)),
          ),
          const SizedBox(height: 24),
          Text(
            'Parchemin vierge',
            style: GoogleFonts.fraunces(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Inscrivez votre première quête\ndans ce grimoire sacré',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          // Bouton avec style organique
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8)
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('✨', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  'Créer une quête',
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
