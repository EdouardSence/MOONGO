import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskType {
  single, // Tâche unique/spontanée
  recurring, // Routine récurrente
  objective, // Objectif avec sous-tâches
}

enum RecurrenceFrequency {
  daily,
  weekly,
  monthly,
  custom,
}

class SubTask {
  final String id;
  final String title;
  final bool completed;
  final DateTime? completedAt;
  final int order;
  final int seedsReward;

  SubTask({
    required this.id,
    required this.title,
    this.completed = false,
    this.completedAt,
    this.order = 0,
    this.seedsReward = 5,
  });

  factory SubTask.fromMap(Map<String, dynamic> data) {
    return SubTask(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      completed: data['completed'] ?? false,
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      order: data['order'] ?? 0,
      seedsReward: data['seedsReward'] ?? 5,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'order': order,
      'seedsReward': seedsReward,
    };
  }

  SubTask copyWith({
    String? id,
    String? title,
    bool? completed,
    DateTime? completedAt,
    int? order,
    int? seedsReward,
  }) {
    return SubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      order: order ?? this.order,
      seedsReward: seedsReward ?? this.seedsReward,
    );
  }
}

class RecurrenceConfig {
  final RecurrenceFrequency frequency;
  final List<int>? daysOfWeek; // 1=Lundi, 7=Dimanche
  final int? customDays; // Tous les X jours

  RecurrenceConfig({
    required this.frequency,
    this.daysOfWeek,
    this.customDays,
  });

  factory RecurrenceConfig.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      return RecurrenceConfig(frequency: RecurrenceFrequency.daily);
    }
    return RecurrenceConfig(
      frequency: RecurrenceFrequency.values.firstWhere(
        (e) => e.name == data['frequency'],
        orElse: () => RecurrenceFrequency.daily,
      ),
      daysOfWeek: (data['daysOfWeek'] as List<dynamic>?)?.cast<int>(),
      customDays: data['customDays'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'frequency': frequency.name,
      'daysOfWeek': daysOfWeek,
      'customDays': customDays,
    };
  }
}

class TaskModel {
  final String taskId;
  final String userId;
  final String title;
  final String? description;
  final String icon;
  final String color;
  final TaskType type;
  final RecurrenceConfig? recurrence;
  final DateTime? dueDate;
  final int seedsReward;
  final bool completed;
  final DateTime? completedAt;
  final List<SubTask> subTasks; // Pour les objectifs
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;

  TaskModel({
    required this.taskId,
    required this.userId,
    required this.title,
    this.description,
    this.icon = '✨',
    this.color = '#6366F1',
    required this.type,
    this.recurrence,
    this.dueDate,
    this.seedsReward = 10,
    this.completed = false,
    this.completedAt,
    this.subTasks = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      taskId: data['taskId'] ?? doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      icon: data['icon'] ?? '✨',
      color: data['color'] ?? '#6366F1',
      type: TaskType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => TaskType.single,
      ),
      recurrence: data['recurrence'] != null
          ? RecurrenceConfig.fromMap(data['recurrence'])
          : null,
      dueDate: (data['dueDate'] as Timestamp?)?.toDate(),
      seedsReward: data['seedsReward'] ?? 10,
      completed: data['completed'] ?? false,
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
      subTasks: (data['subTasks'] as List<dynamic>?)
              ?.map((e) => SubTask.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isArchived: data['isArchived'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'taskId': taskId,
      'userId': userId,
      'title': title,
      'description': description,
      'icon': icon,
      'color': color,
      'type': type.name,
      'recurrence': recurrence?.toMap(),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'seedsReward': seedsReward,
      'completed': completed,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'subTasks': subTasks.map((e) => e.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isArchived': isArchived,
    };
  }

  TaskModel copyWith({
    String? taskId,
    String? userId,
    String? title,
    String? description,
    String? icon,
    String? color,
    TaskType? type,
    RecurrenceConfig? recurrence,
    DateTime? dueDate,
    int? seedsReward,
    bool? completed,
    DateTime? completedAt,
    List<SubTask>? subTasks,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) {
    return TaskModel(
      taskId: taskId ?? this.taskId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
      recurrence: recurrence ?? this.recurrence,
      dueDate: dueDate ?? this.dueDate,
      seedsReward: seedsReward ?? this.seedsReward,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      subTasks: subTasks ?? this.subTasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  // Calcul de la progression pour les objectifs
  double get progress {
    if (type != TaskType.objective || subTasks.isEmpty) {
      return completed ? 1.0 : 0.0;
    }
    final completedCount = subTasks.where((t) => t.completed).length;
    return completedCount / subTasks.length;
  }

  // Vérifie si la tâche doit être faite aujourd'hui
  bool get isDueToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (type == TaskType.single) {
      if (dueDate == null) return true; // Pas de date = visible
      final due = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
      return due.isAtSameMomentAs(today) || due.isBefore(today);
    }

    if (type == TaskType.recurring && recurrence != null) {
      switch (recurrence!.frequency) {
        case RecurrenceFrequency.daily:
          return true;
        case RecurrenceFrequency.weekly:
          return recurrence!.daysOfWeek?.contains(now.weekday) ?? true;
        case RecurrenceFrequency.monthly:
          return now.day == createdAt.day;
        case RecurrenceFrequency.custom:
          if (recurrence!.customDays == null) return true;
          final daysSinceCreation = today
              .difference(
                  DateTime(createdAt.year, createdAt.month, createdAt.day))
              .inDays;
          return daysSinceCreation % recurrence!.customDays! == 0;
      }
    }

    // Objectifs sont toujours visibles
    return type == TaskType.objective;
  }

  // Vérifie si c'est dans la semaine
  bool get isDueThisWeek {
    // Si c'est un objectif, c'est un projet long terme donc visible
    if (type == TaskType.objective) return true;

    // Si c'est une routine
    if (type == TaskType.recurring) {
      // Daily et Weekly sont forcément dûs cette semaine
      if (recurrence?.frequency == RecurrenceFrequency.daily ||
          recurrence?.frequency == RecurrenceFrequency.weekly) {
        return true;
      }

      // Pour monthly et custom, on simplifie en disant qu'ils apparaissent
      return true;
    }

    // Pour les tâches uniques
    final now = DateTime.now();
    // Début de semaine (Lundi)
    final startOfWeek =
        DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final endOfWeek =
        startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59));

    if (dueDate == null) return true;

    // Si la date est avant la fin de semaine (inclut les tâches en retard)
    return dueDate!.isBefore(endOfWeek) || dueDate!.isAtSameMomentAs(endOfWeek);
  }

  // Vérifie si c'est dans le mois
  bool get isDueThisMonth {
    // Objectifs et routines sont toujours pertinents pour la vue mensuelle
    if (type == TaskType.objective || type == TaskType.recurring) return true;

    // Pour les tâches uniques
    final now = DateTime.now();
    if (dueDate == null) return true; // Sans date = visible partout

    // Si c'est ce mois-ci ou avant (en retard)
    return (dueDate!.year == now.year && dueDate!.month == now.month) ||
        dueDate!.isBefore(DateTime(now.year, now.month, 1));
  }
}
