import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ai_schedule_service.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final aiService = Provider.of<AiScheduleService>(context);
    final analysis = aiService.currentAnalysis;

    if (analysis == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          title: const Text(
            'AI Schedule Recommendation',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF2C3E50),
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'No Data Available',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Clean, light grey background
      appBar: AppBar(
        title: const Text(
          'AI Schedule Recommendation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2C3E50), // Matches Dashboard AppBar
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // White back button
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Passing Accent Colors instead of full background colors
            _buildSection(
              context,
              'Detected Conflicts',
              analysis.conflicts,
              const Color(0xFFD32F2F),
              Icons.warning_amber_rounded,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              'Ranked Tasks',
              analysis.rankedTasks,
              const Color(0xFF1976D2),
              Icons.format_list_numbered,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              'Recommended Schedule',
              analysis.recommendedSchedule,
              const Color(0xFF388E3C),
              Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              'Explanation',
              analysis.explanation,
              const Color(0xFFF57C00),
              Icons.lightbulb_outline,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Refactored to use white cards with colored accents
  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    Color accentColor,
    IconData icon,
  ) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: accentColor.withOpacity(0.3),
          width: 1,
        ), // Subtle tinted border
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon placed inside a subtly colored box for a modern look
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 24, color: accentColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50), // Dark text for headings
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 12),
            Text(
              content.isEmpty ? "No information provided." : content,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF424242),
                // Slightly lighter text for readability
                height: 1.5, // Better line spacing for paragraph text
              ),
            ),
          ],
        ),
      ),
    );
  }
}
