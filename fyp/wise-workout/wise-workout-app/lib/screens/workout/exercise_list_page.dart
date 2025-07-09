import 'dart:async';

import 'package:flutter/material.dart';
import '../model/exercise_model.dart';
import '../../services/exercise_services.dart';
import '../../services/workout_session_service.dart';
import '../../widgets/exercise_tile.dart';

class ExerciseListPage extends StatefulWidget {
  final String exerciseKey;
  final String workoutName;

  const ExerciseListPage({
    super.key,
    required this.exerciseKey,
    required this.workoutName,
  });

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  late Future<List<Exercise>> _exercisesFuture;

  final WorkoutSessionService _sessionService = WorkoutSessionService();

  String _formattedTime = "00:00:00";
  late StreamSubscription<Duration> _elapsedSubscription;

  @override
  void initState() {
    super.initState();

    _exercisesFuture = ExerciseService().fetchExercisesByKey(widget.exerciseKey);

    // Listen to the global elapsed time stream to update timer UI
    _elapsedSubscription = _sessionService.elapsedStream.listen((elapsed) {
      setState(() {
        _formattedTime = _formatDuration(elapsed);
      });
    });

    // Initialize _formattedTime if session already active
    if (_sessionService.isActive) {
      _formattedTime = _formatDuration(_sessionService.elapsed);
    }
  }

  @override
  void dispose() {
    _elapsedSubscription.cancel();
    super.dispose();
  }

  void _startWorkout() {
    _sessionService.setWorkoutName(widget.workoutName);
    if (_sessionService.isActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Workout session already in progress.")),
      );
      return;
    }
    _sessionService.start((_) {}); // actual UI updates come from stream listener
  }

  void _endWorkout() async {
    final duration = _sessionService.elapsed;
    _sessionService.clearSession();

    setState(() {
      _formattedTime = "00:00:00";
    });

    await Navigator.pushNamed(
      context,
      '/workout-analysis',
      arguments: {
        'duration': duration,
        'calories': _calculateCalories(duration),
        'workoutName': widget.workoutName,
      },
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  }

  double _calculateCalories(Duration duration) {
    final minutes = duration.inMinutes;
    return 6.5 * minutes; // Simplified formula
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<List<Exercise>>(
            future: _exercisesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final exercises = snapshot.data!;
              return NestedScrollView(
                headerSliverBuilder: (context, _) => [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 250,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/workoutImages/${widget.workoutName.toLowerCase().replaceAll(' ', '_')}.jpg',
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: MediaQuery.of(context).padding.top + 10,
                            left: 16,
                            child: CircleAvatar(
                              backgroundColor: Colors.white70,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.black),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Text(
                              widget.workoutName,
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                body: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      ...exercises.map((exercise) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ExerciseTile(
                          exercise: exercise,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/exercise-detail',
                              arguments: exercise,
                            );
                          },
                          onPlayPressed: () {},
                        ),
                      )),
                    ],
                  ),
                ),
              );
            },
          ),

          // Show timer FloatingActionButton if workout is active
          if (_sessionService.isActive)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("End Workout"),
                      content: const Text("Are you sure you want to end this workout session?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("End"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    _endWorkout();
                  }
                },
                icon: const Icon(Icons.stop),
                label: Text(_formattedTime),
                backgroundColor: Colors.red,
              ),
            ),
        ],
      ),

      floatingActionButton: !_sessionService.isActive
          ? FloatingActionButton.extended(
        onPressed: _startWorkout,
        icon: const Icon(Icons.fitness_center),
        label: const Text("Start Workout"),
        backgroundColor: Colors.orange,
      )
          : null,
    );
  }
}