import 'package:flutter/material.dart';

class EditWorkoutPlanPage extends StatefulWidget {
  final List<dynamic> savedPlan;
  const EditWorkoutPlanPage({Key? key, required this.savedPlan}) : super(key: key);

  @override
  _EditWorkoutPlanPageState createState() => _EditWorkoutPlanPageState();
}

class _EditWorkoutPlanPageState extends State<EditWorkoutPlanPage> {
  bool _isEditing = false;
  late List<dynamic> _plan;

  @override
  void initState() {
    super.initState();
    _plan = List.from(widget.savedPlan); // Initialize with the passed plan
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    // Logic to save the updated plan (send to backend, save locally, etc.)
    // Here you can implement the method to save the updated plan.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Changes saved successfully!")),
    );
    _toggleEditMode(); // Switch back to view mode
  }

  void _addExercise(int dayIndex) {
    final newExercise = {'name': 'New Exercise', 'sets': 3, 'reps': 12};  // Example new exercise
    setState(() {
      _plan[dayIndex]['exercises'].add(newExercise);
    });
  }

  void _removeExercise(int dayIndex, dynamic exercise) {
    setState(() {
      _plan[dayIndex]['exercises'].remove(exercise);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Workout Plan"),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing ? _saveChanges : _toggleEditMode,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _plan.length,
        itemBuilder: (context, idx) {
          final dayPlan = _plan[idx];
          final isRest = dayPlan['rest'] == true;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Day ${dayPlan['day_of_month'] ?? dayPlan['day_of_week']}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(height: 6),
                  if (isRest) ...[
                    Text(
                      "Rest Day",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 16),
                    ),
                    if (_isEditing) ...[
                      ElevatedButton(
                        onPressed: () => _addExercise(idx),
                        child: const Text("Add Exercise"),
                      ),
                    ],
                  ] else ...[
                    ...((dayPlan['exercises'] ?? []).map<Widget>((ex) {
                      return Row(
                        children: [
                          Expanded(child: Text('${ex['name']} | Sets: ${ex['sets']} | Reps: ${ex['reps']}')),
                          if (_isEditing) IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeExercise(idx, ex),
                          ),
                        ],
                      );
                    }).toList()),
                    if (_isEditing) ...[
                      ElevatedButton(
                        onPressed: () => _addExercise(idx),
                        child: const Text("Add Exercise"),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
