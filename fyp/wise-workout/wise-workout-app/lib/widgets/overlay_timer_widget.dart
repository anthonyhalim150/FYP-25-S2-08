import 'package:flutter/material.dart';
import '../services/workout_session_service.dart';

class OverlayTimerWidget extends StatefulWidget {
  final Widget child;

  const OverlayTimerWidget({super.key, required this.child});

  @override
  State<OverlayTimerWidget> createState() => _OverlayTimerWidgetState();
}

class _OverlayTimerWidgetState extends State<OverlayTimerWidget> {
  final WorkoutSessionService _sessionService = WorkoutSessionService();
  late VoidCallback _listener;
  String _formattedTime = "00:00:00";

  @override
  void initState() {
    super.initState();
    _listener = () {
      final elapsed = _sessionService.elapsed;
      setState(() {
        _formattedTime = _formatDuration(elapsed);
      });
    };
    _sessionService.addListener(_listener);
  }

  @override
  void dispose() {
    _sessionService.removeListener(_listener);
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  }

  void _endWorkout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("End Workout"),
        content: const Text("Are you sure you want to end this workout session?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("End")),
        ],
      ),
    );

    if (confirm == true) {
      final duration = _sessionService.elapsed;
      final name = _sessionService.activeWorkoutName;
      _sessionService.clearSession();

      if (context.mounted) {
        Navigator.pushNamed(
          context,
          '/workout-analysis',
          arguments: {
            'duration': duration,
            'calories': 6.5 * duration.inMinutes,
            'workoutName': name,
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_sessionService.isActive)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: FloatingActionButton.extended(
              onPressed: () => _endWorkout(context),
              icon: const Icon(Icons.stop),
              label: Text(_formattedTime),
              backgroundColor: Colors.red,
            ),
          ),
      ],
    );
  }
}
