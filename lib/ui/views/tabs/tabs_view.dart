import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:stacked/stacked.dart';

import 'tabs_viewmodel.dart';

class TabsView extends StackedView<TabsViewModel> {
  const TabsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TabsViewModel viewModel,
    Widget? child,
  ) {
    return PersistentTabView(
      context,
      controller: viewModel.tabController,
      screens: viewModel.buildScreens(),
      items: viewModel.navBarItems(),
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: 70,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      navBarStyle: NavBarStyle.style6,
    );
  }

  @override
  TabsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TabsViewModel();
}
