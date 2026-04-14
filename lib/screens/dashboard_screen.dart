import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_resolver/screens/task_input_screen.dart';
import '../providers/schedule_provider.dart';
import '../services/ai_schedule_service.dart';
import '../models/task_model.dart';
import 'recommendation_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final aiService = Provider.of<AiScheduleService>(context);

    final sortedTask = List<TaskModel>.from(scheduleProvider.tasks);
    sortedTask.sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Resolver'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            if (aiService.currentAnalysis != null)
              Card(
                color: Colors.red.shade100,
                child: Column(
                  children: [
                    const Text(
                      'Recommendation Ready!!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecommendationScreen(),
                        ),
                      ),
                      child: const Text('View Recommendation'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: sortedTask.isEmpty
                  ? const Center(child: Text('no task added yet!'))
                  : ListView.builder(
                      itemCount: sortedTask.length,
                      itemBuilder: (context, index) {
                        final task = sortedTask[index];
                        return Card(
                          child: ListTile(
                            title: Text(task.title),
                            subtitle: Text(
                              "${task.category} | ${task.startTime.hour}: ${task.startTime.minute}",
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                              onPressed: () =>
                                  scheduleProvider.removeTask(task.id),
                            ), // IconButton
                          ),
                        );
                      },
                    ),
            ),

            if (sortedTask.isNotEmpty)
              ElevatedButton(
                onPressed: aiService.isLoading
                    ? null
                    : () => aiService.analyzeSchedule(scheduleProvider.tasks),
                child: aiService.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Resolved Conflicts With AI'),
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TaskInputScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
