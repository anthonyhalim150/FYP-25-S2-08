import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class QuestionnaireService {
  final backendUrl = 'http://10.0.2.2:3000';
  final storage = FlutterSecureStorage();

  Future<bool> submitPreferences(Map<String, dynamic> responses) async {
  final jwt = await storage.read(key: 'jwt_cookie');
  if (jwt == null) {
    print('JWT not found in secure storage');
    return false;
  }

  final response = await http.post(
    Uri.parse('$backendUrl/questionnaire/submit'),
    headers: {
      'Content-Type': 'application/json',
      'Cookie': 'session=$jwt',
    },
    body: jsonEncode(responses),
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  return response.statusCode == 200;
 }

}
