import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section des actions
class ActionsSection extends StatelessWidget {
  final VoidCallback onLogout;
  final bool isDark;

  const ActionsSection({
    super.key,
    required this.onLogout,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: GestureDetector(
        onTap: onLogout,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.red.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded,
                  color: Colors.red.withValues(alpha: 0.4)),
              const SizedBox(width: 10),
              Text(
                'Quitter l\'aventure',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
