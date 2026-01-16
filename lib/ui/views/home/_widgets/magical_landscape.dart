import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:moongo/ui/common/creature_image.dart';

class MagicalLandscape extends StatelessWidget {
  final AppThemeExtension appTheme;
  final bool isDark;
  final List<CreatureModel> creatures;

  const MagicalLandscape({
    super.key,
    required this.appTheme,
    required this.isDark,
    required this.creatures,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: appTheme.landscapeGradient,
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Texture de fond subtile
            Positioned.fill(
              child: CustomPaint(
                painter: ForestTexturePainter(isDark: isDark),
              ),
            ),

            // Sol avec herbe ondulée
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      appTheme.grassColor,
                      appTheme.grassColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: CustomPaint(
                  painter: GrassWavePainter(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),

            // Éléments décoratifs flottants
            const Positioned(
              top: 25,
              left: 25,
              child: FloatingElement(
                delay: Duration.zero,
                child: Text('✨', style: TextStyle(fontSize: 16)),
              ),
            ),
            const Positioned(
              top: 40,
              right: 50,
              child: FloatingElement(
                delay: Duration(milliseconds: 500),
                child: Text('🦋', style: TextStyle(fontSize: 20)),
              ),
            ),
            Positioned(
              top: 15,
              right: 25,
              child: FloatingElement(
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('☁️', style: TextStyle(fontSize: 24)),
                ),
              ),
            ),

            // Arbre décoratif en arrière-plan
            Positioned(
              bottom: 55,
              left: 15,
              child: Opacity(
                opacity: 0.4,
                child: Text(
                  '🌲',
                  style: TextStyle(
                    fontSize: 50,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: 20,
              child: Opacity(
                opacity: 0.3,
                child: Text(
                  '🌳',
                  style: TextStyle(
                    fontSize: 45,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),

            // Créatures ou état vide
            if (creatures.isEmpty)
              EmptyForest(isDark: isDark)
            else
              ...creatures.take(6).toList().asMap().entries.map((entry) {
                final index = entry.key;
                final creature = entry.value;
                return EnchantedCreature(
                  creature: creature,
                  index: index,
                  isDark: isDark,
                );
              }),
          ],
        ),
      ),
    );
  }
}

class EmptyForest extends StatelessWidget {
  final bool isDark;

  const EmptyForest({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Stump animé
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.9 + (sin(value * pi * 2) * 0.05),
                child: child,
              );
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCard
                    : Colors.white.withValues(alpha: 0.8),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.goldenGlow,
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🌱', style: TextStyle(fontSize: 40)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Votre forêt attend',
            style: GoogleFonts.fraunces(
              color: isDark ? AppColors.secondary : AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Achetez un œuf dans la boutique',
            style: GoogleFonts.dmSans(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class EnchantedCreature extends StatelessWidget {
  final CreatureModel creature;
  final int index;
  final bool isDark;

  const EnchantedCreature({
    super.key,
    required this.creature,
    required this.index,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random(creature.creatureId.hashCode);
    final left = 25.0 + (index % 3) * 90.0 + random.nextDouble() * 25;
    final bottom = 80.0 + (index ~/ 3) * 65.0 + random.nextDouble() * 15;

    return Positioned(
      left: left,
      bottom: bottom,
      child: FloatingElement(
        delay: Duration(milliseconds: 300 * index),
        amplitude: 4 + random.nextDouble() * 2,
        child: Column(
          children: [
            // Créature avec glow
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCard.withValues(alpha: 0.9)
                    : Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? AppColors.mysticGlow : AppColors.goldenGlow,
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isDark
                      ? AppColors.secondary.withValues(alpha: 0.3)
                      : AppColors.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CreatureImage(
                  creature: creature,
                  size: 50,
                  useParcImage: true,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Nom avec badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface.withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                creature.name,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingElement extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double amplitude;

  const FloatingElement({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.amplitude = 5,
  });

  @override
  State<FloatingElement> createState() => _FloatingElementState();
}

class _FloatingElementState extends State<FloatingElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, sin(_animation.value * pi) * widget.amplitude),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class ForestTexturePainter extends CustomPainter {
  final bool isDark;

  const ForestTexturePainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.02)
      ..strokeWidth = 1;

    final random = Random(42);
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GrassWavePainter extends CustomPainter {
  final Color color;

  const GrassWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height * 0.3);

    for (double x = 0; x <= size.width; x += 20) {
      path.quadraticBezierTo(
        x + 10,
        size.height * 0.1,
        x + 20,
        size.height * 0.3,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
