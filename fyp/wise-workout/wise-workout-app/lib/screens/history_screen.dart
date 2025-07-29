import 'package:flutter/material.dart';
import 'analysis_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  // TODO: Replace with backend API call
  final List<Map<String, dynamic>> workoutHistory = const [
    {
      'date': '2024-06-10',
      'workout': 'Strength Training',
      'icon': Icons.fitness_center,
      'duration': '50 min',
      'calories': 410,
      'intensity': 'Advanced',
      'notes': 'Felt strong, increased weights!',
    },
    {
      'date': '2024-06-08',
      'workout': 'Home Yoga',
      'icon': Icons.self_improvement,
      'duration': '30 min',
      'calories': 120,
      'intensity': 'Gentle',
      'notes': 'Very relaxing.',
    },
    {
      'date': '2024-06-05',
      'workout': 'Core Training',
      'icon': Icons.accessibility_new,
      'duration': '25 min',
      'calories': 150,
      'intensity': 'Moderate',
      'notes': '',
    },
    {
      'date': '2024-06-02',
      'workout': 'HIIT Blast',
      'icon': Icons.flash_on,
      'duration': '20 min',
      'calories': 260,
      'intensity': 'Intense',
      'notes': 'Exhausting but awesome!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: colorScheme.onSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'history_title'.tr(),
                        textAlign: TextAlign.center,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // spacer for symmetry
                  ],
                ),
              ),
            ),
          ),
          // Workout List or Empty State
          Expanded(
            child: workoutHistory.isEmpty
                ? Center(
              child: Text(
                'history_empty_message'.tr(),
                style: textTheme.titleMedium?.copyWith(color: colorScheme.outline),
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: workoutHistory.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final entry = workoutHistory[i];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnalysisScreen(
                          date: entry['date'],
                          workout: entry['workout'],
                          icon: entry['icon'],
                          duration: entry['duration'],
                          calories: entry['calories'],
                          intensity: entry['intensity'],
                          notes: entry['notes'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(entry['icon'] as IconData,
                            color: colorScheme.onSurface, size: 40),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry['date'],
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry['workout'],
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.timer,
                                      size: 16, color: colorScheme.onSurface.withOpacity(0.75)),
                                  const SizedBox(width: 4),
                                  Text(
                                    entry['duration'],
                                    style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurface.withOpacity(0.7)),
                                  ),
                                  const SizedBox(width: 15),
                                  Icon(Icons.local_fire_department,
                                      size: 16, color: colorScheme.secondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${entry['calories']} kcal",
                                    style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.secondary),
                                  ),
                                  const SizedBox(width: 15),
                                  Icon(Icons.trending_up,
                                      size: 16, color: colorScheme.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    entry['intensity'],
                                    style: textTheme.bodySmall?.copyWith(
                                      fontSize: 13,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              if (entry['notes'] != null &&
                                  (entry['notes'] as String).isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    entry['notes'],
                                    style: textTheme.bodySmall?.copyWith(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}