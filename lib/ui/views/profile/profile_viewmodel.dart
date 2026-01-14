import 'package:stacked/stacked.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/models/user_model.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/services/firestore_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:moongo/app/app.router.dart';

class ProfileViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  UserModel? _user;
  int _creaturesCount = 0;

  UserModel? get user => _user;
  int get creaturesCount => _creaturesCount;

  String? get _userId => _authService.userId;

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

  Future<void> updateDisplayName(String name) async {
    if (_user == null || name.isEmpty) return;
    await _firestoreService.updateUser(_user!.copyWith(displayName: name));
  }

  Future<void> updateBirthDate(DateTime date) async {
    if (_user == null) return;
    await _firestoreService.updateUser(_user!.copyWith(birthDate: date));
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
}
