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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icon, size: 24, color: colorScheme.primary),
        const SizedBox(height: 2),
        Text(
          value,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSecondaryContainer.withOpacity(0.75),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final shadowColor = Theme.of(context).shadowColor;

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
                    child: ExerciseGauge(
                      progress: currentSteps / maxSteps,
                      backgroundColor: colorScheme.surface,
                      progressColor: colorScheme.primaryContainer,
                      onTap: () {
                        Navigator.pushNamed(context, '/dailySummary'); // Adjust the route if needed
                      },
                    ),
                  ),
                  Positioned(
                    top: 98,
                    left: 5,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatItem(
                            context, Icons.directions_walk, "Steps", "$currentSteps/$maxSteps"),
                        const SizedBox(width: 10),
                        _buildStatItem(
                            context, Icons.local_fire_department, "Calories", "$caloriesBurned"),
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