import 'exercise_model.dart';

class WorkoutDay {
  final int dayOfMonth; // e.g. 1-30
  final List<Exercise> exercises;
  final String notes;
  final bool isRest; // optional: to support rest days

  WorkoutDay({
    required this.dayOfMonth,
    required this.exercises,
    required this.notes,
    this.isRest = false,
  });

  Map<String, dynamic> toJson() => {
    'day_of_month': dayOfMonth,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'notes': notes,
    'rest': isRest,
  };

  factory WorkoutDay.fromJson(Map<String, dynamic> json) => WorkoutDay(
    dayOfMonth: json['day_of_month'],
    exercises: (json['exercises'] as List? ?? [])
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList(),
    notes: json['notes'] ?? '',
    isRest: json['rest'] ?? false,
  );

  // If you're also parsing AI JSON directly:
  factory WorkoutDay.fromAiJson(Map<String, dynamic> json) => WorkoutDay(
    dayOfMonth: json['day_of_month'],
    exercises: (json['exercises'] as List? ?? [])
        .map((e) => Exercise.fromAiJson(e as Map<String, dynamic>))
        .toList(),
    notes: json['notes'] ?? '',
    isRest: json['rest'] ?? false,
  );
}
