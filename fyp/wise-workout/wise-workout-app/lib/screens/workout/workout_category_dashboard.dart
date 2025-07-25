import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../services/workout_category_service.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/workout_card_dashboard.dart';

class WorkoutCategoryDashboard extends StatefulWidget {
  @override
  _WorkoutCategoryDashboardState createState() => _WorkoutCategoryDashboardState();
}

class _WorkoutCategoryDashboardState extends State<WorkoutCategoryDashboard> {
  int _currentIndex = 2;
  String? _selectedCategory;
  late Future<List<WorkoutCategory>> _categoryFuture;
  List<WorkoutCategory> _allCategories = [];

  @override
  void initState() {
    super.initState();
    _categoryFuture = WorkoutCategoryService().fetchCategories();
  }

  void _filterByCategory(String? categoryKey) {
    setState(() {
      _selectedCategory = categoryKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'workout_categories'.tr(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FutureBuilder<List<WorkoutCategory>>(
              future: _categoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('error'.tr() + ': ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('no_categories'.tr()));
                }

                _allCategories = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _filterByCategory(null);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: _selectedCategory == null
                                ? Colors.lightBlueAccent
                                : Colors.white10,
                          ),
                          child: Text(
                            'all'.tr(),
                            style: TextStyle(
                              color: _selectedCategory == null
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      ..._allCategories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _filterByCategory(category.categoryKey);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: _selectedCategory == category.categoryKey
                                  ? Colors.lightBlueAccent
                                  : Colors.white10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  category.categoryName,
                                  style: TextStyle(
                                    color: _selectedCategory == category.categoryKey
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                if (_selectedCategory == category.categoryKey)
                                  const Icon(Icons.check, color: Colors.white, size: 18),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: FutureBuilder<List<WorkoutCategory>>(
              future: _categoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('error'.tr() + ': ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('no_categories_found'.tr()));
                }

                final filteredCategories = _selectedCategory == null
                    ? snapshot.data!
                    : snapshot.data!
                    .where((c) => c.categoryKey == _selectedCategory)
                    .toList();

                return ListView.builder(
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    return WorkoutCardDashboard(
                      title: category.categoryName,
                      subtitle: category.categoryDescription,
                      isFavorite: false,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/workout-list-page',
                          arguments: {
                            'categoryKey': category.categoryKey,
                          },
                        );
                      },
                      onToggleFavorite: () {},
                    );
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
