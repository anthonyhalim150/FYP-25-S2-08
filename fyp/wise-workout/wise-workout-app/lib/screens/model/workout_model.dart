class Workout {
  final String workoutId;
  final String categoryKey;
  final String exerciseKey;
  final String workoutName;
  final String workoutLevel;
  final String workoutDescription;

  Workout({
    required this.workoutId,
    required this.categoryKey,
    required this.exerciseKey,
    required this.workoutName,
    required this.workoutLevel,
    required this.workoutDescription,
  });

  static List<Workout> sampleWorkouts() {
    return [
      // PUSH
      Workout(
        workoutId: '1',
        categoryKey: 'push',
        exerciseKey: 'pushexercises_1',
        workoutName: 'Chest Builder',
        workoutLevel: 'Intermediate',
        workoutDescription: 'Focus on upper body pushing strength with this chest-centric workout.',
      ),
      Workout(
        workoutId: '2',
        categoryKey: 'push',
        exerciseKey: 'pushexercises_2',
        workoutName: 'Triceps Shred',
        workoutLevel: 'Advanced',
        workoutDescription: 'Blast your triceps with explosive push movements and dips.',
      ),
      Workout(
        workoutId: '3',
        categoryKey: 'push',
        exerciseKey: 'pushexercises_3',
        workoutName: 'Upper Body Power',
        workoutLevel: 'Beginner',
        workoutDescription: 'A beginner-friendly push workout to build foundational strength.',
      ),

      // CARDIO
      Workout(
        workoutId: '4',
        categoryKey: 'cardio',
        exerciseKey: 'cardioexercises_1',
        workoutName: 'HIIT Fat Burner',
        workoutLevel: 'Advanced',
        workoutDescription: 'High-intensity intervals to torch calories and boost endurance.',
      ),
      Workout(
        workoutId: '5',
        categoryKey: 'cardio',
        exerciseKey: 'cardioexercises_2',
        workoutName: 'Quick Cardio Blast',
        workoutLevel: 'Beginner',
        workoutDescription: 'Short and effective cardio session to get your heart rate up.',
      ),
      Workout(
        workoutId: '6',
        categoryKey: 'cardio',
        exerciseKey: 'cardioexercises_3',
        workoutName: 'Endurance Circuit',
        workoutLevel: 'Intermediate',
        workoutDescription: 'Push your limits with a 30-minute endurance-based cardio circuit.',
      ),

      // LEG
      Workout(
        workoutId: '7',
        categoryKey: 'leg',
        exerciseKey: 'legexercises_1',
        workoutName: 'Leg Day Burn',
        workoutLevel: 'Advanced',
        workoutDescription: 'A powerful lower-body session focused on strength and hypertrophy.',
      ),
      Workout(
        workoutId: '8',
        categoryKey: 'leg',
        exerciseKey: 'legexercises_2',
        workoutName: 'Beginner Leg Routine',
        workoutLevel: 'Beginner',
        workoutDescription: 'Foundational leg workout for mobility, strength, and balance.',
      ),

      // RELAXING
      Workout(
        workoutId: '9',
        categoryKey: 'relaxing',
        exerciseKey: 'relaxexercises_1',
        workoutName: 'Morning Flow Yoga',
        workoutLevel: 'Beginner',
        workoutDescription: 'Gentle yoga sequence to energize your day and improve flexibility.',
      ),
      Workout(
        workoutId: '10',
        categoryKey: 'relaxing',
        exerciseKey: 'relaxexercises_2',
        workoutName: 'Evening Unwind',
        workoutLevel: 'Intermediate',
        workoutDescription: 'Wind down with stretches and breathwork to calm your body and mind.',
      ),
    ];
  }
}
