import 'package:firebase_auth/firebase_auth.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  // Variables pour stocker les données
  String emailAddress = '';
  String password = '';
  String? errorMessage;
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool loginMode = true;

  final _navigationService = locator<NavigationService>();

  // Met à jour l'email
  void setEmail(String value) {
    emailAddress = value;
  }

  // Met à jour le mot de passe
  void setPassword(String value) {
    password = value;
  }

  // Change le mode de visibilité du mot de passe
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleLoginMode() {
    loginMode = !loginMode;
    notifyListeners();
  }

  // Logique de login
  Future<void> runLoginLogic() async {
    // Validation simple
    if (emailAddress.isEmpty || password.isEmpty) {
      errorMessage = 'Email et mot de passe requis';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      // Login réussi !
      print('Utilisateur connecté: ${credential.user?.email}');
      _navigationService.replaceWithHomeView();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'Le mot de passe est trop faible';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Cet email est déjà utilisé';
      } else {
        errorMessage = e.message ?? 'Erreur inconnue';
      }
    } catch (e) {
      errorMessage = 'Erreur: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
