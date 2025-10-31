import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:my_first_app/ui/views/routines/routines_view.dart';
import 'package:my_first_app/ui/views/creatures/creatures_view.dart';
import 'package:my_first_app/ui/views/profile/profile_view.dart';

class HomeViewModel extends IndexTrackingViewModel {
  final List<Widget> pages = [
    const RoutinesView(),
    const CreaturesView(),
    const ProfileView(),
  ];

  void initialize() {
    // Initialization logic if needed
  }
}
