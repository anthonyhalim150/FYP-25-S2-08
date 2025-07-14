import 'package:flutter/material.dart';
import '../model/exercise_model.dart';
import '../model/workout_model.dart';

class WorkoutAnalysisPage extends StatefulWidget {
  const WorkoutAnalysisPage({super.key});

  @override
  State<WorkoutAnalysisPage> createState() => _WorkoutAnalysisPageState();
}

class _WorkoutAnalysisPageState extends State<WorkoutAnalysisPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final Workout workout = args['workout'] as Workout;
    final List<Exercise> exercises = args['exercises'] as List<Exercise>;
    final Duration duration = args['duration'] as Duration;
    final double calories = args['calories'] as double;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F2),
      body: SafeArea(
        child: Column(
          children: [
            /// Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.black),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.emoji_events, color: Colors.amber, size: 24),
                              SizedBox(width: 8),
                              Text(
                                "Workout Summary",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrangeAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // 🏋️ Workout Info
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.purple,
                                child: Icon(Icons.fitness_center, color: Colors.white),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    workout.workoutName,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${DateTime.now().toLocal().toIso8601String().substring(0, 10)}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // 🧾 Info Chips
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _InfoChip(icon: Icons.timer, label: "${duration.inMinutes} min", sublabel: "Duration"),
                              _InfoChip(icon: Icons.local_fire_department, label: "${calories.toStringAsFixed(0)} kcal", sublabel: "Calories"),
                              _InfoChip(icon: Icons.trending_up, label: workout.workoutLevel, sublabel: "Intensity"),
                            ],
                          ),
                          const SizedBox(height: 28),

                          // 📊 Detailed Stats
                          const Text("Detailed Stats", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 12),
                          _buildStatRow("Average Heart Rate", "123 bpm"),
                          _buildStatRow("Peak Heart Rate", "143 bpm"),
                          _buildStatRow("Steps", "1,245"),
                          _buildStatRow("Sets", "${exercises.length}"),
                          _buildStatRow("Reps", exercises.map((e) => e.exerciseReps).join(', ')),
                          _buildStatRow("Max Weight", "${_maxWeight(exercises)} kg"),
                          _buildStatRow("Calories per min", (calories / duration.inMinutes).toStringAsFixed(1)),

                          const SizedBox(height: 20),
                          const Text("Session Notes", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          const Text(
                            "Felt strong! Increased weight 😎",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// 📌 Bottom Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.check),
                      label: const Text("Finish Workout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Add share logic
                      },
                      icon: const Icon(Icons.share),
                      label: const Text("Share"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D0D33),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  double _maxWeight(List<Exercise> exercises) {
    return exercises.map((e) => e.exerciseWeight ?? 0.0).fold(0.0, (prev, next) => next > prev ? next : prev);
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(sublabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
