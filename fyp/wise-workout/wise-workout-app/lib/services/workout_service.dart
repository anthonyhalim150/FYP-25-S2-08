import 'dart:async';

// Model representing an exercise
class Workout {
  final int id;
  final String title;
  final String description;
  final String duration;
  final String imageUrl;

  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.imageUrl,
  });
}

// Service that fetches exercises for a given workoutID
class WorkoutService {
  // In a real app this would query your SQL database
  Future<List<Workout>> fetchExercises(int workoutID) async {
    // TODO: Replace with actual DB call
    await Future.delayed(Duration(milliseconds: 500));
    return List.generate(
      8,
          (i) => Workout(
        id: i,
        title: 'PowerWorks: Dumbbell Strength',
        description: 'Grab your dumbbells and get to work with this fast-paced, high-burn strength workout.',
        duration: '20',
        imageUrl: 'assets/workoutImages/strength_training.jpg',
      ),
    );
  }
}