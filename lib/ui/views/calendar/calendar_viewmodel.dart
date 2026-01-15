import 'package:moongo/app/app.locator.dart';
import 'package:moongo/models/task_model.dart';
import 'package:moongo/services/authentication_service.dart';
import 'package:moongo/services/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _authService = locator<AuthenticationService>();

  List<TaskModel> _allTasks = [];
  List<TaskModel> _tasksForSelectedDay = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<TaskModel> get tasksForSelectedDay => _tasksForSelectedDay;
  DateTime get selectedDay => _selectedDay;
  DateTime get focusedDay => _focusedDay;
  CalendarFormat get calendarFormat => _calendarFormat;

  void init() {
    final userId = _authService.userId;
    if (userId != null) {
      setBusy(true);
      _firestoreService.tasksStream(userId).listen((tasks) {
        _allTasks = tasks;
        _updateSelectedDayTasks();
        notifyListeners();
        setBusy(false);
      });
    }
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _updateSelectedDayTasks();
      notifyListeners();
    }
  }

  void onFormatChanged(CalendarFormat format) {
    if (_calendarFormat != format) {
      _calendarFormat = format;
      notifyListeners();
    }
  }

  void onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
  }

  void _updateSelectedDayTasks() {
    _tasksForSelectedDay = getTasksForDay(_selectedDay);
  }

  List<TaskModel> getTasksForDay(DateTime day) {
    return _allTasks.where((task) {
      // Pour l'agenda, on veut peut-être voir même les tâches terminées ?
      // Disons qu'on affiche tout pour l'historique.

      // Single
      if (task.type == TaskType.single) {
        if (task.dueDate == null) return false;
        return isSameDay(task.dueDate!, day);
      }

      // Recurring
      if (task.type == TaskType.recurring) {
        if (task.recurrence == null) return false;
        switch (task.recurrence!.frequency) {
          case RecurrenceFrequency.daily:
            return true;
          case RecurrenceFrequency.weekly:
            return task.recurrence!.daysOfWeek?.contains(day.weekday) ?? false;
          case RecurrenceFrequency.monthly:
            return day.day == task.createdAt.day;
          case RecurrenceFrequency.custom:
            // Simplification : on n'affiche pas les custom pour l'instant
            return false;
        }
      }

      // Objective
      if (task.type == TaskType.objective) {
        if (task.dueDate != null) {
          return isSameDay(task.dueDate!, day);
        }
        return false;
      }

      return false;
    }).toList();
  }

  Future<void> toggleTask(TaskModel task) async {
    final userId = _authService.userId;
    if (userId == null) return;
    await _firestoreService.completeTask(userId, task);
  }
}
