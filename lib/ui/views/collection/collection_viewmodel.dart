import 'package:moongo/app/app.locator.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/models/shop_item_model.dart';
import 'package:moongo/models/user_model.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/services/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

enum SortField { name, level, rarity }

enum SortOrder { ascending, descending }

class CollectionViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _authService = locator<AuthenticationService>();

  final _dialogService = locator<DialogService>();

  UserModel? _user;
  List<CreatureModel> _creatures = [];

  // Sorting state
  SortField _sortField = SortField.name;
  SortOrder _sortOrder = SortOrder.ascending;

  SortField get sortField => _sortField;
  SortOrder get sortOrder => _sortOrder;

  List<CreatureModel> get creatures {
    final sorted = List<CreatureModel>.from(_creatures);

    sorted.sort((a, b) {
      int comparison;
      switch (_sortField) {
        case SortField.name:
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case SortField.level:
          comparison = a.level.compareTo(b.level);
          break;
        case SortField.rarity:
          comparison = a.rarity.index.compareTo(b.rarity.index);
          break;
      }
      return _sortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    return sorted;
  }

  int get seeds => _user?.seeds ?? 0;

  String? get _userId => _authService.userId;

  void init() {
    _loadData();
  }

  void setSortField(SortField field) {
    if (_sortField == field) {
      // Toggle order if same field
      _sortOrder = _sortOrder == SortOrder.ascending
          ? SortOrder.descending
          : SortOrder.ascending;
    } else {
      _sortField = field;
      _sortOrder = SortOrder.ascending;
    }
    notifyListeners();
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
