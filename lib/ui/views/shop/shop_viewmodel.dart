import 'package:flutter/widgets.dart';
import 'package:moongo/app/app.locator.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/models/shop_item_model.dart';
import 'package:moongo/models/user_model.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/services/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ShopViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _authService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();

  final ScrollController scrollController = ScrollController();
  bool _showStickyHeader = false;
  bool get showStickyHeader => _showStickyHeader;

  UserModel? _user;
  List<CreatureModel> _creatures = [];

  int get seeds => _user?.seeds ?? 0;
  List<CreatureModel> get creatures => _creatures;

  String? get _userId => _authService.userId;

  void init() {
    _loadData();
    scrollController.addListener(_onHeaderScroll);
  }

  void _onHeaderScroll() {
    if (scrollController.hasClients) {
      final show = scrollController.offset > 160;
      if (show != _showStickyHeader) {
        _showStickyHeader = show;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _loadData() {
    if (_userId == null) return;

    _firestoreService.userStream(_userId!).listen((user) {
      _user = user;
      notifyListeners();
    });

    _firestoreService.creaturesStream(_userId!).listen((creatures) {
      _creatures = creatures;
      notifyListeners();
    });
  }

  Future<CreatureModel?> buyEgg(EggItem egg) async {
    if (_userId == null || seeds < egg.price) return null;
    return await _firestoreService.buyEgg(_userId!, egg, seeds);
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
