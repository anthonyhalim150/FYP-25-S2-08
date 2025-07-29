import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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

  String buildShareContent({
    required String workoutName,
    required String date,
    required String duration,
    required String calories,
    required String intensity,
    required int avgHeartRate,
    required int peakHeartRate,
    required int steps,
    required int totalSets,
    required String repString,
    required String maxWeight,
    required String caloriesPerMin,
    String? notes,
  }) {
    String statString = [
      "Average Heart Rate: $avgHeartRate bpm",
      "Peak Heart Rate: $peakHeartRate bpm",
      "Steps: $steps",
      "Sets: $totalSets",
      "Reps: $repString",
      "Max Weight: $maxWeight",
      "Calories per min: $caloriesPerMin",
    ].join('\n');

    String text = "🏋️ Workout: $workoutName\n"
        "📅 Date: $date\n"
        "⏱ Duration: $duration\n"
        "🔥 Calories: $calories\n"
        "⬆️ Intensity: $intensity\n"
        "$statString";

    if (notes != null && notes.trim().isNotEmpty) {
      text += "\n📝 Notes: $notes";
    }
    text += "\n\nShared via MyWorkoutApp 💪";
    return text;
  }

  void _showShareEditDialog(BuildContext context, String initialText) {
    final controller = TextEditingController(text: initialText);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final padding = MediaQuery.of(context).viewInsets;
        return Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 18),
              Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Edit your share message',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: TextField(
                  controller: controller,
                  maxLines: 8,
                  minLines: 4,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: colorScheme.outline),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    icon: Icon(Icons.share, color: colorScheme.onPrimary),
                    label: Text("Share", style: textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary)),
                    onPressed: () {
                      final msg = controller.text.trim();
                      if (msg.isNotEmpty) {
                        Share.share(msg, subject: "My Workout Accomplishment!");
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        );
      },
    );
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

    // can customize this
    final sessionNotes = 'Felt strong! Increased weight 😎';

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
                  sessionNotes,
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
                    final workoutName = workout['workoutName'] ?? 'Workout';
                    final date = DateTime.now().toIso8601String().substring(0, 10);
                    final initialText = buildShareContent(
                      workoutName: workoutName,
                      date: date,
                      duration: formatDuration(duration),
                      calories: '${calories.toStringAsFixed(0)} kcal',
                      intensity: 'Advanced',
                      avgHeartRate: avgHeartRate,
                      peakHeartRate: peakHeartRate,
                      steps: steps,
                      totalSets: totalSets,
                      repString: repStrings.join(', '),
                      maxWeight: '${maxWeight.toStringAsFixed(1)} kg',
                      caloriesPerMin: caloriesPerMin.toStringAsFixed(1),
                      notes: sessionNotes,
                    );
                    _showShareEditDialog(context, initialText);
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
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}