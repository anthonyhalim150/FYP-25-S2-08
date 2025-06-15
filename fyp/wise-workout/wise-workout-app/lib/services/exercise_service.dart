import 'dart:async';

// In workout_service.dart

class WorkoutService {
  Future<List<Exercise>> fetchExercises(int workoutID) async {
    await Future.delayed(Duration(milliseconds: 500));

    final allExercises = [
      // 🏋️ Dumbbell Strength (Workout ID = 1)
      Exercise(
        exerciseId: 1,
        workoutId: 1,
        title: 'Push Up',
        description: 'Targets chest, shoulders, and triceps.',
        sets: 3,
        suggestedReps: 15,
        suggestedWeight: 0,
        instructions: 'Start in plank, lower body, push back up.',
        level: 'Beginner',
        equipment: 'Bodyweight',
      ),
      Exercise(
        exerciseId: 2,
        workoutId: 1,
        title: 'Dumbbell Bench Press',
        description: 'Chest press with dumbbells.',
        sets: 3,
        suggestedReps: 12,
        suggestedWeight: 10,
        instructions: 'Lie on bench, press dumbbells up and down.',
        level: 'Intermediate',
        equipment: 'Dumbbells, Bench',
      ),
      Exercise(
        exerciseId: 3,
        workoutId: 1,
        title: 'Bent Over Row',
        description: 'Strengthens back.',
        sets: 3,
        suggestedReps: 15,
        suggestedWeight: 10,
        instructions: 'Hinge hips, pull dumbbells to torso.',
        level: 'Intermediate',
        equipment: 'Dumbbells',
      ),
      Exercise(
        exerciseId: 4,
        workoutId: 1,
        title: 'Shoulder Press',
        description: 'Develops shoulder strength.',
        sets: 3,
        suggestedReps: 10,
        suggestedWeight: 10,
        instructions: 'Press dumbbells overhead, return slowly.',
        level: 'Intermediate',
        equipment: 'Dumbbells',
      ),
      Exercise(
        exerciseId: 5,
        workoutId: 1,
        title: 'Bicep Curls',
        description: 'Bicep isolation.',
        sets: 3,
        suggestedReps: 15,
        suggestedWeight: 10,
        instructions: 'Curl and lower dumbbells with control.',
        level: 'Beginner',
        equipment: 'Dumbbells',
      ),

      // 🧘 Yoga (Workout ID = 2)
      Exercise(
        exerciseId: 6,
        workoutId: 2,
        title: 'Child’s Pose',
        description: 'Resting yoga pose to stretch hips and back.',
        sets: 1,
        suggestedReps: 1,
        suggestedWeight: 0,
        instructions: 'Sit back on heels, reach arms forward.',
        level: 'Beginner',
        equipment: 'Mat',
      ),
      Exercise(
        exerciseId: 7,
        workoutId: 2,
        title: 'Downward Dog',
        description: 'Stretch hamstrings and spine.',
        sets: 1,
        suggestedReps: 1,
        suggestedWeight: 0,
        instructions: 'Hips up, heels down, arms extended.',
        level: 'Beginner',
        equipment: 'Mat',
      ),
      Exercise(
        exerciseId: 8,
        workoutId: 2,
        title: 'Cobra Pose',
        description: 'Stretches chest and strengthens spine.',
        sets: 1,
        suggestedReps: 1,
        suggestedWeight: 0,
        instructions: 'Lie on stomach, lift chest up with arms.',
        level: 'Beginner',
        equipment: 'Mat',
      ),
    ];

    // Return only the exercises that match the workoutId
    return allExercises.where((e) => e.workoutId == workoutID).toList();
  }

}


// Update your Exercise model to include new fields
class Exercise {
  final int exerciseId;
  final int workoutId; // ← link to the Workout
  final String title;
  final String description;
  final int sets;
  final int suggestedReps;
  final int suggestedWeight;
  final String instructions;
  final String level;
  final String equipment;

  Exercise({
    required this.exerciseId,
    required this.workoutId,
    required this.title,
    required this.description,
    required this.sets,
    required this.suggestedWeight,
    required this.suggestedReps,
    required this.instructions,
    required this.level,
    required this.equipment,
  });
}
