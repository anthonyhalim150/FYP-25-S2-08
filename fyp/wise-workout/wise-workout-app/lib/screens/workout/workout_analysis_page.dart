
import 'package:flutter/material.dart';
import '../model/exercise_model.dart';
import '../model/workout_model.dart';

class WorkoutAnalysisPage extends StatefulWidget {
  const WorkoutAnalysisPage({super.key});

  @override
  State<WorkoutAnalysisPage> createState() => _WorkoutAnalysisPageState();
}

class _WorkoutAnalysisPageState extends State<WorkoutAnalysisPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Workout workout = args['workout'] as Workout;
    final List<Exercise> exercises = args['exercises'] as List<Exercise>;
    final Duration duration = args['duration'] as Duration;
    final double calories = args['calories'] as double;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F2),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'Workout Summary: ${workout.workoutName}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text('Duration: ${duration.inMinutes} minutes'),
                        Text('Calories burned: ${calories.toStringAsFixed(2)}'),
                        const SizedBox(height: 24),
                        ...exercises.map((exercise) {
                          return Card(
                            child: ListTile(
                              title: Text(exercise.exerciseName),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Reps: ${exercise.exerciseReps}'),
                                  Text('Sets: ${exercise.exerciseSets}'),
                                  if (exercise.exerciseEquipment.isNotEmpty)
                                    Text('Equipment: ${exercise.exerciseEquipment}'),
                                  Text('Level: ${exercise.exerciseLevel}'),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
