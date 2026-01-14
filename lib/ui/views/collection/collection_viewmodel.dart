import 'package:stacked/stacked.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/services/firestore_service.dart';

class CollectionViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _authService = locator<AuthenticationService>();

  List<CreatureModel> _creatures = [];
  List<CreatureModel> get creatures => _creatures;

  String? get _userId => _authService.userId;

  void init() {
    _loadCreatures();
  }

  void _loadCreatures() {
    if (_userId == null) return;

    setBusy(true);
    _firestoreService.creaturesStream(_userId!).listen((creatures) {
      _creatures = creatures;
      setBusy(false);
      notifyListeners();
    });
  }
}
