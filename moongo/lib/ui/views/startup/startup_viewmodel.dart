import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final AuthenticationService authService = locator<AuthenticationService>();
  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    // Petit délai pour le splash screen
    await Future.delayed(const Duration(seconds: 1));

    authService.firebaseAuth.authStateChanges().listen((User? user) {
      if (user != null) {
        _navigationService.replaceWithHomeView();
      } else {
        _navigationService.replaceWithLoginView();
      }
    });
  }
}
