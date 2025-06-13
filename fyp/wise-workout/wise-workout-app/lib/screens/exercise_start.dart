import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:wise_workout_app/services/exercise_service.dart';
import '../widgets/bottom_navigation.dart';

class ExerciseStartScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseStartScreen({Key? key, required this.exercise}) : super(key: key);

  @override
  _ExerciseStartScreenState createState() => _ExerciseStartScreenState();
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
  List<WorkoutSet> completedSets = [];
  WorkoutSet currentSet = WorkoutSet(weight: 0, reps: 0);
  final CountDownController _timerController = CountDownController();

  @override
  void initState() {
    super.initState();
    currentExercise = widget.exercise;
    currentSet = WorkoutSet(
      weight: currentExercise.suggestedWeight,
      reps: currentExercise.suggestedReps,
    );
  }

  void _showFullScreenImage() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black87,
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.asset(
                'assets/pushup_gif.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showRestTimer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rest Timer", textAlign: TextAlign.center),
        content: CircularCountDownTimer(
          duration: 60,
          initialDuration: 0,
          controller: _timerController,
          width: 120,
          height: 120,
          ringColor: Colors.grey[300]!,
          fillColor: Colors.blue[500]!,
          backgroundColor: Colors.white,
          strokeWidth: 10.0,
          strokeCap: StrokeCap.round,
          isTimerTextShown: true,
          isReverse: true,
          textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          onComplete: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => _timerController.pause(),
            child: const Text("Pause"),
          ),
          TextButton(
            onPressed: () => _timerController.resume(),
            child: const Text("Resume"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showEditWeightDialog(WorkoutSet set, int index, {bool isCurrent = false}) {
    TextEditingController controller = TextEditingController(
      text: set.weight.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Weight"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Weight (kgs)",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newWeight = int.tryParse(controller.text);
              if (newWeight != null && newWeight > 0) {
                setState(() {
                  if (isCurrent) {
                    currentSet.weight = newWeight;
                  } else {
                    completedSets[index].weight = newWeight;
                  }
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showEditRepsDialog(WorkoutSet set, int index, {bool isCurrent = false}) {
    TextEditingController controller = TextEditingController(
      text: set.reps.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Reps"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Repetitions",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final newReps = int.tryParse(controller.text);
              if (newReps != null && newReps > 0) {
                setState(() {
                  if (isCurrent) {
                    currentSet.reps = newReps;
                  } else {
                    completedSets[index].reps = newReps;
                  }
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildSetRow(WorkoutSet set, int index, {bool isCurrent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 40,
            child: set.isCompleted
                ? const Icon(Icons.check, color: Colors.green)
                : Text(
              isCurrent ? "+" : "${index + 1}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCurrent ? Colors.blue : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 80,
            child: InkWell(
              onTap: () => _showEditWeightDialog(set, index, isCurrent: isCurrent),
              child: Text(
                "${set.weight.toStringAsFixed(1)} ${set.unit}",
                style: TextStyle(
                  fontSize: 18,
                  color: isCurrent ? Colors.blue : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: InkWell(
              onTap: () => _showEditRepsDialog(set, index, isCurrent: isCurrent),
              child: Text(
                "${set.reps} reps",
                style: TextStyle(
                  fontSize: 18,
                  color: isCurrent ? Colors.blue : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (isCurrent)
            SizedBox(
              width: 80,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    // Mark as completed and add to completed sets
                    currentSet.isCompleted = true;
                    completedSets.add(currentSet);

                    // Create new current set with previous weight
                    currentSet = WorkoutSet(
                      weight: currentSet.weight,
                      reps: currentExercise.suggestedReps,
                    );

                    // Show rest timer
                    _showRestTimer();
                  });
                },
                child: const Text(
                  "Finish Set",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            )
          else
            SizedBox(
              width: 80,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    completedSets.removeAt(index);
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
      appBar: AppBar(
        title: Text(currentExercise.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Large exercise image with tap to expand
          GestureDetector(
            onTap: _showFullScreenImage,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Image.asset(
                'assets/pushup_gif.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Header row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Set", style: TextStyle(fontWeight: FontWeight.bold)),
                const Text("Weight", style: TextStyle(fontWeight: FontWeight.bold)),
                const Text("Reps", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 80), // Space for action button
              ],
            ),
          ),
          const Divider(thickness: 1.5, indent: 20, endIndent: 20),
          // Completed sets
          ...List.generate(
            completedSets.length,
                (index) => _buildSetRow(completedSets[index], index),
          ),
          // Current set
          _buildSetRow(
            currentSet,
            completedSets.length,
            isCurrent: true,
          ),
          const Spacer(),
          // Rest Timer Button
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.timer),
              label: const Text("Rest Timer"),
              onPressed: _showRestTimer,
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