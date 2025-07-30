import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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

  Future<void> savePlanToBackend(List<dynamic> plan) async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');
    final res = await http.post(
      Uri.parse('$baseUrl/workout-plans/save-plan'),
      headers: {
        'Cookie': 'session=$jwt',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"plan": plan}),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to save plan');
    }
  }

}
