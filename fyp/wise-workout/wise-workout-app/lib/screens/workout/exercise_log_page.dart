import 'package:flutter/material.dart';
import '../model/exercise_model.dart';
import '../../widgets/rest_timer_dialog.dart';

class ExerciseLogPage extends StatefulWidget {
  final Exercise exercise;

  const ExerciseLogPage({super.key, required this.exercise});

  @override
  State<ExerciseLogPage> createState() => _ExerciseLogPageState();
}

class _ExerciseLogPageState extends State<ExerciseLogPage> {
  late List<Map<String, dynamic>> sets;

  @override
  void initState() {
    super.initState();
    sets = List.generate(widget.exercise.exerciseSets, (index) {
      return {
        'set': index + 1,
        'weight': widget.exercise.exerciseWeight ?? 0.0,
        'reps': widget.exercise.exerciseReps,
        'finished': false,
      };
    });
  }

  void _addSet() {
    setState(() {
      sets.add({
        'set': sets.length + 1,
        'weight': widget.exercise.exerciseWeight ?? 0.0,
        'reps': widget.exercise.exerciseReps,
        'finished': false,
      });
    });
  }

  void _editValue(int index, String key, dynamic value) {
    setState(() {
      sets[index][key] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F1),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 280,
            child: Image.asset(
              'assets/exerciseGif/push_up.gif',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(child: Text('Set', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Weight', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Reps', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(child: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                const Divider(thickness: 1.5, color: Colors.grey),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              itemCount: sets.length,
              itemBuilder: (context, index) {
                final set = sets[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('Set ${set['set']}')),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final result = await _showEditDialog(set['weight'].toString(), 'Weight');
                            if (result != null) _editValue(index, 'weight', double.tryParse(result) ?? 0.0);
                          },
                          child: Text('${set['weight']} kg', style: const TextStyle(color: Colors.blue)),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final result = await _showEditDialog(set['reps'].toString(), 'Reps');
                            if (result != null) _editValue(index, 'reps', int.tryParse(result) ?? 1);
                          },
                          child: Text('${set['reps']}', style: const TextStyle(color: Colors.blue)),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (set['finished'] != true) {
                              setState(() => sets[index]['finished'] = true);
                              showRestTimerDialog(context);
                            }
                          },
                          child: Icon(
                            set['finished'] == true
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: set['finished'] == true ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
              onPressed: () => showRestTimerDialog(context),
              child: const Text('Rest Timer'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
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
}
