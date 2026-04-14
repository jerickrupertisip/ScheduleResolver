import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:google_generative_ai/google_generative_ai.dart";
import "package:schedule_resolver/models/task_model.dart";
import "package:schedule_resolver/models/schedule_analysis.dart";

class AiScheduleService extends ChangeNotifier {
  ScheduleAnalysis? currentAnalysis;
  bool isLoading = false;
  String? errorMessage;

  final String _apiKey = dotenv.env["API_KEY"]!;

  Future<void> analyzeSchedule(List<TaskModel> tasks) async {
    if (_apiKey.isEmpty || tasks.isEmpty) {
      return;
    }
    isLoading = true;
    errorMessage = null;

    try {
      final model = GenerativeModel(model: "gemini-2.5-flash", apiKey: _apiKey);
      final tasksJson = jsonEncode(tasks.map((t) => t.toJson()).toList());
      final prompt =
          '''
You are an expert student scheduling assistant. The user has provided the following tasks for their day in JSON format: $tasksJson

Jour job is to analyze these tasks, identify any overlaps or conflicts in their start and end time and suggest a better balanced schedule.
consider their urgency, importance, and required energy level.

Please provide exactly 4 sections(Heading 3) of markdown text:

1. ### Detected Conflicts
List any Scheduling conflicts
2. ### Ranked Tasks
Rank which tasks need attention first based on the urgency, importance and energy, Provide a brief reason on each.
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      currentAnalysis = _parseResponse(response.text ?? "");
    } catch (e) {
      errorMessage = "Failed: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  ScheduleAnalysis _parseResponse(String fullText) {
    String conflicts = "";
    String rankedTasks = "";
    String recommendedSchedule = "";
    String explanation = "";

    final sections = fullText.split("### ");

    for (var section in sections) {
      if (section.startsWith("Detected Conflicts")) {
        conflicts = section.replaceFirst("Detected Conflicts", "").trim();
      } else if (section.startsWith("Ranked Tasks")) {
        conflicts = section.replaceFirst("Ranked Tasks", "").trim();
      } else if (section.startsWith("Recommended Schedule")) {
        conflicts = section.replaceFirst("Recommended Schedule", "").trim();
      } else if (section.startsWith("Explanation")) {
        conflicts = section.replaceFirst("Explanation", "").trim();
      }
    }
    return ScheduleAnalysis(
      conflicts: conflicts,
      rankedTasks: rankedTasks,
      recommendedSchedule: recommendedSchedule,
      explanation: explanation,
    );
  }
}
