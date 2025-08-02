import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../screens/model/workout_day_model.dart';
import '../screens/model/exercise_model.dart';

class AIFitnessPlanService {
  final secureStorage = const FlutterSecureStorage();
  final baseUrl = 'http://10.0.2.2:3000';

  Future<Map<String, dynamic>> fetchPlanFromDB() async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');
    final res = await http.post(
      Uri.parse('$baseUrl/ai/fitness-plan'),
      headers: {
        'Cookie': 'session=$jwt',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final aiText = data['ai']['choices'][0]['message']['content'];
      final plan = jsonDecode(aiText);
      return {
        'plan': plan,
        'preferences': data['preferences'],
      };
    } else {
      throw Exception('Failed to fetch AI fitness plan');
    }
  }

  Future<Map<String, dynamic>> fetchPreferencesOnly() async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');
    final res = await http.get(
      Uri.parse('$baseUrl/user/preferences/'),
      headers: {
        'Cookie': 'session=$jwt',
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['preferences'];
    } else {
      throw Exception('Failed to fetch preferences');
    }
  }


  Future<void> savePlanToBackend(String planTitle, List<WorkoutDay> workoutDays) async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');
    final res = await http.post(
      Uri.parse('$baseUrl/workout-plans/save'),
      headers: {
        'Cookie': 'session=$jwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "planTitle": planTitle,
        "days": workoutDays.map((d) => d.toJson()).toList(),
      }),
    );
    if (res.statusCode != 201) {
      throw Exception('Failed to save plan');
    }
  }

  Future<Map<String, dynamic>> fetchSavedPlanFromBackend() async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');
    final res = await http.get(
      Uri.parse('$baseUrl/workout-plans/my-plans'),
      headers: {
        'Cookie': 'session=$jwt',
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      // data: List of plans!
      return {
        'plan': data, // <-- This is a List!
      };
    } else {
      throw Exception('Failed to fetch saved plan');
    }
  }


}

extension AIFitnessPlanParsing on AIFitnessPlanService {
  List<WorkoutDay> parsePlanToModels(dynamic planJson) {
    if (planJson is List) {
      // Skip the first object if it's plan_title
      final daysList = planJson.length > 1 && planJson[0]['plan_title'] != null
          ? planJson.sublist(1)
          : planJson;

      return daysList.map<WorkoutDay>((dayJson) {
        final exercises = (dayJson['exercises'] as List?)
            ?.map<Exercise>((e) => Exercise.fromAiJson(e))
            .toList() ?? [];
        return WorkoutDay(
          dayOfMonth: dayJson['day_of_month'],
          exercises: exercises,
          notes: dayJson['notes'] ?? '',
          isRest: dayJson['rest'] ?? false,
        );
      }).toList();
    }
    throw Exception('Plan format not recognized');
  }
}

