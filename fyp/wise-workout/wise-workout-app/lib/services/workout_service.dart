import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/model/workout_model.dart';

class WorkoutService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final _storage = const FlutterSecureStorage();

  Future<String?> _getJwtCookie() async {
    final cookie = await _storage.read(key: 'jwt_cookie');
    print('🍪 Retrieved JWT cookie: $cookie');
    return cookie;
  }

  /// Fetch all workouts
  Future<List<Workout>> fetchAllWorkouts() async {
    final jwt = await _getJwtCookie();
    final url = Uri.parse('$baseUrl/workouts');
    print('📡 Fetching ALL workouts → $url');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );

    print('🔵 Status Code: ${response.statusCode}');
    print('📩 Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch workouts');
    }

    final data = jsonDecode(response.body);
    return List<Workout>.from(data.map((item) => Workout.fromJson(item)));
  }

  /// Fetch workouts by category
  Future<List<Workout>> fetchWorkoutsByCategory(String categoryKey) async {
    final jwt = await _getJwtCookie();
    final url = Uri.parse('$baseUrl/workouts/category/$categoryKey');
    print('📡 Fetching workouts for category "$categoryKey" → $url');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );

    print('🔵 Status Code: ${response.statusCode}');
    print('📩 Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch category workouts');
    }

    final data = jsonDecode(response.body);
    return List<Workout>.from(data.map((item) => Workout.fromJson(item)));
  }

  /// Fetch single workout by ID
  Future<Workout> fetchWorkoutById(int workoutId) async {
    final jwt = await _getJwtCookie();
    final url = Uri.parse('$baseUrl/workouts/$workoutId');
    print('📡 Fetching workout by ID → $url');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );

    print('🔵 Status Code: ${response.statusCode}');
    print('📩 Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch workout');
    }

    final item = jsonDecode(response.body);
    return Workout.fromJson(item);
  }
}
