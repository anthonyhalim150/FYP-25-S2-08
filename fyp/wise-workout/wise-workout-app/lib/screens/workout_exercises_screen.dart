import 'package:flutter/material.dart';
import '../services/exercise_service.dart';
import 'exercise_detail_screen.dart';
import '../widgets/bottom_navigation.dart';

class WorkoutExercisesScreen extends StatefulWidget {
  final int workoutId;
  final String workoutName;
  final String workoutImageUrl;
  final String workoutKey;

  const WorkoutExercisesScreen({
    super.key,
    required this.workoutId,
    required this.workoutName,
    required this.workoutImageUrl,
    required this.workoutKey,
  });

  @override
  State<WorkoutExercisesScreen> createState() => _WorkoutExercisesScreenState();
}

class _WorkoutExercisesScreenState extends State<WorkoutExercisesScreen> {
  late Future<List<Exercise>> _exercisesFuture;
  final ExerciseService _workoutService = ExerciseService();
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _workoutService.fetchExercises(widget.workoutKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Exercise>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final exercises = snapshot.data!;
          return _buildSliverContent(exercises);
        },
      ),
      bottomNavigationBar: bottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
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
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildSliverContent(List<Exercise> exercises) {
    return CustomScrollView(
      slivers: [
        // Image-based AppBar
        SliverAppBar(
          expandedHeight: 250.0,
          pinned: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
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
              'assets/workoutImages/${widget.workoutName.toLowerCase().replaceAll(' ', '_')}.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.fitness_center, size: 100, color: Colors.grey),
              ),
            ),
          ),
        ),

        // Content
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                // Workouts Found text
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${exercises.length} Exercises Found',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Exercise tiles list
                ...exercises.map((exercise) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ExerciseTile(
                    exercise: exercise,
                    onTap: () {
                      // Navigate to exercise details
                      Navigator.pushNamed(
                        context,
                        '/exercise-detail',
                        arguments: exercise, // Pass the full object
                      );
                    },
                    onPlayPressed: () {
                      // Handle play button action
                      // _startExercise(exercise);
                    },
                  ),
                )).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;
  final VoidCallback onPlayPressed;

  const ExerciseTile({
    super.key,
    required this.exercise,
    required this.onTap,
    required this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: const Color(0xFF688EA3),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Exercise Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  _getExerciseImagePath(exercise.title),
                  width: 180,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 180,
                    height: 120,
                    color: Color(0x688EA3),
                    child: const Icon(Icons.image),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Exercise Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${exercise.sets} sets • ${exercise.suggestedReps} reps',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level: ${exercise.level}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
String _getExerciseImagePath(String exerciseTitle) {
  // Convert to lowercase and replace spaces with underscores
  final formattedName = exerciseTitle.toLowerCase().replaceAll(' ', '_');
  return 'assets/exerciseImages/${formattedName}_gif.jpg';
}