import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  // Variables pour stocker les données
  String emailAddress = '';
  String password = '';
  String? errorMessage;
  bool isLoading = false;

  // Met à jour l'email
  void setEmail(String value) {
    emailAddress = value;
  }

  // Met à jour le mot de passe
  void setPassword(String value) {
    password = value;
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
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      // Login réussi !
      print('Utilisateur créé: ${credential.user?.email}');
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
