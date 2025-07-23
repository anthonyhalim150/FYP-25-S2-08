import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PremiumService {
  final backendUrl = 'http://10.0.2.2:3000'; 
  final storage = FlutterSecureStorage();

  Future<bool> buyPremiumWithTokens(String plan) async {
    final jwt = await storage.read(key: 'jwt_cookie');
    if (jwt == null) return false;
    final response = await http.post(
        Uri.parse('$backendUrl/user/buy-premium'),
        headers: {
        'Content-Type': 'application/json',
        'Cookie': 'session=$jwt',
        },
        body: jsonEncode({
        'type': 'premium_token',
        'plan': plan, // monthly, annual, lifetime
        }),
    );
    return response.statusCode == 200;
    }
}
