import 'package:flutter/material.dart';

class WorkoutAnalysisPage extends StatelessWidget {
  const WorkoutAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final duration = args['duration'] as Duration;
    final calories = args['calories'] as double;
    final workoutName = args['workoutName'] as String;

    return Scaffold(
      appBar: AppBar(title: const Text("Workout Summary")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Workout: $workoutName", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text("Duration: ${duration.inMinutes} minutes", style: const TextStyle(fontSize: 16)),
            Text("Calories burned: ${calories.toStringAsFixed(1)} cal", style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Finish"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
