import 'package:flutter/material.dart';
import 'package:wise_workout_app/screens/workout_exercises_screen.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/workout_tile.dart';
import '../screens/exercise_detail_screen.dart';
import '../services/workout_service.dart';

// Main screen displaying a list of exercises for a workout
class WorkoutScreen extends StatefulWidget {
  final int workoutID;
  final String workoutName;

  const WorkoutScreen({
    Key? key,
    required this.workoutID,
    required this.workoutName,
  }) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  late Future<List<Workout>> _exercisesFuture;
  final WorkoutService _service = WorkoutService();

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _service.fetchExercises(widget.workoutID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder<List<Workout>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading exercises'));
          }

          final exercises = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // Image-based AppBar
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: BackButton(color: Colors.white),
                actions: [BookmarkButton()],
                flexibleSpace: FlexibleSpaceBar(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Text(
                      widget.workoutName,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  background: Image.asset(
                    'assets/workoutImages/strength_training.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Content
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // Workouts Found text (only once at the top)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${exercises.length} Workouts Found',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      // Exercise tiles list
                      ...exercises.map((ex) => Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: WorkoutTile(
                          workout: ex,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WorkoutExercisesScreen(workoutId: widget.workoutID, workoutName: widget.workoutName,
                                workoutImageUrl: 'assets/workoutImages/strength_training.jpg',),
                              ),
                            );
                          },
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: bottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/leaderboard');
              break;
            case 2:
              Navigator.pushNamed(context, '/workout-dashboard');
              break;
            case 3:
              Navigator.pushNamed(context, '/messages');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}

// Bookmark button stub
class BookmarkButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.bookmark_border),
      onPressed: () {
        // TODO: handle bookmark logic
      },
    );
  }
}