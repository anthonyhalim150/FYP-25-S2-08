import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/model/exercise_model.dart';

class ExerciseService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final _storage = const FlutterSecureStorage();

  Future<String?> _getJwtCookie() async {
    final cookie = await _storage.read(key: 'jwt_cookie');
    return cookie;
  }

  Future<List<Exercise>> fetchAllExercises() async {
    final jwt = await _getJwtCookie();
    final url = Uri.parse('$baseUrl/exercises');
    print('📡 Fetching ALL exercises → $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session=$jwt',
        },
      );

      print('🔵 Status Code: ${response.statusCode}');
      print('📩 Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch exercises');
      }

      final data = jsonDecode(response.body);
      return List<Exercise>.from(data.map((item) => Exercise.fromJson(item)));
    } catch (e) {
      print('❌ fetchAllExercises ERROR: $e');
      rethrow;
    }
  }

  Future<List<Exercise>> fetchExercisesByWorkoutId(int workoutId) async {
    final jwt = await _getJwtCookie();
    final url = Uri.parse('$baseUrl/exercises/workout/$workoutId');
    print('📡 Fetching exercises by workoutId → $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session=$jwt',
        },
      );

      print('🔵 Status Code: ${response.statusCode}');
      print('📩 Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch exercises for this workout');
      }

      final data = jsonDecode(response.body);
      return List<Exercise>.from(data.map((item) => Exercise.fromJson(item)));
    } catch (e) {
      print('❌ fetchExercisesByWorkoutId ERROR: $e');
      rethrow;
    }
  }

  Future<List<Exercise>> fetchExercisesByWorkout(String workoutId) async {
    final jwt = await _getJwtCookie();
    final url = Uri.parse('$baseUrl/exercises/workout/$workoutId');
    print('📡 Fetching exercises for workout $workoutId → $url');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );

    print('🔵 Status Code: ${response.statusCode}');
    print('📩 Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch exercises');
    }

    final data = jsonDecode(response.body);

    try {
      return List<Exercise>.from(data.map((item) {
        print('🧪 Mapping exercise: $item');
        return Exercise.fromJson(item);
      }));
    } catch (e, stack) {
      print('❌ Parsing error: $e');
      print(stack);
      rethrow;
    }
  }


  Future<Exercise> fetchExerciseById(int exerciseId) async {
    final jwt = await _getJwtCookie();
    final url = Uri.parse('$baseUrl/exercises/$exerciseId');
    print('📡 Fetching exercise by ID → $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'session=$jwt',
        },
      );

      print('🔵 Status Code: ${response.statusCode}');
      print('📩 Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to fetch exercise');
      }

      final item = jsonDecode(response.body);
      return Exercise.fromJson(item);
    } catch (e) {
      print('❌ fetchExerciseById ERROR: $e');
      rethrow;
    }
  }
}
