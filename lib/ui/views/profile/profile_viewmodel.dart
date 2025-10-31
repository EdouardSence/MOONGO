import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/app/app.router.dart';
import 'package:my_first_app/services/authentication_service.dart';
import 'package:my_first_app/services/firestore_service.dart';
import 'package:my_first_app/services/gamification_service.dart';
import 'package:my_first_app/models/user_model.dart';

class ProfileViewModel extends BaseViewModel {
  final _authService = locator<AuthenticationService>();
  final _firestoreService = locator<FirestoreService>();
  final _gamificationService = locator<GamificationService>();
  final _navigationService = locator<NavigationService>();

  UserModel? _user;
  int _creatureCount = 0;
  int _routineCount = 0;

  String get userName => _user?.displayName ?? 'Utilisateur';
  String get userEmail => _user?.email ?? '';
  String get userInitials {
    if (_user?.displayName != null && _user!.displayName!.isNotEmpty) {
      return _user!.displayName![0].toUpperCase();
    }
    if (_user?.email != null && _user!.email.isNotEmpty) {
      return _user!.email[0].toUpperCase();
    }
    return 'U';
  }

  int get totalExperience => _user?.totalExperience ?? 0;
  int get userLevel => _gamificationService.calculateUserLevel(totalExperience);
  int get creatureCount => _creatureCount;
  int get routineCount => _routineCount;

  Future<void> initialize() async {
    await loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      setBusy(true);
      final userId = _authService.currentUser?.uid;
      if (userId != null) {
        _user = await _firestoreService.getUserProfile(userId);

        // Charger les statistiques
        final creatures = await _firestoreService.getUserCreatures(userId);
        _creatureCount = creatures.length;

        final routines = await _firestoreService.getUserRoutines(userId);
        _routineCount = routines.length;

        notifyListeners();
      }
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      _navigationService.replaceWithLoginView();
    } catch (e) {
      setError(e.toString());
    }
  }
}
