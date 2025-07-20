import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/model/workout_model.dart'; // Update with your path

class WorkoutService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final _storage = const FlutterSecureStorage();

  Future<String?> _getJwtCookie() async {
    return await _storage.read(key: 'jwt_cookie');
  }

  /// Fetch all workouts
  Future<List<Workout>> fetchAllWorkouts() async {
    final jwt = await _getJwtCookie();
    final response = await http.get(
      Uri.parse('$baseUrl/workouts'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch workouts');
    }

    final data = jsonDecode(response.body);
    return List<Workout>.from(data.map((item) => Workout(
      workoutId: item['workoutId'].toString(),
      categoryKey: item['categoryKey'],
      exerciseKey: item['exerciseKey'],
      workoutName: item['workoutName'],
      workoutLevel: item['workoutLevel'],
      workoutDescription: item['workoutDescription'],
    )));
  }

  /// Fetch workouts by category
  Future<List<Workout>> fetchWorkoutsByCategory(String categoryKey) async {
    final jwt = await _getJwtCookie();
    final response = await http.get(
      Uri.parse('$baseUrl/workouts/category/$categoryKey'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch category workouts');
    }

    final data = jsonDecode(response.body);
    return List<Workout>.from(data.map((item) => Workout(
      workoutId: item['workoutId'].toString(),
      categoryKey: item['categoryKey'],
      exerciseKey: item['exerciseKey'],
      workoutName: item['workoutName'],
      workoutLevel: item['workoutLevel'],
      workoutDescription: item['workoutDescription'],
    )));
  }

  /// Fetch single workout by ID (if needed for detail page)
  Future<Workout> fetchWorkoutById(String workoutId) async {
    final jwt = await _getJwtCookie();
    final response = await http.get(
      Uri.parse('$baseUrl/workouts/$workoutId'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch workout');
    }

    final item = jsonDecode(response.body);
    return Workout(
      workoutId: item['workoutId'].toString(),
      categoryKey: item['categoryKey'],
      exerciseKey: item['exerciseKey'],
      workoutName: item['workoutName'],
      workoutLevel: item['workoutLevel'],
      workoutDescription: item['workoutDescription'],
    );
  }
}
