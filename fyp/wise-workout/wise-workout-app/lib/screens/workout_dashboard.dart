import 'package:flutter/material.dart';
import 'package:wise_workout_app/screens/workout_selection_screen.dart';
import 'package:wise_workout_app/widgets/workout_card_dashboard.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/app_drawer.dart';


class WorkoutDashboard extends StatefulWidget {
  @override
  _WorkoutDashboardState createState() => _WorkoutDashboardState();
}

class _WorkoutDashboardState extends State<WorkoutDashboard> {
  String selectedCategory = 'All';
  bool showFavoritesOnly = false;
  int _currentIndex = 2;
  String userName = 'John';

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
      'id': 1,
      'title': 'Strength Training',
      'subtitle': '9 Minutes | Advanced',
      'image': 'assets/workoutImages/strength_training.jpg',
      'isFavorite': false,
    },
    {
      'id': 2,
      'title': 'Home Yoga',
      'subtitle': '6 Minutes | Beginner',
      'image': 'assets/workoutImages/yoga_training.jpg',
      'isFavorite': false,
    },
    {
      'id': 3,
      'title': 'Core Training',
      'subtitle': '8 Minutes | Intermediate',
      'image': 'assets/workoutImages/core_training.jpg',
      'isFavorite': false,
    },
    {
      'id': 4,
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
        : workouts.where((workout) {
      return workout['subtitle']!
          .toLowerCase()
          .contains(selectedCategory.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: appDrawer(userName: userName, parentContext: context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 15),
                child: Row(
                  children: [
                    Text(
                      'Workout!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
                        selectedColor: Colors.blue, // Blue when selected
                        backgroundColor: Colors.grey[200], // Grey when not selected
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: StadiumBorder( // This makes it more oval
                          side: BorderSide(
                            color: isSelected ? Colors.blue : Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust padding for better shape
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
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
                        final int workoutID = workout['id'];
                        final String workoutName = workout['title'];
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => WorkoutScreen(
                              workoutID: workoutID,
                              workoutName: workoutName,
                            ),
                          ),
                        );
                      },
                      onToggleFavorite: () {
                        setState(() {
                          final originalIndex = workouts.indexWhere(
                                  (w) => w['title'] == workout['title']);
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
      ),
      bottomNavigationBar: bottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
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
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}