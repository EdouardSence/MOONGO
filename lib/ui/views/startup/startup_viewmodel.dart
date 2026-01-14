import 'package:firebase_auth/firebase_auth.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/services/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();
  final AuthenticationService authService = locator<AuthenticationService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    // Petit délai pour le splash screen
    await Future.delayed(const Duration(seconds: 1));

    authService.firebaseAuth.authStateChanges().listen((User? user) async {
      if (user != null) {
        // Vérifier si l'utilisateur a déjà un profil Firestore
        final hasProfile = await _firestoreService.userExists(user.uid);
        if (hasProfile) {
          _navigationService.replaceWithTabsView();
        } else {
          // Nouvel utilisateur -> onboarding
          _navigationService.replaceWithOnboardingView();
        }
      } else {
        _navigationService.replaceWithLoginView();
      }
    });
  }
}
