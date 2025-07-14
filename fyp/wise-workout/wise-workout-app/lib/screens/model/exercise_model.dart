class Exercise {
  final String exerciseId;
  final String exerciseKey;
  final String exerciseName;
  final String exerciseDescription;
  final int exerciseSets;
  final int exerciseReps;
  final String exerciseInstructions;
  final String? exerciseLevel;
  final String? exerciseEquipment;
  final int? exerciseDuration; // in seconds
  final double? exerciseWeight;
  final String? youtubeUrl; // 🔥 NEW FIELD

  Exercise({
    required this.exerciseId,
    required this.exerciseKey,
    required this.exerciseName,
    required this.exerciseDescription,
    this.exerciseSets = 3,
    required this.exerciseReps,
    required this.exerciseInstructions,
    this.exerciseLevel,
    this.exerciseEquipment,
    this.exerciseDuration,
    this.exerciseWeight,
    this.youtubeUrl, // ✅ Add this to constructor
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      exerciseId: json['ExerciseId'] ?? '',
      exerciseKey: json['ExerciseKey'] ?? '',
      exerciseName: json['ExerciseName'] ?? '',
      exerciseDescription: json['ExerciseDescription'] ?? '',
      exerciseSets: json['ExerciseSets'] ?? 3,
      exerciseReps: json['ExerciseReps'] ?? 0,
      exerciseInstructions: json['ExerciseInstructions'] ?? '',
      exerciseLevel: json['ExerciseLevel'],
      exerciseEquipment: json['ExerciseEquipment'],
      exerciseDuration: json['ExerciseDuration'],
      exerciseWeight: (json['ExerciseWeight'] != null)
          ? json['ExerciseWeight'].toDouble()
          : null,
      youtubeUrl: json['YoutubeUrl'], // ✅ Read from Firestore
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ExerciseId': exerciseId,
      'ExerciseKey': exerciseKey,
      'ExerciseName': exerciseName,
      'ExerciseDescription': exerciseDescription,
      'ExerciseSets': exerciseSets,
      'ExerciseReps': exerciseReps,
      'ExerciseInstructions': exerciseInstructions,
      'ExerciseLevel': exerciseLevel,
      'ExerciseEquipment': exerciseEquipment,
      'ExerciseDuration': exerciseDuration,
      'ExerciseWeight': exerciseWeight,
      'YoutubeUrl': youtubeUrl, // ✅ Save to Firestore
    };
  }
}
