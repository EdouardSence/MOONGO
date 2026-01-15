import 'package:flutter/material.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:stacked/stacked.dart';

import '../collection/collection_view.dart';
import '../home/home_view.dart';
import '../profile/profile_view.dart';
import '../shop/shop_view.dart';
import '../tasks/tasks_view.dart';

class TabsViewModel extends BaseViewModel {
  late PersistentTabController _tabController;

  PersistentTabController get tabController => _tabController;

  TabsViewModel({int initialIndex = 2}) {
    // Initialise avec l'onglet spécifié (défaut: Home = 2)
    _tabController = PersistentTabController(initialIndex: initialIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Construit la liste des écrans (vues)
  List<Widget> buildScreens() => [
        const CollectionView(),
        const TasksView(),
        const HomeView(),
        const ShopView(),
        const ProfileView(),
      ];

  // Configuration des items de la bottom nav bar avec le nouveau thème Enchanted Forest
  List<PersistentBottomNavBarItem> navBarItems(bool isDark) => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.auto_stories),
          title: 'Collection',
          activeColorPrimary: AppColors.primary,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.format_list_bulleted),
          title: 'Tâches',
          activeColorPrimary: AppColors.primary,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.eco_rounded),
          title: 'Forêt',
          activeColorPrimary: AppColors.tertiary,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.storefront_rounded),
          title: 'Boutique',
          activeColorPrimary: AppColors.secondary,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_rounded),
          title: 'Profil',
          activeColorPrimary: AppColors.accent,
          activeColorSecondary: Colors.white,
          inactiveColorPrimary: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ];
}
