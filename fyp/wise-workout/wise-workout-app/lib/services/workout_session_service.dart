import 'dart:async';

class WorkoutSessionService {
  static final WorkoutSessionService _instance = WorkoutSessionService._internal();

  factory WorkoutSessionService() => _instance;

  WorkoutSessionService._internal();

  String? _workoutName;
  bool _isActive = false;

  Duration _elapsed = Duration.zero;
  Timer? _timer;

  final StreamController<Duration> _elapsedController = StreamController.broadcast();

  Stream<Duration> get elapsedStream => _elapsedController.stream;

  bool get isActive => _isActive;

  Duration get elapsed => _elapsed;

  void setWorkoutName(String name) {
    _workoutName = name;
  }
  String? get workoutName => _workoutName;

  void start([void Function(Duration)? onElapsed]) {
    if (_isActive) return;
    _isActive = true;
    _elapsed = Duration.zero;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed += const Duration(seconds: 1);
      _elapsedController.add(_elapsed);
      if (onElapsed != null) onElapsed(_elapsed);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _isActive = false;
  }

  void clearSession() {
    stop();
    _elapsed = Duration.zero;
    _workoutName = null;
  }

  void dispose() {
    _timer?.cancel();
    _elapsedController.close();
  }
}