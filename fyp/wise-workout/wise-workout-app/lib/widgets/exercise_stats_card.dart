import 'package:flutter/material.dart';
import 'exercise_gauge.dart'; // Make sure this import path is correct

class ExerciseStatsCard extends StatelessWidget {
  final int currentSteps;
  final int maxSteps;
  final int caloriesBurned;
  final int xpEarned;

  const ExerciseStatsCard({
    super.key,
    required this.currentSteps,
    required this.maxSteps,
    required this.caloriesBurned,
    required this.xpEarned,
  });

  Widget _buildStatItem(BuildContext context, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
    decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.secondaryContainer,
    borderRadius: BorderRadius.circular(30),
    boxShadow: const [
    BoxShadow(
    color: Colors.black12,
    blurRadius: 10,
    offset: Offset(0, 4),
    ),],
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
    children: [
    SizedBox(
    height: 160,
    child: Stack(
    alignment: Alignment.bottomCenter,
    children: [
    SizedBox(
    width: 300,
    height: 210,
    child: ExerciseGauge(  // This should now be recognized
    progress: currentSteps / maxSteps,
    backgroundColor: Theme.of(context).colorScheme.surface,
    progressColor: Theme.of(context).colorScheme.primaryContainer,
    ),
    ),
    Positioned(
    top: 98,
    left: 5,
    right: 20,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    _buildStatItem(context, Icons.directions_walk, "Steps", "$currentSteps/$maxSteps"),
    const SizedBox(width: 10),
    _buildStatItem(context, Icons.local_fire_department, "Calories", "$caloriesBurned"),
    const SizedBox(width: 20),
    _buildStatItem(context, Icons.star, "XP", "$xpEarned"),
    ],
    ),
    ),
    ],
    ),
    ),
    const SizedBox(height: 20),
    ],
    ),
    ),
    );
    }
}