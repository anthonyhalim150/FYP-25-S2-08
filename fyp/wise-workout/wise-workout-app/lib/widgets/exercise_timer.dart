// lib/utils/exercise_timer.dart
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class ExerciseTimer {
  static void showRestTimer(BuildContext context, CountDownController timerController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rest Timer", textAlign: TextAlign.center),
        content: CircularCountDownTimer(
          duration: 60,
          initialDuration: 0,
          controller: timerController,
          width: 120,
          height: 120,
          ringColor: Colors.grey[300]!,
          fillColor: Colors.blue[500]!,
          backgroundColor: Colors.white,
          strokeWidth: 10.0,
          strokeCap: StrokeCap.round,
          isTimerTextShown: true,
          isReverse: true,
          textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          onComplete: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => timerController.pause(),
            child: const Text("Pause"),
          ),
          TextButton(
            onPressed: () => timerController.resume(),
            child: const Text("Resume"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}