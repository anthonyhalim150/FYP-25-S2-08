import 'package:flutter/material.dart';
import 'analysis_screen.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCF2),

      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Workout History',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
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

          // 📝 Workout List or Empty State
          Expanded(
            child: workoutHistory.isEmpty
                ? const Center(
              child: Text(
                'No workout history yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
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
                            color: const Color(0xFF071655), size: 40),
                        const SizedBox(width: 14),
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
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.timer,
                                      size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    entry['duration'],
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                  const SizedBox(width: 15),
                                  Icon(Icons.local_fire_department,
                                      size: 16, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${entry['calories']} kcal",
                                    style: const TextStyle(
                                        color: Colors.amber,
                                        fontSize: 13),
                                  ),
                                  const SizedBox(width: 15),
                                  Icon(Icons.trending_up,
                                      size: 16,
                                      color: Colors.deepPurple),
                                  const SizedBox(width: 4),
                                  Text(
                                    entry['intensity'],
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.deepPurple),
                                  ),
                                ],
                              ),
                              if (entry['notes'] != null &&
                                  (entry['notes'] as String).isNotEmpty)
                                Padding(
                                  padding:
                                  const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    entry['notes'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black54,
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