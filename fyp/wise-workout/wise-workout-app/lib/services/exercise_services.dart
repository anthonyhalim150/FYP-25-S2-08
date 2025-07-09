import '../screens/model/exercise_model.dart';

class ExerciseService {
  Future<List<Exercise>> fetchExercisesByKey(String exerciseKey) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Dummy data for testing
    return [
      Exercise(
        exerciseId: 'EX01',
        exerciseKey: exerciseKey,
        exerciseName: 'Push Up',
        exerciseDescription: 'A basic bodyweight pushing exercise.',
        exerciseSets: 3,
        exerciseReps: 12,
        exerciseInstructions: 'Keep your back straight, lower until chest nearly touches the floor, then push up.',
        exerciseLevel: 'Beginner',
        exerciseEquipment: 'None',
        exerciseDuration: null,
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
      ),
    ];
  }
}
