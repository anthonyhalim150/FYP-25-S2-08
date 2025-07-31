import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChallengeService {
  final String baseUrl = 'http://10.0.2.2:3000';
  final _storage = const FlutterSecureStorage();

  Future<String?> _getJwtCookie() async {
    return await _storage.read(key: 'jwt_cookie');
  }

  // Fetch list of challenges received (pending invitations)
  Future<List<dynamic>> getInvitations() async {
    final jwt = await _getJwtCookie();
    final response = await http.get(
      Uri.parse('$baseUrl/challenges/received'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch invitations');
    }
    return jsonDecode(response.body);
  }

  // Fetch list of accepted challenges
  Future<List<dynamic>> getAcceptedChallenges() async {
    final jwt = await _getJwtCookie();
    final response = await http.get(
      Uri.parse('$baseUrl/challenges/accepted'), // You'll need to implement this route/backend
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch accepted challenges');
    }
    return jsonDecode(response.body);
  }

  // Accept a challenge invite
  Future<void> acceptChallenge(int challengeId) async {
    final jwt = await _getJwtCookie();
    final response = await http.post(
      Uri.parse('$baseUrl/challenges/respond'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
      body: jsonEncode({
        'challengeId': challengeId,
        'action': 'accept',
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to accept challenge');
    }
  }

  // Reject a challenge invite
  Future<void> rejectChallenge(int challengeId) async {
    final jwt = await _getJwtCookie();
    final response = await http.post(
      Uri.parse('$baseUrl/challenges/respond'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
      body: jsonEncode({
        'challengeId': challengeId,
        'action': 'reject',
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to reject challenge');
    }
  }

  Future<void> sendChallenge({
    required int receiverId, // <- use int, not String
    required String title,
    required String target,
    required String duration,
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

  Future<List<dynamic>> getReceivedChallenges() async {
    final jwt = await _getJwtCookie();
    final response = await http.get(
      Uri.parse('$baseUrl/challenges/received'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch challenges');
    }

    return jsonDecode(response.body);
  }

  Future<void> respondToChallenge({
    required int challengeId,
    required String action, // 'accept' or 'reject'
  }) async {
    final jwt = await _getJwtCookie();
    final response = await http.post(
      Uri.parse('$baseUrl/challenges/respond'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
      },
      body: jsonEncode({
        'challengeId': challengeId,
        'action': action,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
