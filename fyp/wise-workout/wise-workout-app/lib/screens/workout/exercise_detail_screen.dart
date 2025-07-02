import 'package:flutter/material.dart';
import 'package:wise_workout_app/services/exercise_service.dart';
import '../../widgets/workout_session_timer_overlay.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  String _getExerciseGifPath(String exerciseTitle) {
    final formattedName = exerciseTitle.toLowerCase().replaceAll(' ', '_');
    return 'assets/exerciseGif/$formattedName.gif';
  }

  @override
  Widget build(BuildContext context) {
    final gifPath = _getExerciseGifPath(exercise.title);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4ED),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      gifPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF688EA3),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.white, size: 50),
                                SizedBox(height: 10),
                                Text(
                                  'GIF not found',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      left: 200,
                      bottom: 16,
                      child: ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        label: const Text(
                          'Play Tutorial Video',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.withOpacity(0.8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),


          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Exercise Title
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    exercise.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ),

                // Divider
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                  height: 10,
                ),

                // Overview Section
                _buildSection("Overview", exercise.description),

                const SizedBox(height: 24),

                // Trainer Level
                _buildSection("Trainer Level", exercise.level),

                const SizedBox(height: 24),

                // Equipment
                _buildSection("Equipment", exercise.equipment),

                const SizedBox(height: 24),

                // Instructions
                _buildSection("Instructions", exercise.instructions),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),

      // Start Exercise Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/exercise-start-screen',
              arguments: exercise,
            );
            final startTime = DateTime.now();
            final overlay = Overlay.of(context);
            late OverlayEntry timerEntry;

            timerEntry = OverlayEntry(
              builder: (context) => WorkoutSessionTimerOverlay(
                startTime: startTime,
                onEndSession: (duration) {
                  timerEntry.remove(); // Remove popup
                  Navigator.of(context).pushNamed('/workout-analysis', arguments: {
                    'duration': duration,
                    'startTime': startTime,
                  });
                },
              ),
            );

            overlay.insert(timerEntry);

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Start Exercise',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 18,
            height: 1.5,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}