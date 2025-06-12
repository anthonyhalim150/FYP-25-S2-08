import 'package:flutter/material.dart';
import '../services/exercise_service.dart';

class WorkoutExercisesScreen extends StatefulWidget {
  final int workoutId;
  final String workoutName;
  final String workoutImageUrl;

  const WorkoutExercisesScreen({
    super.key,
    required this.workoutId,
    required this.workoutName,
    required this.workoutImageUrl,
  });

  @override
  State<WorkoutExercisesScreen> createState() => _WorkoutExercisesScreenState();
}

class _WorkoutExercisesScreenState extends State<WorkoutExercisesScreen> {
  late Future<List<Exercise>> _exercisesFuture;
  final WorkoutService _workoutService = WorkoutService();

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _workoutService.fetchExercises(widget.workoutId);
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
              widget.workoutImageUrl,
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
                      // Navigator.push(context, MaterialPageRoute(
                      //   builder: (context) => ExerciseDetailsScreen(exercise: exercise),
                      // ));
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
      color: Colors.white,
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
                  exercise.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
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
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${exercise.sets} sets • ${exercise.reps} reps',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level: ${exercise.level}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),

              // Play Button
              IconButton(
                onPressed: onPlayPressed,
                icon: const Icon(Icons.play_circle_fill,
                  color: Colors.blue,
                  size: 36,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}