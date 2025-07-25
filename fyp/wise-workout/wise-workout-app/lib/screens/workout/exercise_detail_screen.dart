import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../model/exercise_model.dart';
import 'exercise_video_tutorial.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 280,
            backgroundColor: Colors.grey[800],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    _getExerciseImagePath(exercise.exerciseName),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.fitness_center, size: 100,
                              color: Colors.grey),
                        ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 16,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print('📦 Exercise object being passed: ${exercise.exerciseName}');
                        print('🎥 YouTube URL: ${exercise.youtubeUrl}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseVideoTutorial(exercise: exercise),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text('exercise_play_tutorial').tr(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildDetailContent(context),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/exercise-log',
              arguments: exercise, // pass Exercise object
            );
          },
          icon: const Icon(Icons.photo_camera),
          label: Text("exercise_start_button").tr(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.exerciseName,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        _buildSectionTitle('exercise_overview'.tr()),
        Text(exercise.exerciseDescription),

        const SizedBox(height: 16),
        _buildSectionTitle('exercise_expect'.tr()),
        Text(
          '- Full-body warm-up\n'
              '- Strength moves (e.g., push-ups, squats, planks)\n'
              '- Balance, endurance & posture\n'
              '- Cooldown with mobility work',
        ),

        const SizedBox(height: 16),
        if (exercise.exerciseLevel != null &&
            exercise.exerciseLevel!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('exercise_level'.tr()),
              Text(exercise.exerciseLevel!),
              const SizedBox(height: 16),
            ],
          ),

        if (exercise.exerciseEquipment != null &&
            exercise.exerciseEquipment!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('exercise_equipment'.tr()),
              Text(exercise.exerciseEquipment!),
              const SizedBox(height: 16),
            ],
          ),

        _buildSectionTitle('exercise_instructions'.tr()),
        ..._buildInstructionList(exercise.exerciseInstructions),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        decoration: TextDecoration.underline,
      ),
    );
  }

  List<Widget> _buildInstructionList(String instructions) {
    final parts = instructions.split(RegExp(r'\n|\r'));
    return List.generate(parts.length, (i) {
      return Text('${i + 1}. ${parts[i]}');
    });
  }

  String _getExerciseImagePath(String exerciseTitle) {
    final formatted = exerciseTitle.toLowerCase().replaceAll(' ', '_');
    return 'assets/exerciseGif/${formatted}.gif';
  }
}
