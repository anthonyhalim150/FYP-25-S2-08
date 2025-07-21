import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  }) : imageUrl = _generateImageUrl(categoryKey);

  static String _generateImageUrl(String categoryKey) {
    return 'assets/workoutCategory/${categoryKey.replaceAll(' ', '_').toLowerCase()}.jpg';
  }

  factory WorkoutCategory.fromJson(Map<String, dynamic> json) {
    return WorkoutCategory(
      categoryId: json['categoryId'].toString(),
      categoryName: json['categoryName'],
      categoryKey: json['categoryKey'],
      categoryDescription: json['categoryDescription'],
    );
  }
}

class WorkoutCategoryService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final _storage = const FlutterSecureStorage();

  Future<String?> _getJwtCookie() async {
    return await _storage.read(key: 'jwt_cookie');
  }

  /// Fetch all workout categories from backend
  Future<List<WorkoutCategory>> fetchCategories() async {
    try {
      final jwt = await _getJwtCookie();
      final response = await http.get(
        Uri.parse('$baseUrl/workout-categories'),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session=$jwt',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch workout categories');
      }

      final data = jsonDecode(response.body);
      return List<WorkoutCategory>.from(data.map((item) => WorkoutCategory.fromJson(item)));
    } catch (e, stackTrace) {
      print('❌ Error fetching categories: $e');
      print('🧱 Stack trace:\n$stackTrace');
      rethrow; // Optional: Rethrow to show error in UI
    }
  }


  /// Fetch a single category by key
  Future<WorkoutCategory?> getCategoryByKey(String categoryKey) async {
    final jwt = await _getJwtCookie();
    final response = await http.get(
      Uri.parse('$baseUrl/workout-categories/$categoryKey'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );

    if (response.statusCode == 404) return null;

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch category');
    }

    final item = jsonDecode(response.body);
    return WorkoutCategory.fromJson(item);
  }
}
