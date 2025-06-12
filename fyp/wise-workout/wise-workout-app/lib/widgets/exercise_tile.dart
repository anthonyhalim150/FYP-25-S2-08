import 'package:flutter/material.dart';
import '../services/workout_service.dart';

class ExerciseTile extends StatelessWidget {
  final Workout workout;
  final VoidCallback onTap;


  const ExerciseTile({Key? key, required this.workout, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = workout.imageUrl;
    final isNetwork = url.startsWith('http');

    return Column(
      children: [
      // "X Workouts Found" text box
      Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
    ),


    InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent, // Make container background transparent
        ),
        child: Row(
          children: [
            // Apply curved borders to all sides of the image
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // Curved borders on all sides
              child: isNetwork
                  ? Image.network(
                  url,
                  width: 186,
                  height: 140,
                  fit: BoxFit.cover
              )
                  : Image.asset(
                  url,
                  width: 186,
                  height: 140,
                  fit: BoxFit.cover
              ),
            ),
            SizedBox(width: 12), // Add spacing between image and text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800], // Darker text for better readability
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      workout.description,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[700],
                        height: 1.4, // Better line spacing
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${workout.duration} Minutes',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange, // Highlight duration
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
    ),
      ),
    ],);
  }
}