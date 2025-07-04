import '../screens/model/workout_model.dart'; // Your workout model

class WorkoutService {
  // Simulate fetching workouts from a database (for now using sample data)
  Future<List<Workout>> fetchWorkouts() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    return Workout.sampleWorkouts(); // Return the sample workouts data
  }

  // Filter workouts based on categoryKey
  Future<List<Workout>> fetchWorkoutsByCategory(String categoryKey) async {
    final workouts = await fetchWorkouts(); // Fetch all workouts first
    return workouts.where((workout) => workout.categoryKey == categoryKey).toList();
  }
}
