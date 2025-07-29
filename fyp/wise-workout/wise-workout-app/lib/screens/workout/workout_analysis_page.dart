import 'package:flutter/material.dart';

class WorkoutAnalysisPage extends StatefulWidget {
  const WorkoutAnalysisPage({super.key});
  @override
  State<WorkoutAnalysisPage> createState() => _WorkoutAnalysisPageState();
}

class _WorkoutAnalysisPageState extends State<WorkoutAnalysisPage> {
  String formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60);
    return '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Map<String, dynamic> workout = args['workout'];
    final List exercises = args['exercises'];
    final Duration duration = args['duration'];
    final double calories = args['calories'];

    // Optional mock stats (you can replace later)
    final int avgHeartRate = 123;
    final int peakHeartRate = 143;
    final int steps = 1245;
    final List<int> allReps = exercises.expand((e) => (e['sets'] as List).map((s) => s['reps'])).cast<int>().toList();
    final List<String> repStrings = allReps.map((r) => r.toString()).toList();
    final int totalSets = allReps.length;
    final double maxWeight = exercises
        .expand((e) => (e['sets'] as List))
        .map((s) => s['weight'])
        .whereType<num>()
        .fold<num>(0.0, (prev, w) => w > prev ? w : prev)
        .toDouble();
    final double caloriesPerMin = calories / (duration.inMinutes == 0 ? 1 : duration.inMinutes);

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Workout Analysis',
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Workout Name + Date + Icon
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primary,
                    child: Icon(Icons.fitness_center, color: colorScheme.onPrimary),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout['workoutName'] ?? 'Workout',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateTime.now().toIso8601String().substring(0, 10), // Replace with saved date if available
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Top Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryCard(context, Icons.timer, '${formatDuration(duration)}', 'Duration'),
                  _summaryCard(context, Icons.local_fire_department, '${calories.toStringAsFixed(0)} kcal', 'Calories'),
                  _summaryCard(context, Icons.fitness_center, 'Advanced', 'Intensity'), // placeholder
                ],
              ),
              const SizedBox(height: 24),
              // Detailed Stats
              _statsSection(context, [
                _statRow(context, 'Average Heart Rate', '$avgHeartRate bpm'),
                _statRow(context, 'Peak Heart Rate', '$peakHeartRate bpm'),
                _statRow(context, 'Steps', '$steps'),
                _statRow(context, 'Sets', '$totalSets'),
                _statRow(context, 'Reps', repStrings.join(', ')),
                _statRow(context, 'Max Weight', '${maxWeight.toStringAsFixed(1)} kg'),
                _statRow(context, 'Calories per min', caloriesPerMin.toStringAsFixed(1)),
              ]),
              const SizedBox(height: 24),
              // Session Notes (optional)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Session Notes',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Felt strong! Increased weight 😎',
                  style: textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 24),
              // Exercises performed
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Exercises Performed',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, i) {
                    final e = exercises[i];
                    final sets = e['sets'] as List;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      color: colorScheme.surface,
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                            e['exerciseName'],
                            style: textTheme.titleSmall
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: sets.map<Widget>((s) {
                            return Text(
                              'Set ${s['set']}: ${s['reps']} reps @ ${s['weight']} kg',
                              style: textTheme.bodyMedium,
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Share button
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    // TODO: Add sharing logic
                  },
                  icon: Icon(Icons.share, color: colorScheme.onPrimary),
                  label: Text('Share', style: textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(BuildContext context, IconData icon, String value, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icon, size: 32, color: colorScheme.secondary),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: textTheme.bodySmall),
      ],
    );
  }

  Widget _statsSection(BuildContext context, List<Widget> children) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Detailed Stats', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _statRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textTheme.bodyMedium),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              // Use onSurface for best visibility!
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}