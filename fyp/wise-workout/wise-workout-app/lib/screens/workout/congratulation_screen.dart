import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CongratulationScreen extends StatefulWidget {
  final Map<String, dynamic> workoutResult;
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
    // Auto-navigate after delay
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/workout-analysis',
          arguments: widget.workoutResult,
        );
      }
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cc = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final confettiColors = [
      cc.primary,
      cc.secondary,
      cc.error,
      cc.primaryContainer,
      cc.secondaryContainer,
      Colors.amber, // fallback/confetti
      Colors.teal,  // fallback/confetti
    ];

    return Scaffold(
      backgroundColor: cc.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 40,
            emissionFrequency: 0.05,
            gravity: 0.2,
            colors: confettiColors,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "🎉 Congratulations! 🎉",
                  style: tt.headlineSmall?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: cc.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "You’ve completed your workout!",
                  style: tt.titleMedium?.copyWith(
                    color: cc.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Loading summary...",
                  style: tt.bodyMedium?.copyWith(color: cc.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}