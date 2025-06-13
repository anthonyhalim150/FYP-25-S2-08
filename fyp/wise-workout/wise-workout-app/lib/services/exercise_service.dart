import 'dart:async';

// In workout_service.dart

class WorkoutService {
  Future<List<Exercise>> fetchExercises(int workoutID) async {
    await Future.delayed(Duration(milliseconds: 500));

    // Sample exercises with sets and reps
    return [
      Exercise(
        workoutId: 1,
        title: 'Push Up',
        description: 'A fundamental bodyweight exercise targeting chest, shoulders, and triceps',
        imageUrl: 'assets/exerciseImages/pushup_gif.jpg',
        sets: 3,
        reps: 15,
        instructions: '1. Start in a plank position\n2. Lower your body until chest nearly touches floor\n3. Push back up to starting position',
        level: 'Beginner',
        equipment: 'Bodyweight',
      ),
      Exercise(
        workoutId: 2,
        title: 'Dumbbell Bench Press',
        description: 'Compound exercise for chest development',
        imageUrl: 'assets/workoutImages/dumbbell_bench.jpg',
        sets: 3,
        reps: 12,
        instructions: '1. Lie on bench with dumbbells at chest level\n2. Press dumbbells upward until arms are extended\n3. Lower slowly to starting position',
        level: 'Intermediate',
        equipment: 'Dumbbells, Bench',
      ),
      Exercise(
        workoutId: 3,
        title: 'Bent Over Row',
        description: 'Back strengthening exercise targeting lats and rhomboids',
        imageUrl: 'assets/workoutImages/bent_over_row.jpg',
        sets: 3,
        reps: 15,
        instructions: '1. Bend at hips with slight knee bend\n2. Pull dumbbells toward lower chest\n3. Lower slowly with control',
        level: 'Intermediate',
        equipment: 'Dumbbells',
      ),
      Exercise(
        workoutId: 4,
        title: 'Shoulder Press',
        description: 'Develops shoulder strength and stability',
        imageUrl: 'assets/workoutImages/shoulder_press.jpg',
        sets: 3,
        reps: 10,
        instructions: '1. Sit with dumbbells at shoulder height\n2. Press upward until arms are extended\n3. Lower slowly back to shoulders',
        level: 'Intermediate',
        equipment: 'Dumbbells, Bench',
      ),
      Exercise(
        workoutId: 5,
        title: 'Bicep Curls',
        description: 'Isolates the biceps for arm development',
        imageUrl: 'assets/workoutImages/bicep_curl.jpg',
        sets: 3,
        reps: 15,
        instructions: '1. Stand with dumbbells at sides\n2. Curl weights toward shoulders\n3. Lower slowly with control',
        level: 'Beginner',
        equipment: 'Dumbbells',
      ),
      Exercise(
        workoutId: 6,
        title: 'Bicep Curls',
        description: 'Isolates the biceps for arm development',
        imageUrl: 'assets/workoutImages/bicep_curl.jpg',
        sets: 3,
        reps: 15,
        instructions: '1. Stand with dumbbells at sides\n2. Curl weights toward shoulders\n3. Lower slowly with control',
        level: 'Beginner',
        equipment: 'Dumbbells',
      ),
      Exercise(
        workoutId: 7,
        title: 'Bicep Curls',
        description: 'Isolates the biceps for arm development',
        imageUrl: 'assets/workoutImages/bicep_curl.jpg',
        sets: 3,
        reps: 15,
        instructions: '1. Stand with dumbbells at sides\n2. Curl weights toward shoulders\n3. Lower slowly with control',
        level: 'Beginner',
        equipment: 'Dumbbells',
      ),
      Exercise(
        workoutId: 8,
        title: 'Bicep Curls',
        description: 'Isolates the biceps for arm development',
        imageUrl: 'assets/workoutImages/bicep_curl.jpg',
        sets: 3,
        reps: 15,
        instructions: '1. Stand with dumbbells at sides\n2. Curl weights toward shoulders\n3. Lower slowly with control',
        level: 'Beginner',
        equipment: 'Dumbbells',
      ),
    ];
  }
}

// Update your Exercise model to include new fields
class Exercise {
  final int workoutId;
  final String title;
  final String description;
  final String imageUrl;
  final int sets;
  final int reps;
  final String instructions;
  final String level;
  final String equipment;

  Exercise({
    required this.workoutId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.sets,
    required this.reps,
    required this.instructions,
    required this.level,
    required this.equipment,
  });
}