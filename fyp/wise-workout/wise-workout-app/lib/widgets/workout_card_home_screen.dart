import 'package:flutter/material.dart';

class WorkoutCardHomeScreen extends StatelessWidget {
  final String imagePath;
  final String workoutName;
  final String workoutLevel;
  const WorkoutCardHomeScreen({
    super.key,
    required this.imagePath,
    required this.workoutName,
    required this.workoutLevel,
  });

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return Image.network(
        imagePath,
        height: 83,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Container(height: 83, color: Colors.grey[200], child: Icon(Icons.image_not_supported)),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            height: 83,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imagePath,
        height: 83,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color cardColor = colorScheme.surface;
    final Color shadowColor = Theme.of(context).shadowColor;
    final TextStyle? nameStyle = textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurface,
    );
    final TextStyle? levelStyle = textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: colorScheme.onSurfaceVariant,
    );
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: _buildImage(imagePath),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              workoutName,
              style: nameStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Text(
              workoutLevel,
              style: levelStyle,
            ),
          ),
        ],
      ),
    );
  }
}