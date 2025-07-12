import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String backendUrl = 'http://10.0.2.2:3000';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<Map<String, dynamic>> getCurrentProfile() async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');
    if (jwt == null) {
      throw Exception('JWT not found in secure storage');
    }

    final res = await http.get(
      Uri.parse('$backendUrl/user/current-profile'),
      headers: {'Cookie': 'session=$jwt'},
    );

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
       throw Exception('Failed to load profile');
    }
  }

  Future<void> setAvatar(int avatarId) async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');
    if (jwt == null) {
      throw Exception('JWT not found in secure storage');
    }

    final res = await http.post(
      Uri.parse('$backendUrl/user/set-avatar'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
      body: jsonEncode({'avatarId': avatarId}),
    );

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('Failed to set avatar');
    }
  }

  Future<void> setBackground(int backgroundId) async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');
    if (jwt == null) {
      throw Exception('JWT not found in secure storage');
    }

    final res = await http.post(
      Uri.parse('$backendUrl/user/set-background'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
      body: jsonEncode({'backgroundId': backgroundId}),
    );

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('Failed to set background');
    }
  }

  Future<Map<String, dynamic>> getCurrentBackground() async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');
    if (jwt == null) {
      throw Exception('JWT not found in secure storage');
    }

    final res = await http.get(
      Uri.parse('$backendUrl/user/current-background'),
      headers: {'Cookie': 'session=$jwt'},
    );

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to load current background');
    }
  }
}
