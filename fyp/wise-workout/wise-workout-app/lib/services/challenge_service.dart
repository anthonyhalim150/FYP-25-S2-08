import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChallengeService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final _storage = const FlutterSecureStorage();

  Future<String?> _getJwtCookie() async {
    return await _storage.read(key: 'jwt_cookie');
  }

  Future<void> sendChallenge({
    required int receiverId,
    required String title,
    required String target,
    required int duration,
  }) async {
    final jwt = await _getJwtCookie();
    final response = await http.post(
      Uri.parse('$baseUrl/challenges/send'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
      body: jsonEncode({
        'receiverId': receiverId,
        'title': title,
        'target': target,
        'duration': duration,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<List<Map<String, dynamic>>> getInvitations() async {
    final jwt = await _getJwtCookie();
    final response = await http.get(
      Uri.parse('$baseUrl/challenges/invitations'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load invitations');
    }
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  }

  Future<List<Map<String, dynamic>>> getAcceptedChallenges() async {
    final jwt = await _getJwtCookie();
    final response = await http.get(
      Uri.parse('$baseUrl/challenges/accepted'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load accepted challenges');
    }
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  }

  Future<void> acceptChallenge(int challengeId) async {
    final jwt = await _getJwtCookie();
    final response = await http.post(
      Uri.parse('$baseUrl/challenges/$challengeId/accept'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<void> rejectChallenge(int challengeId) async {
    final jwt = await _getJwtCookie();
    final response = await http.post(
      Uri.parse('$baseUrl/challenges/$challengeId/reject'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}