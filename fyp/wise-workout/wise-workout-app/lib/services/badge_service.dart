import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BadgeService {
  final String backendUrl = 'http://10.0.2.2:3000';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<List<dynamic>> getAllBadges() async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');
    if (jwt == null) {
      throw Exception('JWT not found in secure storage');
    }
    final res = await http.get(
      Uri.parse('$backendUrl/badges/all'),
      headers: {'Cookie': 'session=$jwt'},
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to load all badges');
    }
  }

  Future<List<dynamic>> getUserBadges() async {
    final jwt = await secureStorage.read(key: 'jwt_cookie');
    if (jwt == null) {
      throw Exception('JWT not found in secure storage');
    }
    final res = await http.get(
      Uri.parse('$backendUrl/badges/mine'),
      headers: {'Cookie': 'session=$jwt'},
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to load user badges');
    }
  }
}
