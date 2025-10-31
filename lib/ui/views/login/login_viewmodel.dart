import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:my_first_app/services/authentication_service.dart';
import 'package:my_first_app/services/firestore_service.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthenticationService>();
  final _firestoreService = locator<FirestoreService>();
  final _dialogService = locator<DialogService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _showPassword = false;
  bool get showPassword => _showPassword;

  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  Future<void> login() async {
    if (!_validateInputs()) return;

    try {
      setBusy(true);
      final user = await _authService.signInWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (user != null) {
        // Naviguer vers la page d'accueil
        _navigationService.replaceWithHomeView();
      }
    } catch (e) {
      setError(e.toString());
      await _dialogService.showDialog(
        title: 'Erreur de connexion',
        description: e.toString(),
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> signUp() async {
    if (!_validateInputs()) return;

    try {
      setBusy(true);
      final user = await _authService.signUpWithEmail(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (user != null) {
        // Créer le profil utilisateur dans Firestore
        await _firestoreService.createUserProfile(user);

        // Naviguer vers la page d'accueil
        _navigationService.replaceWithHomeView();
      }
    } catch (e) {
      setError(e.toString());
      await _dialogService.showDialog(
        title: 'Erreur d\'inscription',
        description: e.toString(),
      );
    } finally {
      setBusy(false);
    }
  }

  bool _validateInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setError('Veuillez remplir tous les champs');
      return false;
    }

    if (!email.contains('@')) {
      setError('Email invalide');
      return false;
    }

    if (password.length < 6) {
      setError('Le mot de passe doit contenir au moins 6 caractères');
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
