import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class ExerciseTimer {
  static void showRestTimer(BuildContext context, CountDownController timerController) {
    int duration = 60;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Rest Timer", textAlign: TextAlign.center),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularCountDownTimer(
                    duration: duration,
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Increase time by 10 seconds
                          duration += 10;
                          timerController.restart(duration: duration);
                          setState(() {});
                        },
                        child: const Text("+10s"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          if (duration > 10) {
                            duration -= 10;
                            timerController.restart(duration: duration);
                            setState(() {});
                          }
                        },
                        child: const Text("-10s"),
                      ),
                    ],
                  ),
                ],
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
            );
          },
        );
      },
    );
  }
}
