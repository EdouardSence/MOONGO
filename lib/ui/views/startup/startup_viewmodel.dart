import 'package:stacked/stacked.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:my_first_app/services/authentication_service.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthenticationService>();

  // Logique de démarrage
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Vérifier si l'utilisateur est connecté
      final user = _authService.currentUser;

      if (user != null) {
        // Utilisateur connecté -> aller à l'accueil
        _navigationService.replaceWithHomeView();
      } else {
        // Pas d'utilisateur -> aller à la connexion
        _navigationService.replaceWithLoginView();
      }
    } catch (e) {
      // Si Firebase n'est pas configuré, aller directement à Home en mode démo
      print('⚠️ Erreur lors de la vérification auth: $e');
      print('💡 Navigation vers Home en mode démo');
      _navigationService.replaceWithHomeView();
    }
  }
}
