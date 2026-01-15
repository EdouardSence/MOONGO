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
  
  // Cache for daily recurring tasks to improve performance
  List<TaskModel> _dailyRecurringTasks = [];

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
        _updateDailyRecurringTasksCache();
        _updateSelectedDayTasks();
        notifyListeners();
        setBusy(false);
      });
    }
  }

  void _updateDailyRecurringTasksCache() {
    _dailyRecurringTasks = _allTasks
        .where((task) =>
            task.type == TaskType.recurring &&
            task.recurrence?.frequency == RecurrenceFrequency.daily)
        .toList();
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

  /// Helper to check if a task should be visible on the given day based on creation date
  bool _isTaskVisibleOnDay(TaskModel task, DateTime day) {
    final taskCreatedDate = DateTime(
      task.createdAt.year,
      task.createdAt.month,
      task.createdAt.day,
    );
    return day.isAfter(taskCreatedDate) || isSameDay(day, taskCreatedDate);
  }

  List<TaskModel> getTasksForDay(DateTime day) {
    final result = <TaskModel>[];
    
    // Add daily recurring tasks from cache (performance optimization)
    // Only include if the task was created on or before the given day
    for (final task in _dailyRecurringTasks) {
      if (_isTaskVisibleOnDay(task, day)) {
        result.add(task);
      }
    }
    
    // Filter other tasks (excluding daily recurring which are already processed)
    for (final task in _allTasks) {
      // Skip daily recurring tasks as they're already processed above
      if (task.type == TaskType.recurring &&
          task.recurrence?.frequency == RecurrenceFrequency.daily) {
        continue;
      }

      // Single
      if (task.type == TaskType.single) {
        if (task.dueDate == null) continue;
        if (isSameDay(task.dueDate!, day)) {
          result.add(task);
        }
        continue;
      }

      // Recurring (non-daily)
      if (task.type == TaskType.recurring) {
        if (task.recurrence == null) continue;
        
        // Check if task is visible on this day (created before or on this day)
        if (!_isTaskVisibleOnDay(task, day)) continue;
        
        switch (task.recurrence!.frequency) {
          case RecurrenceFrequency.daily:
            // Already handled above
            break;
          case RecurrenceFrequency.weekly:
            if (task.recurrence!.daysOfWeek?.contains(day.weekday) ?? false) {
              result.add(task);
            }
            break;
          case RecurrenceFrequency.monthly:
            if (day.day == task.createdAt.day) {
              result.add(task);
            }
            break;
          case RecurrenceFrequency.custom:
            // Simplification : on n'affiche pas les custom pour l'instant
            break;
        }
        continue;
      }

      // Objective
      if (task.type == TaskType.objective) {
        if (task.dueDate != null && isSameDay(task.dueDate!, day)) {
          result.add(task);
        }
      }
    }
    
    return result;
  }

  Future<void> toggleTask(TaskModel task) async {
    final userId = _authService.userId;
    if (userId == null) return;
    await _firestoreService.completeTask(userId, task);
  }
}
