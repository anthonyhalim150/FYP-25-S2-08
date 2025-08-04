import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/model/workout_model.dart';

class WorkoutService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final _storage = const FlutterSecureStorage();

  Future<String?> _getJwtCookie() async {
    final cookie = await _storage.read(key: 'jwt_cookie');
    return cookie;
  }

  /// Fetch all workouts
  Future<List<Workout>> fetchAllWorkouts() async {
    final jwt = await _getJwtCookie();
    final url = Uri.parse('$baseUrl/workouts');
    final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'session=$jwt',
          },
    );
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
    final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'session=$jwt',
          },
    );
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
    final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'session=$jwt',
          },
        );
    if (response.statusCode != 200) {
          throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch workout');
        }

    final item = jsonDecode(response.body);
    return Workout.fromJson(item);
  }


  Future<void> saveWorkoutSession({
    int? workoutId,
    DateTime? startTime,
    DateTime? endTime,
    int? duration, // in seconds
    double? caloriesBurned,
    String? notes,
    List<Map<String, dynamic>> exercises = const [],
  }) async {
    final jwt = await _getJwtCookie();
    final url = Uri.parse('$baseUrl/workout-sessions/sessions');
    
    final requestBody = {
      'workoutId': workoutId,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'notes': notes,
      'exercises': exercises,
    };
    final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'session=$jwt',
          },
          body: jsonEncode(requestBody),
        );
    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to save workout session');
    }
  }

  Future<List<dynamic>> fetchUserWorkoutSessions() async {
    final jwt = await _getJwtCookie();
    final url = Uri.parse('$baseUrl/workout-sessions/sessions');
    final response = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'session=$jwt',
          },
        );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch workout sessions');
    }

    final data = jsonDecode(response.body);
    return data;
  }
}
