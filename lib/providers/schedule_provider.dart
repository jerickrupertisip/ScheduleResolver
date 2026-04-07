import "package:flutter/material.dart";
import "package:schedule_resolver/models/task_model.dart";
import "package:uuid/uuid.dart";

class ScheduleProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];
  final Uuid _uuid = const Uuid();

  List<TaskModel> get tasks => _tasks;

  void addTask({
    required String id,
    required String title,
    required String category,
    required DateTime date,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int urgency,
    required double importance,
    required String estimateEffortHours,
    required String energyLevel,
  }) {
    final newTask = TaskModel(
      id: _uuid.v4(),
      title: title,
      category: category,
      date: date,
      startTime: startTime,
      endTime: endTime,
      urgency: urgency,
      importance: importance,
      estimateEffortHours: estimateEffortHours,
      energyLevel: energyLevel,
    );

    _tasks.add(newTask);
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
