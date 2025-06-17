import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileEditService {
  final storage = const FlutterSecureStorage();
  final String baseUrl = 'http://10.0.2.2:3000';
  Future<bool> updateProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? dob,
  }) async {
    final cookie = await storage.read(key: 'jwt_cookie');
    if (cookie == null) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/user/update-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$cookie',
      },
      body: jsonEncode({
        if (username != null) 'username': username,
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (dob != null) 'dob': dob,
      }),
    );

    return response.statusCode == 200;
  }
}
