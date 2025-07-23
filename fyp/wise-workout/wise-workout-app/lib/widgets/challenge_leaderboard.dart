import 'package:flutter/material.dart';

class ChallengeLeaderboardWidget extends StatelessWidget {
  const ChallengeLeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildChallengeCard(
          context: context,
          title: 'Push Up Challenge',
          target: '150 Push Ups',
          duration: '5/7 days',
          participants: ['Cps', 'Brode'],
          values: [120, 110],
        ),
        const SizedBox(height: 12),
        _buildChallengeCard(
          context: context,
          title: 'Squat Challenge',
          target: '1200 Calories',
          duration: '3/3 days',
          participants: ['Brode', 'Cps', 'Loopy'],
          values: [1001, 890, 1199],
        ),
        const SizedBox(height: 12),
        _buildChallengeCard(
          context: context,
          title: 'Squat Jump Challenge',
          target: '1200 Calories',
          duration: '2/3 days',
          participants: ['Cps', 'Brode'],
          values: [800, 600],
        ),
      ],
    );
  }

  Widget _buildChallengeCard({
    required BuildContext context,
    required String title,
    required String target,
    required String duration,
    required List<String> participants,
    required List<int> values,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final maxVal = values.reduce((a, b) => a > b ? a : b).toDouble();
    final barMaxHeight = 120.0;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              Text('• on progress',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
          const SizedBox(height: 6),
          Text('Target: $target',
              style: theme.textTheme.bodySmall),
          Text('Duration: $duration',
              style: theme.textTheme.bodySmall),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(participants.length, (index) {
                final barValue = values[index].toDouble();
                final fillHeight = (barValue / maxVal) * barMaxHeight;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: barMaxHeight + 24,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: 36,
                            height: barMaxHeight,
                            decoration: BoxDecoration(
                              color: _getColor(index).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Container(
                            width: 36,
                            height: fillHeight,
                            decoration: BoxDecoration(
                              color: _getColor(index),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${values[index]}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '/${maxVal.toInt()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(participants[index],
                        style: theme.textTheme.bodySmall),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(int index) {
    const colors = [
      Color(0xFFD32F2F),
      Color(0xFFFFC107),
      Color(0xFFEC407A),
      Color(0xFF7E57C2),
      Color(0xFF26C6DA),
    ];
    return colors[index % colors.length];
  }
}