import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class WorkoutSessionService extends ChangeNotifier {
  static final WorkoutSessionService _instance = WorkoutSessionService._internal();

  factory WorkoutSessionService() => _instance;

  WorkoutSessionService._internal();

  bool _isActive = false;
  late Stopwatch _stopwatch;
  Timer? _timer;
  String activeWorkoutName = '';

  bool get isActive => _isActive;

  Duration get elapsed => _stopwatch.elapsed;

  void setWorkoutName(String name) {
    activeWorkoutName = name;
  }

  void start(void Function(Duration elapsed)? onTick) {
    if (_isActive) return;

    _stopwatch = Stopwatch()..start();
    _isActive = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (onTick != null) onTick(_stopwatch.elapsed);
      notifyListeners();
    });
  }

  void clearSession() {
    _stopwatch.stop();
    _timer?.cancel();
    _isActive = false;
    activeWorkoutName = '';
    notifyListeners();
  }
}
