class Exercise {
  final int exerciseId;  // Integer ID for Exercise
  final String exerciseName;
  final String exerciseDescription;
  final int exerciseSets;
  final int exerciseReps;
  final String exerciseInstructions;
  final String? exerciseLevel;
  final String? exerciseEquipment;
  final int? exerciseDuration;  // Duration in seconds
  final double? exerciseWeight;  // Weight in kg (optional)
  final String? youtubeUrl;  // Optional YouTube link for exercise tutorial
  final int workoutId;  // Foreign Key linking the exercise to a workout

  Exercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.exerciseDescription,
    this.exerciseSets = 3,
    required this.exerciseReps,
    required this.exerciseInstructions,
    this.exerciseLevel,
    this.exerciseEquipment,
    this.exerciseDuration,
    this.exerciseWeight,
    this.youtubeUrl,
    required this.workoutId,  // Foreign Key linking to the workout
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      exerciseId: json['exercise_id'] ?? 0,
      exerciseName: json['exercise_name'] ?? '',
      exerciseDescription: json['exercise_description'] ?? '',
      exerciseSets: json['exercise_sets'] ?? 3,
      exerciseReps: json['exercise_reps'] ?? 0,
      exerciseInstructions: json['exercise_instructions'] ?? '',
      exerciseLevel: json['exercise_level'],
      exerciseEquipment: json['exercise_equipment'],
      exerciseDuration: json['exercise_duration'],
      exerciseWeight: json['exercise_weight'] != null
          ? json['exercise_weight'].toDouble()
          : null,
      youtubeUrl: json['youtube_url'],
      workoutId: json['workout_id'] ?? 0,  // Foreign Key reference to workout
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exercise_id': exerciseId,
      'exercise_name': exerciseName,
      'exercise_description': exerciseDescription,
      'exercise_sets': exerciseSets,
      'exercise_reps': exerciseReps,
      'exercise_instructions': exerciseInstructions,
      'exercise_level': exerciseLevel,
      'exercise_equipment': exerciseEquipment,
      'exercise_duration': exerciseDuration,
      'exercise_weight': exerciseWeight,
      'youtube_url': youtubeUrl,
      'workout_id': workoutId,  // Linking this exercise to the workout
    };
  }
}
