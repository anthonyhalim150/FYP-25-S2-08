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
    final double caloriesPerMin = (calories / duration.inMinutes);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Workout Analysis',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Workout Name + Date + Icon
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.fitness_center, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout['workoutName'] ?? 'Workout',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateTime.now().toIso8601String().substring(0, 10), // Replace with saved date if available
                        style: const TextStyle(color: Colors.grey),
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
                  _summaryCard(Icons.timer, '${formatDuration(duration)}', 'Duration'),
                  _summaryCard(Icons.local_fire_department, '${calories.toStringAsFixed(0)} kcal', 'Calories'),
                  _summaryCard(Icons.fitness_center, 'Advanced', 'Intensity'), // placeholder
                ],
              ),

              const SizedBox(height: 24),

              // Detailed Stats
              _statsSection([
                _statRow('Average Heart Rate', '$avgHeartRate bpm'),
                _statRow('Peak Heart Rate', '$peakHeartRate bpm'),
                _statRow('Steps', '$steps'),
                _statRow('Sets', '$totalSets'),
                _statRow('Reps', repStrings.join(', ')),
                _statRow('Max Weight', '${maxWeight?.toStringAsFixed(1)} kg'),
                _statRow('Calories per min', caloriesPerMin.toStringAsFixed(1)),
              ]),

              const SizedBox(height: 24),

              // Session Notes (optional)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Session Notes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Felt strong! Increased weight 😎'),
              ),

              const SizedBox(height: 24),

              // Exercises performed
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Exercises Performed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                      elevation: 2,
                      child: ListTile(
                        title: Text(e['exerciseName']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: sets.map<Widget>((s) {
                            return Text('Set ${s['set']}: ${s['reps']} reps @ ${s['weight']} kg');
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
                    backgroundColor: Colors.blue.shade900,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    // TODO: Add sharing logic
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.deepOrange),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _statsSection(List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Detailed Stats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        ],
      ),
    );
  }
}
