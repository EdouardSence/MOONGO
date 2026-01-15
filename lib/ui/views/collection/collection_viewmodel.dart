import 'package:moongo/app/app.locator.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/models/shop_item_model.dart';
import 'package:moongo/models/user_model.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/services/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CollectionViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _authService = locator<AuthenticationService>();

  final _dialogService = locator<DialogService>();

  UserModel? _user;
  List<CreatureModel> _creatures = [];

  List<CreatureModel> get creatures => _creatures;
  int get seeds => _user?.seeds ?? 0;

  String? get _userId => _authService.userId;

  void init() {
    _loadData();
  }

  void _loadData() {
    if (_userId == null) return;

    setBusy(true);
    _firestoreService.userStream(_userId!).listen((user) {
      _user = user;
      notifyListeners();
    });

    _firestoreService.creaturesStream(_userId!).listen((creatures) {
      _creatures = creatures;
      setBusy(false);
      notifyListeners();
    });
  }

  Future<bool> feedCreature(CreatureModel creature, FoodItem food) async {
    if (_userId == null || seeds < food.price) return false;

    // Check theoretical evolution
    final willLevelUp =
        (creature.currentXp + food.xpGiven) >= creature.xpToNextLevel &&
            !creature.isMaxLevel;

    final success =
        await _firestoreService.feedCreature(_userId!, creature, food, seeds);

    if (success && willLevelUp) {
      await _dialogService.showDialog(
        title: '🎉 Niveau Supérieur !',
        description: '${creature.name} a évolué et devient plus fort !',
        buttonTitle: 'Génial !',
        barrierDismissible: true,
      );
    }

    return success;
  }
}
