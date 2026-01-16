import 'package:stacked/stacked.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/models/user_model.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/services/firestore_service.dart';
import 'package:moongo/services/theme_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:moongo/app/app.router.dart';

class ProfileViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _themeService = locator<ThemeService>();

  UserModel? _user;
  int _creaturesCount = 0;

  UserModel? get user => _user;
  int get creaturesCount => _creaturesCount;
  bool get isDarkMode => _themeService.isDarkMode;

  String? get _userId => _authService.userId;

  // Liste des avatars disponibles
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

  void init() {
    _loadData();
  }

  void _loadData() {
    if (_userId == null) return;

    setBusy(true);

    _firestoreService.userStream(_userId!).listen((user) {
      _user = user;
      setBusy(false);
      notifyListeners();
    });

    _firestoreService.creaturesStream(_userId!).listen((creatures) {
      _creaturesCount = creatures.length;
      notifyListeners();
    });
  }

  Future<void> toggleTheme() async {
    await _themeService.toggleTheme();
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    await _themeService.setDarkMode(value);
    notifyListeners();
  }

  Future<void> updateDisplayName(String name) async {
    if (_user == null || name.isEmpty) return;
    final updatedUser = _user!.copyWith(displayName: name);
    await _firestoreService.updateUser(updatedUser);
  }

  Future<void> updateBirthDate(DateTime date) async {
    if (_user == null) return;
    final updatedUser = _user!.copyWith(birthDate: date);
    await _firestoreService.updateUser(updatedUser);
  }

  Future<void> updateAvatar(String avatar) async {
    if (_user == null) return;
    final updatedUser = _user!.copyWith(avatarUrl: avatar);
    await _firestoreService.updateUser(updatedUser);
  }

  Future<void> logout() async {
    await _authService.signOut();
    _navigationService.clearStackAndShow(Routes.loginView);
  }

  Future<void> deleteAccount() async {
    // TODO: Implémenter la suppression du compte
    await _authService.signOut();
    _navigationService.clearStackAndShow(Routes.loginView);
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String formatMemberSince(DateTime? date) {
    if (date == null) return '-';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays < 30) return '${diff.inDays}j';
    if (diff.inDays < 365) return '${diff.inDays ~/ 30}m';
    return '${diff.inDays ~/ 365}a';
  }
}
