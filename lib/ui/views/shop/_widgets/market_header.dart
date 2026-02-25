import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/ui/common/app_theme.dart';

import '../shop_viewmodel.dart';

/// En-tête du marché avec enseigne
class MarketHeader extends StatelessWidget {
  final ShopViewModel viewModel;

  const MarketHeader({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 24,
        right: 24,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.tertiary,
            AppColors.tertiary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: AppColors.tertiary.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enseigne du marché
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🏪', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Column(
                children: [
                  Text(
                    'Le Bazar',
                    style: GoogleFonts.fraunces(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'des Merveilles',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              const Text('✨', style: TextStyle(fontSize: 24)),
            ],
          ),

          const SizedBox(height: 8),

          // Décoration ornementale
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.5)
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '◆',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.5),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SliverAppBar complet du marché avec header sticky et flexible space
class MarketSliverAppBar extends StatelessWidget {
  final ShopViewModel viewModel;

  const MarketSliverAppBar({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 125,
      backgroundColor: AppColors.tertiary,
      title: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: viewModel.showStickyHeader ? 1.0 : 0.0,
        child: AnimatedBuilder(
          animation: viewModel,
          builder: (context, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Le Bazar des Merveilles',
                style: GoogleFonts.fraunces(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                ),
                child: Text(
                  '${viewModel.seeds} 🌱',
                  style: GoogleFonts.fraunces(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
        background: MarketHeader(viewModel: viewModel),
      ),
    );
  }
}
