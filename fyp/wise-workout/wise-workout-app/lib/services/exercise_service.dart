import '../screens/model/exercise_model.dart';

class ExerciseService {
  Future<List<Exercise>> fetchExercisesByKey(String exerciseKey) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data for testing with YouTube URLs added
    return [
      Exercise(
        exerciseId: 'EX01',
        exerciseKey: exerciseKey,
        exerciseName: 'Push Up',
        exerciseDescription: 'A basic bodyweight pushing exercise.',
        exerciseSets: 3,
        exerciseReps: 12,
        exerciseInstructions: 'Keep your back straight,\n lower until chest nearly touches the floor,\n then push up.',
        exerciseLevel: 'Beginner',
        exerciseEquipment: 'None',
        exerciseDuration: null,
        youtubeUrl: 'https://www.youtube.com/watch?v=IODxDxX7oi4', // ✅ Push Up
      ),
      Exercise(
        exerciseId: 'EX02',
        exerciseKey: exerciseKey,
        exerciseName: 'Plank',
        exerciseDescription: 'A core stabilization exercise.',
        exerciseSets: 3,
        exerciseReps: 1,
        exerciseInstructions: 'Hold your body straight in a plank position.',
        exerciseLevel: 'Intermediate',
        exerciseEquipment: 'Mat',
        exerciseDuration: 45,
        youtubeUrl: 'https://www.youtube.com/watch?v=pSHjTRCQxIw', // ✅ Plank
      ),
      Exercise(
        exerciseId: 'EX03',
        exerciseKey: exerciseKey,
        exerciseName: 'Dumbbell Shoulder Press',
        exerciseDescription: 'Targets shoulders with dumbbells.',
        exerciseSets: 3,
        exerciseReps: 10,
        exerciseInstructions: 'Push dumbbells upward until arms are straight, then lower.',
        exerciseLevel: 'Advanced',
        exerciseEquipment: 'Dumbbells',
        exerciseDuration: null,
        youtubeUrl: 'https://www.youtube.com/watch?v=B-aVuyhvLHU', // ✅ Dumbbell Shoulder Press
      ),
    ];
  }
}
