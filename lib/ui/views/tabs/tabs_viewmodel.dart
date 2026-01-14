import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:stacked/stacked.dart';

import '../collection/collection_view.dart';
import '../tasks/tasks_view.dart';
import '../home/home_view.dart';
import '../shop/shop_view.dart';
import '../profile/profile_view.dart';

class TabsViewModel extends BaseViewModel {
  late PersistentTabController _tabController;

  PersistentTabController get tabController => _tabController;

  TabsViewModel() {
    // Initialise avec l'onglet Home au démarrage (index 2)
    _tabController = PersistentTabController(initialIndex: 2);
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

  // Configuration des items de la bottom nav bar
  List<PersistentBottomNavBarItem> navBarItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.auto_stories),
          title: 'Collection',
          activeColorPrimary: const Color(0xFF6366F1),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.format_list_bulleted),
          title: 'Tâches',
          activeColorPrimary: const Color(0xFF6366F1),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.landscape),
          title: 'Accueil',
          activeColorPrimary: const Color(0xFF6366F1),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.storefront),
          title: 'Boutique',
          activeColorPrimary: const Color(0xFF6366F1),
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: 'Profil',
          activeColorPrimary: const Color(0xFF6366F1),
          inactiveColorPrimary: Colors.grey,
        ),
      ];
}
