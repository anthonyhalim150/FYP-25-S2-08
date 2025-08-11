import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserPreferencesService {
  static const String baseUrl = "http://YOUR_API_URL/user-preferences";
  static const storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>?> fetchPreferences() async {
    String? token = await storage.read(key: 'token');
    if (token == null) return null;

    final res = await http.get(
      Uri.parse(baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      return json.decode(res.body)['preferences'];
    }
    return null;
  }

  static Future<bool> updatePreferences(Map<String, dynamic> prefs) async {
    String? token = await storage.read(key: 'token');
    if (token == null) return false;

    final res = await http.put(
      Uri.parse("$baseUrl/update"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(prefs),
    );

    return res.statusCode == 200;
  }
}
