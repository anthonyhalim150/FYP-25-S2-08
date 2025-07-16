// import 'dart:async';
//
// class Workout {
//   final String workoutKey;
//   final int workoutId;
//   final String title;
//   final String category;
//   final String description;
//   final String duration;
//   final String level;
//
//   Workout({
//     required this.workoutKey,
//     required this.workoutId,
//     required this.title,
//     required this.category,
//     required this.description,
//     required this.duration,
//     required this.level,
//   });
// }
//
// class WorkoutService {
//   Future<List<Workout>> fetchWorkouts(String categoryName) async {
//     await Future.delayed(Duration(milliseconds: 500));
//
//     return [
//       Workout(
//         workoutKey: 'calisthenics',
//         workoutId: 1,
//         title: 'Calisthenics',
//         category: 'strength',
//         description: 'Strength training that uses the resistance of your body and gravity.',
//         duration: '20',
//         level: 'Beginner',
//       ),
//       Workout(
//         workoutKey: 'upper_body_blast',
//         workoutId: 2,
//         title: 'Upper Body Blast',
//         category: 'strength',
//         description: 'Focus on your chest, shoulders, and triceps using compound dumbbell movements.',
//         duration: '25',
//         level: 'Intermediate',
//       ),
//       Workout(
//         workoutKey: 'leg_day_power_burn',
//         workoutId: 3,
//         title: 'Leg Day Power Burn',
//         category: 'strength',
//         description: 'Ignite your lower body with squats, lunges, and glute bridges.',
//         duration: '30',
//         level: 'Advanced',
//       ),
//       Workout(
//         workoutKey: 'total_core_circuit',
//         workoutId: 4,
//         title: 'Total Body Core Circuit',
//         category: 'strength',
//         description: 'Strengthen your entire body and core with this functional circuit training routine.',
//         duration: '22',
//         level: 'Beginner',
//       ),
//       Workout(
//         workoutKey: 'morning_yoga',
//         workoutId: 5,
//         title: 'Morning Flow Yoga',
//         category: 'yoga',
//         description: 'Start your day with a gentle yoga flow to wake up your body and mind.',
//         duration: '15',
//         level: 'Beginner',
//       ),
//       Workout(
//         workoutKey: 'power_vinyasa',
//         workoutId: 6,
//         title: 'Power Vinyasa',
//         category: 'yoga',
//         description: 'Build strength and flexibility with this dynamic vinyasa flow sequence.',
//         duration: '30',
//         level: 'Intermediate',
//       ),
//       Workout(
//         workoutKey: 'evening_wind_down',
//         workoutId: 7,
//         title: 'Evening Wind Down Yoga',
//         category: 'yoga',
//         description: 'Relax and stretch your body in preparation for a good night’s sleep.',
//         duration: '20',
//         level: 'Beginner',
//       ),
//       Workout(
//         workoutKey: 'bodyweight_leg_blast',
//         workoutId: 8,
//         title: 'Bodyweight Leg Blast',
//         category: 'leg',
//         description: 'Burn your thighs and glutes with squats, lunges, and wall sits.',
//         duration: '18',
//         level: 'Beginner',
//       ),
//       Workout(
//         workoutKey: 'explosive_plyo_legs',
//         workoutId: 9,
//         title: 'Explosive Plyo Legs',
//         category: 'leg',
//         description: 'Add power and agility to your legs with jump squats and skater hops.',
//         duration: '25',
//         level: 'Intermediate',
//       ),
//       Workout(
//         workoutKey: 'glute_isolation',
//         workoutId: 10,
//         title: 'Glute Isolation Session',
//         category: 'leg',
//         description: 'Tone and build your glutes using bridges, pulses, and holds.',
//         duration: '20',
//         level: 'Advanced',
//       ),
//       Workout(
//         workoutKey: 'quick_hiit',
//         workoutId: 11,
//         title: 'Quick HIIT Circuit',
//         category: 'cardio',
//         description: 'Short but intense high-intensity intervals.',
//         duration: '15',
//         level: 'Beginner',
//       ),
//       Workout(
//         workoutKey: 'endurance_cardio',
//         workoutId: 12,
//         title: 'Endurance Cardio Burn',
//         category: 'cardio',
//         description: 'Jumping jacks, mountain climbers, and burpees for fat burn.',
//         duration: '30',
//         level: 'Intermediate',
//       ),
//       Workout(
//         workoutKey: 'cardio_kickboxing',
//         workoutId: 13,
//         title: 'Cardio Kickboxing',
//         category: 'cardio',
//         description: 'Punch and kick your way through this calorie-burning cardio session.',
//         duration: '25',
//         level: 'Advanced',
//       ),
//     ];
//   }
// }
