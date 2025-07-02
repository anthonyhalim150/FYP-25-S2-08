// lib/screens/workout_analysis_page.dart
import 'package:flutter/material.dart';

class WorkoutAnalysisPage extends StatelessWidget {
  const WorkoutAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Duration duration = args['duration'];
    final int caloriesBurned = _calculateCalories(duration);

    return Scaffold(
      appBar: AppBar(title: const Text("Workout Summary")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Total Time: ${duration.inMinutes} min ${duration.inSeconds % 60} sec",
                style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            Text("Calories Burned: $caloriesBurned kcal", style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/workout-dashboard')),
              child: const Text("Back to Dashboard"),
            )
          ],
        ),
      ),
    );
  }

  int _calculateCalories(Duration duration) {
    const double met = 5.0; // Sample MET value
    const double weightKg = 70.0;
    final minutes = duration.inSeconds / 60.0;
    return (met * 3.5 * weightKg / 200 * minutes).round();
  }
}
