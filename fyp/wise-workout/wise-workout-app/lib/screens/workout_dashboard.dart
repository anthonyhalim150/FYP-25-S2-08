import 'package:flutter/material.dart';
import 'package:wise_workout_app/widgets/workout_card_dashboard.dart';
import '../widgets/bottom_navigation.dart';

class WorkoutDashboard extends StatefulWidget {
  @override
  _WorkoutDashboardState createState() => _WorkoutDashboardState();
}

class _WorkoutDashboardState extends State<WorkoutDashboard> {
  String selectedCategory = 'All';
  bool showFavoritesOnly = false;


  final List<String> categories = [
    "All",
    "Beginner",
    "Intermediate",
    "Advanced",
    "HIIT",
    "Yoga"
  ];

  final List<Map<String, dynamic>> workouts = [
    {
      'title': 'Strength Training',
      'subtitle': '9 Minutes | Advanced',
      'image': 'assets/workoutImages/strength_training.jpg',
      'isFavorite': false,
    },
    {
      'title': 'Home Yoga',
      'subtitle': '6 Minutes | Beginner',
      'image': 'assets/workoutImages/yoga_training.jpg',
      'isFavorite': false,
    },
    {
      'title': 'Core Training',
      'subtitle': '8 Minutes | Intermediate',
      'image': 'assets/workoutImages/core_training.jpg',
      'isFavorite': false,
    },
    {
      'title': 'HIIT Blast',
      'subtitle': '5 Minutes | HIIT',
      'image': 'https://via.placeholder.com/300x150?text=HIIT+Blast',
      'isFavorite': false,
    },
  ];


  @override
  Widget build(BuildContext context) {
    final filteredWorkouts = selectedCategory == 'All'
        ? workouts
        : workouts
        .where((workout) => workout['subtitle']!
        .toLowerCase()
        .contains(selectedCategory.toLowerCase()))
        .toList();


    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Text("Workout", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.fitness_center, color: Colors.amber),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Chips (scrollable row)
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      selectedColor: Colors.orange,
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // Workout Cards List
            Expanded(
              child: ListView.builder(
                itemCount: filteredWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = filteredWorkouts[index];
                  return WorkoutCardDashboard(
                    title: workout['title'],
                    subtitle: workout['subtitle'],
                    imageUrl: workout['image'],
                    isFavorite: workout['isFavorite'],
                    onPressed: () {
                      Navigator.pushNamed(context, '/workout');
                    },
                    onToggleFavorite: () {
                      setState(() {
                        // Find the correct item in the original list
                        final originalIndex = workouts.indexWhere(
                              (w) => w['title'] == workout['title'],
                        );
                        if (originalIndex != -1) {
                          workouts[originalIndex]['isFavorite'] =
                          !(workouts[originalIndex]['isFavorite'] ?? false);
                        }
                      });
                    },

                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/leaderboard');
              break;
            case 2:
              Navigator.pushNamed(context, '/workout-dashboard');
              break;
            case 3:
              Navigator.pushNamed(context, '/messages');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),

    );
  }
}
