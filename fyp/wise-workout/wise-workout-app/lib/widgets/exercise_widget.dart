import 'package:flutter/material.dart';

class ExerciseWidget extends StatelessWidget {
  final int dayOfMonth;
  final List<dynamic> exercises;
  final String notes;

  ExerciseWidget({
    required this.dayOfMonth,
    required this.exercises,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day $dayOfMonth',
              style: Theme.of(context).textTheme.titleLarge,  // Updated style here
            ),
            SizedBox(height: 8.0),
            Text(
              'Notes: $notes',
              style: TextStyle(color: Colors.grey),
            ),
            Divider(),
            ...exercises.map((exercise) {
              return ListTile(
                title: Text(exercise['name']),
                subtitle: Text('Sets: ${exercise['sets']}, Reps: ${exercise['reps']}'),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
