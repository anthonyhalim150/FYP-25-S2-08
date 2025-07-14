import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CongratulationScreen extends StatefulWidget {
  final Map<String, dynamic> workoutResult; // Pass arguments here

  const CongratulationScreen({super.key, required this.workoutResult});

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();

    // Auto-navigate to WorkoutAnalysisPage after delay
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(
        context,
        '/workout-analysis',
        arguments: widget.workoutResult,
      );
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// Confetti
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 40,
            emissionFrequency: 0.05,
            gravity: -2,
            colors: const [Colors.red, Colors.blue, Colors.orange, Colors.green],
          ),

          /// Congratulations Message
          Transform.translate(
            offset: const Offset(30, 0), // 👈 pushes widget 30px to the right
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text(
                  "🎉 Congratulations! 🎉",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "You’ve completed your workout!",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text("Loading summary...", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
