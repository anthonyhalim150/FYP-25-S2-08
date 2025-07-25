import 'dart:async';
import 'package:flutter/material.dart';
import '../model/exercise_model.dart';
import '../../services/exercise_service.dart';
import '../../services/workout_session_service.dart';
import '../../widgets/exercise_tile.dart';
import 'congratulation_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class ExerciseListPage extends StatefulWidget {
  final int workoutId;
  final String workoutName;

  const ExerciseListPage({
    super.key,
    required this.workoutId,
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
    _exercisesFuture = ExerciseService().fetchExercisesByWorkout(widget.workoutId.toString());
    _elapsedSubscription = _sessionService.elapsedStream.listen((elapsed) {
      setState(() {
        _formattedTime = _formatDuration(elapsed);
      });
    });
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
        SnackBar(content: Text(tr('exercise_list_already_started'))),
      );
      return;
    }
    _sessionService.start((_) {});
  }

  void _endWorkout() async {
    final duration = _sessionService.elapsed;
    _sessionService.clearSession();
    setState(() {
      _formattedTime = "00:00:00";
    });
    final exercises = await _exercisesFuture;
    final workoutResult = {
      'workout': {
        'workoutId': widget.workoutId,
        'workoutName': widget.workoutName,
      },
      'exercises': exercises,
      'duration': duration,
      'calories': _calculateCalories(duration),
    };
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CongratulationScreen(workoutResult: workoutResult),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  }

  double _calculateCalories(Duration duration) {
    final minutes = duration.inMinutes;
    return 6.5 * minutes;
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
                final errorMsg = snapshot.error?.toString() ?? 'Unknown error';
                return Center(child: Text('${tr('exercise_list_error')}: $errorMsg'));
              }

              final exercises = snapshot.data!;
              final translated = tr('exercise_list_found');
              debugPrint('🟠 exercise_list_found = $translated');

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
                          '${exercises.length} $translated',
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
          if (_sessionService.isActive)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: FloatingActionButton.extended(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(tr('exercise_list_end_title')),
                      content: Text(tr('exercise_list_end_confirm')),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(tr('cancel')),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(tr('end')),
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
        label: Text(tr('exercise_list_start')),
        backgroundColor: Colors.orange,
      )
          : null,
    );
  }
}
