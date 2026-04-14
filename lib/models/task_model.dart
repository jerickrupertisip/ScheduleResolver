import "package:flutter/material.dart";

class TaskModel {
  final String id;
  final String title;
  final String category;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int urgency;
  final double importance;
  final double estimateEffortHours;
  final String energyLevel;

  TaskModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.urgency,
    required this.importance,
    required this.estimateEffortHours,
    required this.energyLevel,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "category": category,
      "date": date.toIso8601String().split("T").first,
      "startTime": "${startTime.hour}:${startTime.minute}",
      "endTime": "${endTime.hour}:${endTime.minute}",
      "urgency": urgency,
      "importance": importance,
      "estimateEffortHours": estimateEffortHours,
      "energyLevel": energyLevel,
    };
  }
}