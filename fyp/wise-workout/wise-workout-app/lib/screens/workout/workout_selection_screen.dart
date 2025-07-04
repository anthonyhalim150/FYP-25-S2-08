// import 'package:flutter/material.dart';
// import 'package:wise_workout_app/screens/workout/workout_exercises_screen.dart';
// import '../../widgets/bottom_navigation.dart';
// import '../../widgets/workout_tile.dart';
// import 'exercise_detail_screen.dart';
// import '../../services/workout_service.dart';
//
// // Main screen displaying a list of exercises for a workout
// class WorkoutScreen extends StatefulWidget {
//   final int workoutId;
//   final String workoutName;
//   final String categoryName;
//   final String workoutKey;
//
//   const WorkoutScreen({
//     Key? key,
//     required this.workoutId,
//     required this.workoutName,
//     required this.categoryName,
//     required this.workoutKey,
//   }) : super(key: key);
//
//   @override
//   _WorkoutScreenState createState() => _WorkoutScreenState();
// }
//
// class _WorkoutScreenState extends State<WorkoutScreen> {
//   late Future<List<Workout>> _exercisesFuture;
//   final WorkoutService _service = WorkoutService();
//   late final String _categoryName;
//   late final String _workoutName;
//   late final String _workoutKey;
//   @override
//   void initState() {
//     super.initState();
//     _workoutKey = widget.workoutKey;
//     _categoryName = widget.categoryName;
//     _workoutName = widget.workoutName;
//     _exercisesFuture = _service.fetchWorkouts(_categoryName);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: FutureBuilder<List<Workout>>(
//         future: _exercisesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error loading exercises'));
//           }
//
//           final allExercises = snapshot.data!;
//           final exercises = allExercises
//               .where((ex) => ex.category.toLowerCase() == _categoryName.toLowerCase())
//               .toList();
//
//
//           return CustomScrollView(
//             slivers: [
//               // Image-based AppBar
//               SliverAppBar(
//                 expandedHeight: 250.0,
//                 pinned: true,
//                 backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//                 leading: BackButton(color: Colors.white),
//                 actions: [BookmarkButton()],
//                 flexibleSpace: FlexibleSpaceBar(
//                   title: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 1),
//                     child: Text(
//                       _workoutName,
//                       style: const TextStyle(
//                         color: Colors.orange,
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   background: Image.asset(
//                     'assets/workoutCategory/${_workoutName.toLowerCase().replaceAll(' ', '_')}.jpg',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//
//               // Content
//               SliverPadding(
//                 padding: EdgeInsets.all(16),
//                 sliver: SliverList(
//                   delegate: SliverChildListDelegate(
//                     [
//                       // Workouts Found text (only once at the top)
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Text(
//                           '${exercises.length} Workouts Found',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ),
//                       // Exercise tiles list
//                       ...exercises.map((ex) => Padding(
//                         padding: const EdgeInsets.only(bottom: 0),
//                         child: WorkoutTile(
//                           workout: ex,
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => WorkoutExercisesScreen(workoutId: ex.workoutId, workoutName: ex.title, workoutKey: ex.workoutKey,
//                                 workoutImageUrl: 'assets/workoutImages/strength_training.jpg',),
//                               ),
//                             );
//                           },
//                         ),
//                       )).toList(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//       bottomNavigationBar: bottomNavigationBar(
//         currentIndex: 0,
//         onTap: (index) {
//           switch (index) {
//             case 0:
//               Navigator.pushNamed(context, '/home');
//               break;
//             case 1:
//               Navigator.pushNamed(context, '/leaderboard');
//               break;
//             case 2:
//               Navigator.pushNamed(context, '/workout-dashboard');
//               break;
//             case 3:
//               Navigator.pushNamed(context, '/messages');
//               break;
//             case 4:
//               Navigator.pushNamed(context, '/profile');
//               break;
//           }
//         },
//       ),
//     );
//   }
// }
//
// // Bookmark button stub
// class BookmarkButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.bookmark_border),
//       onPressed: () {
//         // TODO: handle bookmark logic
//       },
//     );
//   }
// }