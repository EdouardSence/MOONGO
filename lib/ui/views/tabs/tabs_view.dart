import 'package:flutter/material.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:stacked/stacked.dart';

import 'tabs_viewmodel.dart';

class TabsView extends StackedView<TabsViewModel> {
  final int initialIndex;
  const TabsView({super.key, this.initialIndex = 2});

  @override
  Widget builder(
    BuildContext context,
    TabsViewModel viewModel,
    Widget? child,
  ) {
    final theme = Theme.of(context);
    final appTheme = theme.appTheme;
    final isDark = theme.brightness == Brightness.dark;

    return PersistentTabView(
      context,
      controller: viewModel.tabController,
      screens: viewModel.buildScreens(),
      items: viewModel.navBarItems(isDark),
      backgroundColor: appTheme.cardBackground,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: 65,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      navBarStyle: NavBarStyle.style3,
    );
  }

  @override
  TabsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TabsViewModel(initialIndex: initialIndex);
}
