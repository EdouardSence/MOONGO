import 'package:moongo/app/app.locator.dart';
import 'package:moongo/app/app.router.dart';
import 'package:moongo/models/task_model.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/services/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TasksViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _authService = locator<AuthenticationService>();
  final _navigationService = locator<NavigationService>();

  List<TaskModel> _tasks = [];
  int _selectedTabIndex = 0;

  int get selectedTabIndex => _selectedTabIndex;
  set selectedTabIndex(int value) {
    _selectedTabIndex = value;
    notifyListeners();
  }

  List<TaskModel> get allTasks => _tasks;
  List<TaskModel> get todayTasks =>
      _tasks.where((t) => t.isDueToday && !t.isArchived).toList();
  List<TaskModel> get weekTasks =>
      _tasks.where((t) => t.isDueThisWeek && !t.isArchived).toList();
  List<TaskModel> get monthTasks =>
      _tasks.where((t) => t.isDueThisMonth && !t.isArchived).toList();

  List<TaskModel> get currentTasks {
    switch (_selectedTabIndex) {
      case 0:
        return allTasks;
      case 1:
        return todayTasks;
      case 2:
        return weekTasks;
      case 3:
        return monthTasks;
      default:
        return allTasks;
    }
  }

  String? get _userId => _authService.userId;

  void navigateToCalendar() {
    _navigationService.navigateTo(Routes.calendarView);
  }

  void init() {
    _loadTasks();
  }

  void _loadTasks() {
    if (_userId == null) return;

    setBusy(true);
    _firestoreService.tasksStream(_userId!).listen((tasks) {
      _tasks = tasks;
      setBusy(false);
      notifyListeners();
    });
  }

  Future<void> createTask({
    required String title,
    String? description,
    String icon = '✨',
    String color = '#6366F1',
    required TaskType type,
    int seedsReward = 10,
    DateTime? dueDate,
    RecurrenceConfig? recurrence,
    List<SubTask>? subTasks,
  }) async {
    if (_userId == null) return;

    await _firestoreService.createTask(
      userId: _userId!,
      title: title,
      description: description,
      icon: icon,
      color: color,
      type: type,
      seedsReward: seedsReward,
      dueDate: dueDate,
      recurrence: recurrence,
      subTasks: subTasks,
    );
  }

  Future<void> completeTask(TaskModel task) async {
    if (_userId == null) return;
    await _firestoreService.completeTask(_userId!, task);
  }

  Future<void> deleteTask(String taskId) async {
    await _firestoreService.deleteTask(taskId);
  }

  Future<void> addSubTaskToObjective(String taskId, String subTaskTitle) async {
    final subTask = SubTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: subTaskTitle,
      order: 0,
    );
    await _firestoreService.addSubTask(taskId, subTask);
  }

  Future<void> completeSubTask(TaskModel task, String subTaskId) async {
    if (_userId == null) return;
    await _firestoreService.completeSubTask(task, subTaskId);

    // Récupérer la sous-tâche pour donner sa récompense spécifique
    final subTask = task.subTasks.firstWhere((st) => st.id == subTaskId);
    await _firestoreService.updateSeeds(_userId!, subTask.seedsReward);

    // Vérifier si toutes les sous-tâches sont complétées pour ajouter les graines (Bonus de fin)
    final updatedSubTasks = task.subTasks.map((st) {
      if (st.id == subTaskId) {
        return st.copyWith(completed: true);
      }
      return st;
    }).toList();

    if (updatedSubTasks.every((st) => st.completed)) {
      await _firestoreService.updateSeeds(_userId!, task.seedsReward);
    }
  }
}
