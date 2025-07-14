import 'package:flutter/material.dart';
import '../model/exercise_model.dart';
import '../model/workout_model.dart';

class WorkoutAnalysisPage extends StatefulWidget {
  const WorkoutAnalysisPage({super.key});

  @override
  State<WorkoutAnalysisPage> createState() => _WorkoutAnalysisPageState();
}

class _WorkoutAnalysisPageState extends State<WorkoutAnalysisPage>
    with SingleTickerProviderStateMixin {
  double _opacity = 0;
  double _scale = 0.8;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        _opacity = 1;
        _scale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Workout workout = args['workout'] as Workout;
    final List<Exercise> exercises = args['exercises'] as List<Exercise>;
    final Duration duration = args['duration'] as Duration;
    final double calories = args['calories'] as double;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Centered Animated Title
              Center(
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 600),
                  child: AnimatedScale(
                    scale: _scale,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutBack,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.emoji_events, color: Colors.amber, size: 30),
                        SizedBox(width: 8),
                        Text(
                          "Workout Summary",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const SizedBox(height: 16),

              /// Workout Name
              Text(
                workout.workoutName,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              /// Level & Description
              const SizedBox(height: 8),
              Text("Level: ${workout.workoutLevel}", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text(workout.workoutDescription, style: const TextStyle(fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 20),

              /// Duration & Calories
              Row(
                children: [
                  const Icon(Icons.timer, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text("Duration: ${duration.inMinutes} min", style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.redAccent),
                  const SizedBox(width: 8),
                  Text("Calories burned: ${calories.toStringAsFixed(1)} cal", style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 24),

              const Divider(thickness: 1.2),
              const SizedBox(height: 12),

              const Text(
                "Exercises Performed",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const SizedBox(height: 12),

              /// Exercise List
              Expanded(
                child: ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final ex = exercises[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ex.exerciseName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.repeat, size: 18, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text("Sets: ${ex.exerciseSets}, Reps: ${ex.exerciseReps}"),
                              ],
                            ),
                            if (ex.exerciseDuration != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 18, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text("Duration: ${ex.exerciseDuration!} sec"),
                                ],
                              ),
                            ],
                            if (ex.exerciseWeight != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.fitness_center, size: 18, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text("Weight used: ${ex.exerciseWeight} kg"),
                                ],
                              ),
                            ],
                            if (ex.exerciseEquipment != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.build, size: 18, color: Colors.grey),
                                  const SizedBox(width: 6),
                                  Text("Equipment: ${ex.exerciseEquipment}"),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.done),
                  label: const Text("Finish Workout"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    backgroundColor: Colors.amber, // 🔥 Yellow-amber color
                    foregroundColor: Colors.black, // Optional: black text/icon for contrast
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
