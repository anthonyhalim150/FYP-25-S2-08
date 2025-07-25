import 'dart:async';
import '../screens/model/exercise_model.dart';

class WorkoutSessionService {
  static final WorkoutSessionService _instance = WorkoutSessionService._internal();

  factory WorkoutSessionService() => _instance;

  WorkoutSessionService._internal();

  bool _isActive = false;
  String? _workoutName;
  DateTime? _startTime;
  Timer? _timer;

  final List<LoggedExercise> _loggedExercises = [];
  final StreamController<Duration> _elapsedController = StreamController<Duration>.broadcast();

  // Public getters
  bool get isActive => _isActive;
  String? get workoutName => _workoutName;
  Duration get elapsed => _startTime != null ? DateTime.now().difference(_startTime!) : Duration.zero;
  Stream<Duration> get elapsedStream => _elapsedController.stream;
  List<LoggedExercise> get loggedExercises => List.unmodifiable(_loggedExercises);

  // Set workout name (called before session starts)
  void setWorkoutName(String name) {
    _workoutName = name;
  }

  // Start workout session
  void start([void Function()? onTick]) {
    if (_isActive) return;

    _isActive = true;
    _startTime = DateTime.now();
    _loggedExercises.clear();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedController.add(elapsed);
      if (onTick != null) {
        onTick();
      }
    });
  }

  // Add an exercise log to the session
  void addExerciseLog({required Exercise exercise, required double calories, required List<Map<String, dynamic>> sets}) {
    _loggedExercises.add(
      LoggedExercise(
        exercise: exercise,
        calories: calories,
        sets: sets,
        timestamp: DateTime.now(),
      ),
    );
  }

  // Clear the session (when user ends the workout)
  void clearSession() {
    _timer?.cancel();
    _timer = null;
    _startTime = null;
    _isActive = false;
    _loggedExercises.clear();
    _workoutName = null;
    _elapsedController.add(Duration.zero);
  }
}

// LoggedExercise structure
class LoggedExercise {
  final Exercise exercise;
  final double calories;
  final List<Map<String, dynamic>> sets;
  final DateTime timestamp;

  LoggedExercise({
    required this.exercise,
    required this.calories,
    required this.sets,
    required this.timestamp,
  });
}
