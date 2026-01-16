import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/ui/common/app_theme.dart';

import '../profile_viewmodel.dart';

/// En-tête héroïque avec avatar et infos
class ProfileHeroHeader extends StatelessWidget {
  final ProfileViewModel viewModel;
  final VoidCallback onSettingsTap;
  final VoidCallback onAvatarTap;
  final String? birthDateText;

  const ProfileHeroHeader({
    super.key,
    required this.viewModel,
    required this.onSettingsTap,
    required this.onAvatarTap,
    required this.birthDateText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 24,
        right: 24,
        bottom: 32,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent,
            AppColors.accent.withValues(alpha: 0.85),
            const Color(0xFF5B2DA0),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(48)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          // Barre supérieure avec paramètres
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '⚔️ Aventurier',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 2,
                ),
              ),
              GestureDetector(
                onTap: onSettingsTap,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Avatar avec cadre orné
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Aura externe
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.3),
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Cadre doré
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.tertiary,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.tertiary.withValues(alpha: 0.5),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        viewModel.user?.avatarUrl ?? '😊',
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                ),
                // Badge édition
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.tertiary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Nom de l'aventurier
          Text(
            viewModel.user?.displayName ?? 'Aventurier',
            style: GoogleFonts.fraunces(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),

          if (birthDateText != null) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎂', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  'Né le $birthDateText',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // Badge de graines
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🌱', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  '${viewModel.user?.seeds ?? 0}',
                  style: GoogleFonts.fraunces(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'graines',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.8),
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
