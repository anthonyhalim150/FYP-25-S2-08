import 'package:flutter/material.dart';
import '../model/workout_model.dart';  // Import the shared Workout model
import '../../widgets/bottom_navigation.dart';
import '../../widgets/workout_card_dashboard.dart';

class WorkoutCategory {
  final String categoryId;
  final String categoryName;
  final String categoryKey;
  final String categoryDescription;
  final String imageUrl;

  WorkoutCategory({
    required this.categoryId,
    required this.categoryName,
    required this.categoryKey,
    required this.categoryDescription,
  }) : imageUrl = _generateImageUrl(categoryName);

  static String _generateImageUrl(String categoryName) {
    return 'assets/workoutCategory/${categoryName.replaceAll(' ', '_').toLowerCase()}.jpg';
  }
}

class WorkoutCategoryDashboard extends StatefulWidget {
  @override
  _WorkoutCategoryDashboardState createState() =>
      _WorkoutCategoryDashboardState();
}

class _WorkoutCategoryDashboardState extends State<WorkoutCategoryDashboard> {
  int _currentIndex = 0;
  String? _selectedCategory;

  final List<WorkoutCategory> categories = [
    WorkoutCategory(
      categoryId: '1',
      categoryName: 'Push',
      categoryKey: 'push',
      categoryDescription: 'Workouts focusing on pushing movements.',
    ),
    WorkoutCategory(
      categoryId: '2',
      categoryName: 'Cardio',
      categoryKey: 'cardio',
      categoryDescription: 'Workouts focusing on cardio and fat burning.',
    ),
    WorkoutCategory(
      categoryId: '3',
      categoryName: 'Leg Workout',
      categoryKey: 'leg',
      categoryDescription: 'Workouts focusing on legs.',
    ),
    WorkoutCategory(
      categoryId: '4',
      categoryName: 'Relaxing',
      categoryKey: 'relaxing',
      categoryDescription: 'Yoga and relaxation.',
    ),
  ];

  // Function to handle category filter
  void _filterByCategory(String? categoryKey) {
    setState(() {
      _selectedCategory = categoryKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter categories if a category is selected
    final filteredCategories = _selectedCategory == null
        ? categories
        : categories.where((category) => category.categoryKey == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Custom AppBar with back arrow, title, and logo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);  // Go back to the previous screen
                  },
                ),
                Text(
                  'Workout Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Display the logo (Image.asset) once you have the image
              ],
            ),
          ),
          // Filter buttons row below the AppBar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // "All" button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _filterByCategory(null); // Show all categories when "All" is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Make the button rounder
                        ),
                        backgroundColor: _selectedCategory == null
                            ? Colors.lightBlueAccent
                            : Colors.white10, // Highlight "All" when selected
                      ),
                      child: Text(
                        'All',
                        style: TextStyle(
                          color: _selectedCategory == null
                              ? Colors.white // White text for selected category
                              : Colors.black, // Black text for unselected categories
                        ),
                      ),
                    ),
                  ),
                  // Category buttons
                  ...categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _filterByCategory(category.categoryKey);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Make the button rounder
                          ),
                          backgroundColor: _selectedCategory == category.categoryKey
                              ? Colors.lightBlueAccent
                              : Colors.white10, // Highlight selected category
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              category.categoryName,
                              style: TextStyle(
                                color: _selectedCategory == category.categoryKey
                                    ? Colors.white // White text for selected category
                                    : Colors.black, // Black text for unselected categories
                              ),
                            ),
                            // Add checkmark if selected
                            if (_selectedCategory == category.categoryKey)
                              Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          // ListView of filtered categories
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return WorkoutCardDashboard(
                  title: category.categoryName,
                  subtitle: category.categoryDescription,
                  isFavorite: false,
                  onPressed: () {
                    // Navigate to the workout list page when a category is tapped
                    Navigator.pushNamed(
                      context,
                      '/workout-list-page',
                      arguments: {
                        'categoryKey': category.categoryKey, // Only pass categoryKey
                      },
                    );

                  },
                  onToggleFavorite: () {
                    // Handle favorite toggle logic here (optional)
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/leaderboard');
              break;
            case 2:
              Navigator.pushNamed(context, '/workout-category-dashboard');
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
