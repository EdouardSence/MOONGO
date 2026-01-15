import 'package:moongo/app/app.locator.dart';
import 'package:moongo/app/app.router.dart';
import 'package:moongo/models/creature_model.dart';
import 'package:moongo/models/task_model.dart';
import 'package:moongo/models/user_model.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/services/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  UserModel? _user;
  List<CreatureModel> _creatures = [];
  List<TaskModel> _tasks = [];

  int get seeds => _user?.seeds ?? 0;
  List<CreatureModel> get creatures => _creatures;
  List<TaskModel> get todayTasks =>
      _tasks.where((t) => t.isDueToday && !t.isArchived).toList();
  int get completedTodayCount => todayTasks.where((t) => t.completed).length;

  String? get _userId => _authService.userId;

  void init() {
    _loadData();
  }

  void _loadData() {
    if (_userId == null) return;

    // Charger l'utilisateur
    _firestoreService.userStream(_userId!).listen((user) {
      _user = user;
      notifyListeners();
    });

    // Charger les créatures
    _firestoreService.creaturesStream(_userId!).listen((creatures) {
      _creatures = creatures;
      notifyListeners();
    });

    // Charger les tâches
    _firestoreService.tasksStream(_userId!).listen((tasks) {
      _tasks = tasks;
      notifyListeners();
    });
  }

  Future<void> completeTask(TaskModel task) async {
    if (_userId == null) return;
    await _firestoreService.completeTask(_userId!, task);
  }

  void navigateToTasks() {
    _navigationService.clearStackAndShow(
      Routes.tabsView,
      arguments: const TabsViewArguments(initialIndex: 1),
    );
  }
}
