import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/app/app.router.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/services/firestore_service.dart';
import 'package:stacked_services/stacked_services.dart';

class OnboardingViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  final TextEditingController nameController = TextEditingController();

  String _selectedAvatar = '😊';
  DateTime? _birthDate;

  String get selectedAvatar => _selectedAvatar;
  DateTime? get birthDate => _birthDate;

  final List<String> availableAvatars = [
    '😊',
    '😎',
    '🥳',
    '🤓',
    '🧐',
    '😇',
    '🤠',
    '🥷',
    '🧙‍♂️',
    '🧚',
    '🦸',
    '🦹',
    '🧝',
    '🧛',
    '🧟',
    '🐱',
    '🐶',
    '🦊',
    '🐼',
    '🐨',
    '🦁',
    '🐸',
    '🐙',
    '🦋',
    '🐲',
  ];

  void selectAvatar(String avatar) {
    _selectedAvatar = avatar;
    notifyListeners();
  }

  void setBirthDate(DateTime date) {
    _birthDate = date;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    final userId = _authService.userId;
    final email = _authService.userEmail;

    if (userId == null || email == null) return;

    setBusy(true);

    try {
      // Créer le profil utilisateur dans Firestore
      await _firestoreService.createUserWithAvatar(
        userId: userId,
        email: email,
        displayName:
            nameController.text.isNotEmpty ? nameController.text : 'Joueur',
        avatarEmoji: _selectedAvatar,
        birthDate: _birthDate,
      );

      // Naviguer vers l'app principale
      _navigationService.clearStackAndShow(Routes.tabsView);
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
