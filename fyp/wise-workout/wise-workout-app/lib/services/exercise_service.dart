import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/model/exercise_model.dart';

class ExerciseService {
  final String baseUrl = 'http://10.0.2.2:3000'; // Update with the actual backend URL
  final _storage = const FlutterSecureStorage();

  Future<String?> _getJwtCookie() async {
    return await _storage.read(key: 'jwt_cookie');
  }

  /// Fetch all exercises from the server
  Future<List<Exercise>> fetchAllExercises() async {
    final jwt = await _getJwtCookie();
    final response = await http.get(
      Uri.parse('$baseUrl/exercises'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch exercises');
    }

    final data = jsonDecode(response.body);
    return List<Exercise>.from(data.map((item) => Exercise.fromJson(item)));
  }

  /// Fetch exercises by workoutId
  Future<List<Exercise>> fetchExercisesByWorkoutId(int workoutId) async {
    final jwt = await _getJwtCookie();
    final response = await http.get(
      Uri.parse('$baseUrl/exercises/workout/$workoutId'), // Fetch exercises by workoutId
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch exercises for this workout');
    }

    final data = jsonDecode(response.body);
    return List<Exercise>.from(data.map((item) => Exercise.fromJson(item)));
  }

  /// Fetch a single exercise by exerciseId
  Future<Exercise> fetchExerciseById(int exerciseId) async {
    final jwt = await _getJwtCookie();
    final response = await http.get(
      Uri.parse('$baseUrl/exercises/$exerciseId'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch exercise');
    }

    final item = jsonDecode(response.body);
    return Exercise.fromJson(item);
  }
}
