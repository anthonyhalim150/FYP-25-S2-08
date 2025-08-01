import 'exercise_model.dart'; // <-- adjust path to your Exercise model file

class WorkoutDay {
  final String dayOfWeek;
  final List<Exercise> exercises;
  final String notes;

  WorkoutDay({
    required this.dayOfWeek,
    required this.exercises,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'day_of_week': dayOfWeek,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'notes': notes,
  };

  factory WorkoutDay.fromJson(Map<String, dynamic> json) => WorkoutDay(
    dayOfWeek: json['day_of_week'],
    exercises: (json['exercises'] as List)
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList(),
    notes: json['notes'],
  );
}
