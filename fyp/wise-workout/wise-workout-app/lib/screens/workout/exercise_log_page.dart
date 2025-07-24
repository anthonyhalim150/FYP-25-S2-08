import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../model/exercise_model.dart';
import '../../services/workout_session_service.dart';
import '../../widgets/exercise_timer.dart';

class ExerciseLogPage extends StatefulWidget {
  final Exercise exercise;

  const ExerciseLogPage({super.key, required this.exercise});

  @override
  State<ExerciseLogPage> createState() => _ExerciseLogPageState();
}

class _ExerciseLogPageState extends State<ExerciseLogPage> {
  late List<Map<String, dynamic>> sets;
  final CountDownController _restTimerController = CountDownController();
  final WorkoutSessionService _session = WorkoutSessionService();

  @override
  void initState() {
    super.initState();
    final setsCount = widget.exercise.exerciseSets ?? 3;
    final defaultReps = widget.exercise.exerciseReps ?? 10;

    sets = List.generate(setsCount, (index) {

      return {
        'set': index + 1,
        'weight': 0.0,
        'reps': widget.exercise.exerciseReps,
        'finished': false,
      };
    });
  }

  void _addSet() {
    setState(() {
      sets.add({
        'set': sets.length + 1,
        'weight': 0.0,
        'reps': widget.exercise.exerciseReps ?? 10,
        'finished': false,
      });
    });
  }

  void _editValue(int index, String key, dynamic value) {
    setState(() {
      sets[index][key] = value;
    });
  }

  Future<String?> _showEditDialog(String initial, String label) async {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $label'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _markSetFinished(int index) {
    if (sets[index]['finished'] == true) return;

    setState(() {
      sets[index]['finished'] = true;
    });

    // Calculate simple calories: assume 5 per set + 0.2 per rep
    int reps = sets[index]['reps'];
    double calories = 5 + (reps * 0.2);

    _session.addExerciseLog(
      exercise: widget.exercise,
      calories: calories,
    );

    ExerciseTimer.showRestTimer(context, _restTimerController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F1),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 280,
                child: Image.asset(
                  'assets/exerciseGif/${widget.exercise.exerciseName.replaceAll(' ', '_').toLowerCase()}.gif',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.85),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Table Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(1.5),
              },
              children: const [
                TableRow(
                  children: [
                    Center(child: Text('Set', style: TextStyle(fontWeight: FontWeight.bold))),
                    Center(child: Text('Weight', style: TextStyle(fontWeight: FontWeight.bold))),
                    Center(child: Text('Reps', style: TextStyle(fontWeight: FontWeight.bold))),
                    Center(child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ],
            ),
          ),
          const Divider(thickness: 1.5, color: Colors.grey),

          // Table Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(1.5),
                },
                children: [
                  for (int index = 0; index < sets.length; index++)
                    TableRow(
                      children: [
                        Center(child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('Set ${sets[index]['set']}'),
                        )),
                        Center(child: GestureDetector(
                          onTap: () async {
                            final result = await _showEditDialog(sets[index]['weight'].toString(), 'Weight');
                            if (result != null) _editValue(index, 'weight', double.tryParse(result) ?? 0.0);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text('${sets[index]['weight']} kg',
                                style: const TextStyle(color: Colors.blue)),
                          ),
                        )),
                        Center(child: GestureDetector(
                          onTap: () async {
                            final result = await _showEditDialog(sets[index]['reps'].toString(), 'Reps');
                            if (result != null) _editValue(index, 'reps', int.tryParse(result) ?? 1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text('${sets[index]['reps']}',
                                style: const TextStyle(color: Colors.blue)),
                          ),
                        )),
                        Center(child: IgnorePointer(
                          ignoring: sets[index]['finished'] == true,
                          child: GestureDetector(
                          onTap: () => _markSetFinished(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Icon(
                              sets[index]['finished'] == true
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              color: sets[index]['finished'] == true ? Colors.green : Colors.grey,
                            ),
                          ),
                        )),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade900),
              onPressed: _addSet,
              child: const Text('+ Add Set'),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => ExerciseTimer.showRestTimer(context, _restTimerController),
              child: const Text('Rest Timer'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
