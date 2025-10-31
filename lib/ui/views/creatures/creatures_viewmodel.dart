import 'package:stacked/stacked.dart';
import 'package:my_first_app/app/app.locator.dart';
import 'package:my_first_app/services/authentication_service.dart';
import 'package:my_first_app/services/firestore_service.dart';
import 'package:my_first_app/models/creature_model.dart';

class CreaturesViewModel extends BaseViewModel {
  final _authService = locator<AuthenticationService>();
  final _firestoreService = locator<FirestoreService>();

  List<CreatureModel> _creatures = [];
  List<CreatureModel> get creatures => _creatures;

  Future<void> initialize() async {
    await loadCreatures();
  }

  Future<void> loadCreatures() async {
    try {
      setBusy(true);
      final userId = _authService.currentUser?.uid;
      if (userId != null) {
        _creatures = await _firestoreService.getUserCreatures(userId);
        notifyListeners();
      }
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }
}
