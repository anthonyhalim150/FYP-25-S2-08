import 'package:flutter/material.dart';
import 'analysis_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  // Hardcoded for now; replace with data from backend when ready
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        backgroundColor: const Color(0xFF071655),
      ),
      backgroundColor: const Color(0xFFFAF6EE),
      body: workoutHistory.isEmpty
          ? const Center(
        child: Text(
          'No workout history yet.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
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
                    // Pass extraStats here if you want
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.07),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(entry['icon'] as IconData, color: Color(0xFF071655), size: 38),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry['date'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF071655),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry['workout'],
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(Icons.timer, size: 16, color: Colors.grey),
                            const SizedBox(width: 2),
                            Text(entry['duration'],
                                style: const TextStyle(color: Colors.grey, fontSize: 13)),
                            const SizedBox(width: 15),
                            Icon(Icons.local_fire_department, size: 16, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text("${entry['calories']} kcal",
                                style: const TextStyle(color: Colors.amber, fontSize: 13)),
                            const SizedBox(width: 15),
                            Icon(Icons.trending_up, size: 15, color: Colors.deepPurple),
                            const SizedBox(width: 2),
                            Text(
                              entry['intensity'],
                              style: const TextStyle(fontSize: 13, color: Colors.deepPurple),
                            )
                          ],
                        ),
                        if (entry['notes'] != null && (entry['notes'] as String).isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: Text(
                              entry['notes'],
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
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
    );
  }
}