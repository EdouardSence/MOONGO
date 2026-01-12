import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    // Vérifie si un utilisateur est déjà connecté (PERSISTANT)
    final currentUser = FirebaseAuth.instance.currentUser;

    // Petit délai pour le splash screen
    await Future.delayed(const Duration(seconds: 1));

    if (currentUser != null) {
      // Utilisateur déjà connecté → Va directement à Home
      print('Utilisateur déjà connecté: ${currentUser.email}');
      _navigationService.replaceWithHomeView();
    } else {
      // Pas d'utilisateur → Va au Login
      print('Pas d\'utilisateur connecté');
      _navigationService.replaceWithLoginView();
    }
  }
}
