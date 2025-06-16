// workout_category_service.dart
import 'dart:async';

// Model representing a workout category
class WorkoutCategory {
  final int categoryId;
  final String categoryName;
  final String categoryTitle;
  final String categoryDescription;

  WorkoutCategory({
    required this.categoryId,
    required this.categoryTitle,
    required this.categoryName,
    required this.categoryDescription,
  });
}

// Service that fetches all workout categories
class WorkoutCategoryService {
  Future<List<WorkoutCategory>> fetchCategories() async {
    await Future.delayed(Duration(milliseconds: 300)); // simulate delay

    return [
      WorkoutCategory(
        categoryId: 1,
        categoryTitle: 'Push',
        categoryName: 'strength',
        categoryDescription: 'Workouts focused on building muscle strength using resistance training.',
      ),
      WorkoutCategory(
        categoryId: 2,
        categoryTitle: 'Relaxing',
        categoryName: 'yoga',
        categoryDescription: 'Workouts aimed at improving flexibility, balance, and mindfulness.',
      ),
      WorkoutCategory(
        categoryId: 3,
        categoryTitle: 'Leg Workout',
        categoryName: 'leg',
        categoryDescription: 'Workouts focused on back and biceps',
      ),
      WorkoutCategory(
        categoryId: 4,
        categoryTitle: 'Cardio Burn',
        categoryName: 'cardio',
        categoryDescription: 'Steady-state and interval cardio exercises.',
      ),
      // You can add more categories here
    ];
  }

  // Get a category by name
  Future<WorkoutCategory?> getCategoryByName(String name) async {
    final categories = await fetchCategories();
    try {
      return categories.firstWhere((cat) => cat.categoryName == name);
    } catch (e) {
      return null;
    }
  }
}
