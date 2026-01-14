import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:stacked/stacked.dart';

import '../collection/collection_view.dart';
import '../calendar/calendar_view.dart';
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
        const CalendarView(),
        const HomeView(),
        const ShopView(),
        const ProfileView(),
      ];

  // Configuration des items de la bottom nav bar
  List<PersistentBottomNavBarItem> navBarItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.collections),
          title: 'Collection',
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.calendar_month),
          title: 'Calendrier',
          activeColorPrimary: Colors.green,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: 'Home',
          activeColorPrimary: Colors.red,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_bag),
          title: 'Boutique',
          activeColorPrimary: Colors.orange,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: 'Profil',
          activeColorPrimary: Colors.purple,
          inactiveColorPrimary: Colors.grey,
        ),
      ];
}
