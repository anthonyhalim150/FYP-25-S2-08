import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class AnalysisScreen extends StatelessWidget {
  final String date;
  final String workout;
  final IconData icon;
  final String duration;
  final int calories;
  final String intensity;
  final String? notes;

  final Map<String, dynamic>? extraStats;

  const AnalysisScreen({
    Key? key,
    required this.date,
    required this.workout,
    required this.icon,
    required this.duration,
    required this.calories,
    required this.intensity,
    this.notes,
    this.extraStats,
  }) : super(key: key);

  // this is for sharing, hardcoded.
  String buildShareContent() {
    final stats = extraStats ?? {
      "Average Heart Rate": "123 bpm",
      "Peak Heart Rate": "143 bpm",
      "Steps": "1,256",
      "Sets": workout == "Strength Training" ? "4" : null,
      "Reps": workout == "Strength Training" ? "12, 10, 8, 8" : null,
      "Max Weight": workout == "Strength Training" ? "30 kg" : null,
      "Pace": workout.contains("HIIT") ? "Very Fast" : null,
      "Calories per min": (calories / (int.tryParse(duration.split(" ").first) ?? 1)).toStringAsFixed(1),
    };

    String statString = stats.entries
        .where((e) => e.value != null && e.value.toString().isNotEmpty)
        .map((e) => "${e.key}: ${e.value}")
        .join("\n");

    String text =
        "🏋️ Workout: $workout\n📅 Date: $date\n⏱ Duration: $duration\n🔥 Calories: $calories kcal\n"
        "⬆️ Intensity: $intensity\n$statString";
    if (notes != null && notes!.trim().isNotEmpty) {
      text += "\n📝 Notes: ${notes!}";
    }
    text += "\n\nShared via MyWorkoutApp 💪";
    return text;
  }

  void _showShareEditDialog(BuildContext context, String initialText) {
    final controller = TextEditingController(text: initialText);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      isScrollControlled: true,
      builder: (context) {
        final padding = MediaQuery.of(context).viewInsets; // For keyboard
        return Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 18),
              Container(width: 50, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              const Text(
                'Edit your share message',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: TextField(
                  controller: controller,
                  maxLines: 8,
                  minLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
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
                        backgroundColor: const Color(0xFF071655), padding: const EdgeInsets.symmetric(vertical: 13)),
                    icon: const Icon(Icons.share),
                    label: const Text("Share"),
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

  // this is hardcoded, replace with backend
  @override
  Widget build(BuildContext context) {
    final stats = extraStats ?? {
      "Average Heart Rate": "123 bpm",
      "Peak Heart Rate": "143 bpm",
      "Steps": "1,256",
      "Sets": workout == "Strength Training" ? "4" : null,
      "Reps": workout == "Strength Training" ? "12, 10, 8, 8" : null,
      "Max Weight": workout == "Strength Training" ? "30 kg" : null,
      "Pace": workout.contains("HIIT") ? "Very Fast" : null,
      "Calories per min": (calories / (int.tryParse(duration.split(" ").first) ?? 1)).toStringAsFixed(1),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Analysis"),
        backgroundColor: const Color(0xFF071655),
      ),
      backgroundColor: const Color(0xFFFAF6EE),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main info
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.purple[100],
                  child: Icon(icon, color: const Color(0xFF071655), size: 32),
                  radius: 32,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout,
                        style: const TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: Colors.grey[700]),
                          const SizedBox(width: 5),
                          Text(
                            date,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 25),

            // Quick stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statCard(Icons.timer, "Duration", duration),
                _statCard(Icons.local_fire_department, "Calories", "$calories kcal"),
                _statCard(Icons.trending_up, "Intensity", intensity),
              ],
            ),
            const SizedBox(height: 28),

            // Detailed stats
            const Text(
              "Detailed Stats",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...stats.entries
                .where((e) => e.value != null && e.value.toString().isNotEmpty)
                .map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        e.key,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      )),
                  Text(
                    e.value.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF071655),
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )),

            // Notes
            if (notes != null && notes!.isNotEmpty) ...[
              const SizedBox(height: 22),
              const Text(
                "Session Notes",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                notes!,
                style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showShareEditDialog(context, buildShareContent());
        },
        icon: const Icon(Icons.share),
        label: const Text("Share"),
        backgroundColor: const Color(0xFF071655),
      ),
    );
  }

  // A small card widget for top 3 stats
  Widget _statCard(IconData icon, String label, String value) {
    return Container(
      width: 95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.10),
              blurRadius: 4,
              offset: const Offset(1, 2))
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 7),
      child: Column(
        children: [
          Icon(icon, color: Colors.purple[300], size: 28),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w300))
        ],
      ),
    );
  }
}