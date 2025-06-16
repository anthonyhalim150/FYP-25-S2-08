import 'package:flutter/material.dart';
import 'package:wise_workout_app/screens/workout_selection_screen.dart';
import 'package:wise_workout_app/widgets/workout_card_dashboard.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/app_drawer.dart';
import '../services/workout_category_service.dart';


class WorkoutDashboard extends StatefulWidget {
  @override
  _WorkoutDashboardState createState() => _WorkoutDashboardState();
}

class _WorkoutDashboardState extends State<WorkoutDashboard> {
  final WorkoutCategoryService _categoryService = WorkoutCategoryService();

  late Future<List<WorkoutCategory>> _categoriesFuture;

  String selectedCategory = 'All';
  int _currentIndex = 2;
  String userName = 'John';

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoryService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: appDrawer(userName: userName, parentContext: context),
      body: SafeArea(
        child: FutureBuilder<List<WorkoutCategory>>(
          future: _categoriesFuture,
          builder: (context, catSnapshot) {
            if (catSnapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            if (catSnapshot.hasError) {
              return Center(child: Text('Error loading categories'));
            }

            // Build list of category names, including 'All'
            final categories = ['All'] +
                catSnapshot.data!.map((c) => c.categoryName).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                  child: Row(
                    children: [
                      Text(
                        'Workout!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.menu, color: Colors.black),
                          onPressed: () => Scaffold.of(context).openDrawer(),
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
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.grey[200],
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FutureBuilder<List<WorkoutCategory>>(
                    future: _categoriesFuture,
                    builder: (context, wkSnapshot) {
                      if (wkSnapshot.connectionState !=
                          ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (wkSnapshot.hasError) {
                        return Center(child: Text('Error loading workouts'));
                      }

                      // Filter workouts by selected category
                      final allWorkouts = wkSnapshot.data!;
                      final filtered = selectedCategory == 'All'
                          ? allWorkouts
                          : allWorkouts
                          .where((w) =>
                      w.categoryName.toLowerCase() ==
                          selectedCategory.toLowerCase())
                          .toList();

                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final workout = filtered[index];
                          return WorkoutCardDashboard(
                            title: workout.categoryTitle,
                            subtitle: workout.categoryDescription, // replace with real URL field
                            isFavorite: false,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => WorkoutScreen(
                                    workoutId: workout.categoryId,
                                    workoutName: workout.categoryTitle,
                                    categoryName: workout.categoryName,
                                    workoutKey: '',
                                  ),
                                ),
                              );
                            },
                            onToggleFavorite: () {
                              // handle favorite toggle if supported
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
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
