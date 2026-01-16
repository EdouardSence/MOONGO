import 'package:flutter/material.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:stacked/stacked.dart';

import '_widgets/home_widgets.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final theme = Theme.of(context);
    final appTheme = theme.appTheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: appTheme.homeBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ═══════════════════════════════════════════════════════════════
            // 🌿 ENCHANTED HEADER
            // ═══════════════════════════════════════════════════════════════
            EnchantedHeader(seeds: viewModel.seeds, isDark: isDark),

            // ═══════════════════════════════════════════════════════════════
            // 🏞️ MAGICAL LANDSCAPE
            // ═══════════════════════════════════════════════════════════════
            Expanded(
              flex: 3,
              child: MagicalLandscape(
                appTheme: appTheme,
                isDark: isDark,
                creatures: viewModel.creatures,
              ),
            ),

            // ═══════════════════════════════════════════════════════════════
            // 📜 PARCHMENT TASKS
            // ═══════════════════════════════════════════════════════════════
            Expanded(
              flex: 2,
              child: ParchmentTasks(
                appTheme: appTheme,
                isDark: isDark,
                tasks: viewModel.todayTasks,
                completedCount: viewModel.completedTodayCount,
                onTaskTap: viewModel.navigateToTasks,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.init();
}
