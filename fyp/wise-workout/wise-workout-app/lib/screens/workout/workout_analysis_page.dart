import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/exercise_model.dart';
import '../../services/workout_session_service.dart';

class WorkoutAnalysisPage extends StatelessWidget {
  const WorkoutAnalysisPage({super.key});

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes;
    return "$minutes min";
  }

  String _formattedDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final session = WorkoutSessionService();
    final workoutName = session.workoutName ?? "My Workout";
    final duration = session.elapsed;
    final logs = session.loggedExercises;

    // Calculations
    final totalCalories = logs.fold<double>(0.0, (sum, log) => (sum ?? 0.0) + (log.calories ?? 0.0));
    final totalSets = logs.length;
    final totalReps = logs.map((log) => log.exercise.exerciseReps ?? 0).toList();
    final maxWeight = logs.map((log) => log.exercise.exerciseWeight ?? 0.0).fold<double>(0.0, (a, b) => a > b ? a : b);
    final caloriesPerMin = duration.inMinutes > 0 ? (totalCalories / duration.inMinutes) : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text("Workout Analysis", style: TextStyle(color: Colors.black)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.purpleAccent,
                    radius: 28,
                    child: Icon(Icons.fitness_center, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workoutName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(_formattedDate(), style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),

              /// Summary Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _summaryCard(Icons.timer_outlined, _formatDuration(duration), "Duration"),
                  _summaryCard(Icons.local_fire_department, "${totalCalories.toStringAsFixed(0)} kcal", "Calories"),
                  _summaryCard(Icons.trending_up, "Advanced", "Intensity"),
                ],
              ),

              const SizedBox(height: 24),

              /// Stats
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Detailed Stats", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              _buildStatRow("Average Heart Rate", "123 bpm"),
              _buildStatRow("Peak Heart Rate", "143 bpm"),
              _buildStatRow("Steps", "1,245"), // Replace with real data if available
              _buildStatRow("Sets", totalSets.toString()),
              _buildStatRow("Reps", totalReps.join(', ')),
              _buildStatRow("Max Weight", "${maxWeight.toStringAsFixed(0)} kg"),
              _buildStatRow("Calories per min", caloriesPerMin.toStringAsFixed(1)),

              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Session Notes", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Felt strong! Increased weight 😎", style: TextStyle(fontStyle: FontStyle.italic)),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[900],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    // Implement share/export/report logic here
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("Share"),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: Colors.orange),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
        ],
      ),
    );
  }
}
