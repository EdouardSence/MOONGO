import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/models/task_model.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:moongo/ui/common/creature_image.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final theme = Theme.of(context);
    final appTheme = theme.appTheme;

    return Scaffold(
      backgroundColor: appTheme.homeBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ═══════════════════════════════════════════════════════════════
            // 🌿 ENCHANTED HEADER
            // ═══════════════════════════════════════════════════════════════
            _buildEnchantedHeader(context, viewModel),

            // ═══════════════════════════════════════════════════════════════
            // 🏞️ MAGICAL LANDSCAPE
            // ═══════════════════════════════════════════════════════════════
            Expanded(
              flex: 3,
              child: _buildMagicalLandscape(context, viewModel),
            ),

            // ═══════════════════════════════════════════════════════════════
            // 📜 PARCHMENT TASKS
            // ═══════════════════════════════════════════════════════════════
            Expanded(
              flex: 2,
              child: _buildParchmentTasks(context, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnchantedHeader(BuildContext context, HomeViewModel viewModel) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1A2F23), const Color(0xFF2D4A3A)]
              : [AppColors.primary, const Color(0xFF3D7A62)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo avec typographie distinctive
          Row(
            children: [
              // Icône feuille organique
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.tertiary.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Text('🌿', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'MOONGO',
                style: GoogleFonts.fraunces(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),

          // Compteur de graines avec glow effect
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.tertiary.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.goldenGlow,
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                // Seed icon avec animation glow
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.tertiary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.tertiary.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🌱', style: TextStyle(fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${viewModel.seeds}',
                  style: GoogleFonts.fraunces(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMagicalLandscape(BuildContext context, HomeViewModel viewModel) {
    final theme = Theme.of(context);
    final appTheme = theme.appTheme;
    final isDark = theme.brightness == Brightness.dark;

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
                ? Colors.black.withOpacity(0.4)
                : AppColors.primary.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.white.withOpacity(0.3),
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
                painter: _ForestTexturePainter(isDark: isDark),
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
                      appTheme.grassColor.withOpacity(0.8),
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
                  painter: _GrassWavePainter(
                    color: isDark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),

            // Éléments décoratifs flottants
            const Positioned(
              top: 25,
              left: 25,
              child: _FloatingElement(
                child: Text('✨', style: TextStyle(fontSize: 16)),
                delay: Duration.zero,
              ),
            ),
            const Positioned(
              top: 40,
              right: 50,
              child: _FloatingElement(
                child: Text('🦋', style: TextStyle(fontSize: 20)),
                delay: Duration(milliseconds: 500),
              ),
            ),
            Positioned(
              top: 15,
              right: 25,
              child: _FloatingElement(
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
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
            if (viewModel.creatures.isEmpty)
              _buildEmptyForest(context)
            else
              ...viewModel.creatures
                  .take(6)
                  .toList()
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final creature = entry.value;
                return _buildEnchantedCreature(creature, index, isDark);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyForest(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                color:
                    isDark ? AppColors.darkCard : Colors.white.withOpacity(0.8),
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

  Widget _buildEnchantedCreature(
      CreatureModel creature, int index, bool isDark) {
    final random = Random(creature.creatureId.hashCode);
    final left = 25.0 + (index % 3) * 90.0 + random.nextDouble() * 25;
    final bottom = 80.0 + (index ~/ 3) * 65.0 + random.nextDouble() * 15;

    return Positioned(
      left: left,
      bottom: bottom,
      child: _FloatingElement(
        delay: Duration(milliseconds: 300 * index),
        amplitude: 4 + random.nextDouble() * 2,
        child: Column(
          children: [
            // Créature avec glow
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCard.withOpacity(0.9)
                    : Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? AppColors.mysticGlow : AppColors.goldenGlow,
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: isDark
                      ? AppColors.secondary.withOpacity(0.3)
                      : AppColors.primary.withOpacity(0.2),
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
                    ? AppColors.darkSurface.withOpacity(0.95)
                    : Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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

  Widget _buildParchmentTasks(BuildContext context, HomeViewModel viewModel) {
    final theme = Theme.of(context);
    final appTheme = theme.appTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: appTheme.postItBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : AppColors.secondary.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: appTheme.postItBorder.withOpacity(0.6),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header avec style parchemin
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: appTheme.postItBorder.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('📜', style: TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Quêtes du jour",
                style: GoogleFonts.fraunces(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: appTheme.postItText,
                ),
              ),
              const Spacer(),
              // Badge compteur
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      appTheme.postItBorder,
                      appTheme.postItBorder.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: appTheme.postItBorder.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '${viewModel.completedTodayCount}/${viewModel.todayTasks.length}',
                  style: GoogleFonts.fraunces(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Divider organique
          Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  appTheme.postItBorder.withOpacity(0.1),
                  appTheme.postItBorder.withOpacity(0.4),
                  appTheme.postItBorder.withOpacity(0.1),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Liste des tâches
          Expanded(
            child: viewModel.todayTasks.isEmpty
                ? _buildNoTasksState(appTheme)
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: viewModel.todayTasks.take(4).length,
                    itemBuilder: (context, index) {
                      final task = viewModel.todayTasks[index];
                      return _buildTaskItem(context, task, viewModel, index);
                    },
                  ),
          ),

          if (viewModel.todayTasks.length > 4)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '+${viewModel.todayTasks.length - 4} autres quêtes',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: appTheme.postItText.withOpacity(0.7),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoTasksState(AppThemeExtension appTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: appTheme.postItBorder.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🎊', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Repos bien mérité !',
            style: GoogleFonts.fraunces(
              color: appTheme.postItText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Aucune quête aujourd\'hui',
            style: GoogleFonts.dmSans(
              color: appTheme.postItText.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(
    BuildContext context,
    TaskModel task,
    HomeViewModel viewModel,
    int index,
  ) {
    final appTheme = Theme.of(context).appTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () => viewModel.navigateToTasks(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: task.completed
                ? (isDark
                    ? Colors.white.withOpacity(0.05)
                    : Colors.black.withOpacity(0.03))
                : (isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.white.withOpacity(0.6)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: task.completed
                  ? Colors.transparent
                  : appTheme.postItBorder.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Navigation Arrow
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: appTheme.postItBorder.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: appTheme.postItText.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Contenu de la tâche
              Expanded(
                child: Text(
                  task.title,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration:
                        task.completed ? TextDecoration.lineThrough : null,
                    color: task.completed
                        ? appTheme.postItText.withOpacity(0.5)
                        : appTheme.postItText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Icône de la tâche
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: appTheme.postItBorder.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(task.icon, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.init();
}

// ═══════════════════════════════════════════════════════════════════════════
// 🎭 ANIMATIONS HELPERS
// ═══════════════════════════════════════════════════════════════════════════

class _FloatingElement extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double amplitude;

  const _FloatingElement({
    required this.child,
    this.delay = Duration.zero,
    this.amplitude = 5,
  });

  @override
  State<_FloatingElement> createState() => _FloatingElementState();
}

class _FloatingElementState extends State<_FloatingElement>
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

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 CUSTOM PAINTERS
// ═══════════════════════════════════════════════════════════════════════════

class _ForestTexturePainter extends CustomPainter {
  final bool isDark;

  _ForestTexturePainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.02)
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

class _GrassWavePainter extends CustomPainter {
  final Color color;

  _GrassWavePainter({required this.color});

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
