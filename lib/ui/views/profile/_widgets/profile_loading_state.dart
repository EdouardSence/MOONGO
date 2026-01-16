import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/ui/common/app_theme.dart';

/// État de chargement
class ProfileLoadingState extends StatelessWidget {
  const ProfileLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📜', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'Consultation du grimoire...',
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
