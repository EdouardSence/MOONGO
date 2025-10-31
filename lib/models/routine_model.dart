import 'package:json_annotation/json_annotation.dart';

part 'routine_model.g.dart';

@JsonSerializable()
class RoutineModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final List<TaskModel> tasks;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  RoutineModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.tasks = const [],
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoutineModelToJson(this);

  RoutineModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    List<TaskModel>? tasks,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return RoutineModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      tasks: tasks ?? this.tasks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  int get completedTasksCount => tasks.where((task) => task.isCompleted).length;
  int get totalTasksCount => tasks.length;
  double get completionPercentage =>
      totalTasksCount > 0 ? (completedTasksCount / totalTasksCount) * 100 : 0;
}

@JsonSerializable()
class TaskModel {
  final String id;
  final String title;
  final int experienceReward;
  final bool isCompleted;
  final DateTime? completedAt;

  TaskModel({
    required this.id,
    required this.title,
    this.experienceReward = 10,
    this.isCompleted = false,
    this.completedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  TaskModel copyWith({
    String? id,
    String? title,
    int? experienceReward,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      experienceReward: experienceReward ?? this.experienceReward,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
