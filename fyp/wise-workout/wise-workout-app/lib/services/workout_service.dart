import 'dart:async';

// Model representing an exercise
class Workout {
  final int workoutId;
  final String title;
  final String category;
  final String description;
  final String duration;
  final String level;

  Workout({
    required this.category,
    required this.workoutId,
    required this.title,
    required this.description,
    required this.duration,
    required this.level,
  });
}

// Service that fetches exercises for a given workoutID
class WorkoutService {
  // In a real app this would query your SQL database
  Future<List<Workout>> fetchExercises(int workoutID) async {
    await Future.delayed(Duration(milliseconds: 500));

    return [
      // Strength workouts
      Workout(
        workoutId: 1,
        title: 'Dumbbell Strength',
        category: 'strength',
        description: 'Grab your dumbbells and get to work with this fast-paced, high-burn strength workout.',
        duration: '20',
        level: 'Beginner',
      ),
      Workout(
        workoutId: 2,
        title: 'Upper Body Blast',
        category: 'strength',
        description: 'Focus on your chest, shoulders, and triceps using compound dumbbell movements.',
        duration: '25',
        level: 'Intermediate',
      ),
      Workout(
        workoutId: 3,
        title: 'Leg Day Power Burn',
        category: 'strength',
        description: 'Ignite your lower body with squats, lunges, and glute bridges in this power-packed workout.',
        duration: '30',
        level: 'Advanced',
      ),
      Workout(
        workoutId: 4,
        title: 'Total Body Core Circuit',
        category: 'strength',
        description: 'Strengthen your entire body and core with this functional circuit training routine.',
        duration: '22',
        level: 'Beginner',
      ),

      // Yoga workouts
      Workout(
        workoutId: 5,
        title: 'Morning Flow Yoga',
        category: 'yoga',
        description: 'Start your day with a gentle yoga flow to wake up your body and mind.',
        duration: '15',
        level: 'Beginner',
      ),
      Workout(
        workoutId: 6,
        title: 'Power Vinyasa',
        category: 'yoga',
        description: 'Build strength and flexibility with this dynamic vinyasa flow sequence.',
        duration: '30',
        level: 'Intermediate',
      ),
      Workout(
        workoutId: 7,
        title: 'Evening Wind Down Yoga',
        category: 'yoga',
        description: 'Relax and stretch your body in preparation for a good night’s sleep.',
        duration: '20',
        level: 'Beginner',
      ),
    ];
  }

}