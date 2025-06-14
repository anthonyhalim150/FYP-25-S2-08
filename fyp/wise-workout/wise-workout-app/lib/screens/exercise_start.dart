// lib/screens/exercise_start_screen.dart
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:wise_workout_app/services/exercise_service.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/exercise_timer.dart';
import '../services/exercise_edit_controller.dart';

class ExerciseStartScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseStartScreen({Key? key, required this.exercise}) : super(key: key);

  @override
  _ExerciseStartScreenState createState() => _ExerciseStartScreenState();
}

String _getExerciseImagePath(String exerciseTitle) {
  // Convert to lowercase and replace spaces with underscores
  final formattedName = exerciseTitle.toLowerCase().replaceAll(' ', '_');
  return 'assets/exerciseImages/${formattedName}_gif.jpg';
}

class WorkoutSet {
  int weight;
  int reps;
  final String unit;
  bool isCompleted;

  WorkoutSet({
    required this.weight,
    required this.reps,
    this.unit = 'kgs',
    this.isCompleted = false,
  });
}

class _ExerciseStartScreenState extends State<ExerciseStartScreen> {
  late Exercise currentExercise;
  List<WorkoutSet> sets = [];
  final CountDownController _timerController = CountDownController();

  @override
  void initState() {
    super.initState();
    currentExercise = widget.exercise;

    // Initialize with the number of sets from exercise object
    sets = List.generate(currentExercise.sets, (index) => WorkoutSet(
      weight: currentExercise.suggestedWeight,
      reps: currentExercise.suggestedReps,
    ));
  }

  void _showFullScreenImage() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Color(0x688EA3),
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color(0xFF688EA3),
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.asset(
                _getExerciseImagePath(currentExercise.title),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSetRow(WorkoutSet set, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Set number
          SizedBox(
            width: 40,
            child: set.isCompleted
                ? const Icon(Icons.check, color: Colors.green)
                : Text(
              "${index + 1}",
              style: TextStyle(
                fontSize: 18,
                color: set.isCompleted ? Colors.grey : Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Weight
          SizedBox(
            width: 80,
            child: InkWell(
              onTap: () => ExerciseEditController.showEditWeightDialog(
                context,
                set.weight.toString(),
                    (newValue) {
                  final newWeight = int.tryParse(newValue);
                  if (newWeight != null && newWeight > 0) {
                    setState(() {
                      set.weight = newWeight;
                    });
                  }
                },
              ),
              child: Text(
                "${set.weight.toStringAsFixed(1)} ${set.unit}",
                style: TextStyle(
                  fontSize: 18,
                  color: set.isCompleted ? Colors.grey : Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Reps
          SizedBox(
            width: 80,
            child: InkWell(
              onTap: () => ExerciseEditController.showEditRepsDialog(
                context,
                set.reps.toString(),
                    (newValue) {
                  final newReps = int.tryParse(newValue);
                  if (newReps != null && newReps > 0) {
                    setState(() {
                      set.reps = newReps;
                    });
                  }
                },
              ),
              child: Text(
                "${set.reps} reps",
                style: TextStyle(
                  fontSize: 18,
                  color: set.isCompleted ? Colors.grey : Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Action button
          SizedBox(
            width: 80,
            child: !set.isCompleted
                ? TextButton(
              onPressed: () {
                setState(() {
                  set.isCompleted = true;
                  ExerciseTimer.showRestTimer(context, _timerController);
                });
              },
              child: const Text(
                "Finish Set",
                style: TextStyle(color: Colors.green),
              ),
            )
                : IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  sets.removeAt(index);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0), // Adjust top padding as needed
            child: Center(
              child: Text(
                currentExercise.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // You can change this if needed
                ),
              ),
            ),
          ),
          // Large exercise image with tap to expand
          GestureDetector(
            onTap: _showFullScreenImage,
            child: Container(
              height: 200,
              width: 380,
              decoration: BoxDecoration(
                color: Color(0xFF688EA3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Image.asset(
                _getExerciseImagePath(currentExercise.title),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Table header with new column names
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                SizedBox(width: 40, child: Text("Set", style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 80, child: Text("Weight", style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 80, child: Text("Reps", style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(width: 80, child: Text("Action", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          const Divider(thickness: 1.5, indent: 20, endIndent: 20),
          // Display all sets from exercise object
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(
                    sets.length,
                        (index) => _buildSetRow(sets[index], index),
                  ),
                  // Add Set button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("Add Set"),
                      onPressed: () {
                        setState(() {
                          final lastWeight = sets.isNotEmpty
                              ? sets.last.weight
                              : currentExercise.suggestedWeight;
                          sets.add(WorkoutSet(
                            weight: lastWeight,
                            reps: currentExercise.suggestedReps,
                          ));
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Rest Timer Button
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.timer),
              label: const Text("Rest Timer"),
              onPressed: () => ExerciseTimer.showRestTimer(context, _timerController),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.blue[700],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(
        currentIndex: 2, // Assuming workout dashboard is index 2
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/leaderboard');
              break;
            case 2:
              Navigator.pushNamed(context, '/workout-dashboard');
              break;
            case 3:
              Navigator.pushNamed(context, '/messages');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}