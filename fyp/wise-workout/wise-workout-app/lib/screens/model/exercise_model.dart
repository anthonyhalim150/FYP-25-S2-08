class Exercise {
  final String exerciseId;
  final String exerciseKey;
  final String exerciseName;
  final String exerciseDescription;
  final int exerciseSets;
  final int exerciseReps;
  final String exerciseInstructions;
  final String exerciseLevel;
  final String exerciseEquipment;
  final int? exerciseDuration;
  final String youtubeUrl;
  final int workoutId;

  /// ✅ Add this field
  final double? exerciseWeight;

  Exercise({
    required this.exerciseId,
    required this.exerciseKey,
    required this.exerciseName,
    required this.exerciseDescription,
    required this.exerciseSets,
    required this.exerciseReps,
    required this.exerciseInstructions,
    required this.exerciseLevel,
    required this.exerciseEquipment,
    this.exerciseDuration,
    required this.youtubeUrl,
    required this.workoutId,
    this.exerciseWeight, // ✅ Add this to the constructor
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      exerciseId: json['exerciseId'].toString(),
      exerciseKey: json['exerciseKey'],
      exerciseName: json['exerciseName'],
      exerciseDescription: json['exerciseDescription'],
      exerciseSets: int.tryParse(json['exerciseSets'].toString()) ?? 0,
      exerciseReps: int.tryParse(json['exerciseReps'].toString()) ?? 0,
      exerciseInstructions: json['exerciseInstructions'],
      exerciseLevel: json['exerciseLevel'],
      exerciseEquipment: json['exerciseEquipment'],
      exerciseDuration: json['exerciseDuration'] != null
          ? int.tryParse(json['exerciseDuration'].toString())
          : null,
      youtubeUrl: json['youtubeUrl'],
      workoutId: int.tryParse(json['workoutId'].toString()) ?? 0,
      exerciseWeight: json['exerciseWeight'] != null
          ? double.tryParse(json['exerciseWeight'].toString())
          : null,
    );
  }
}
