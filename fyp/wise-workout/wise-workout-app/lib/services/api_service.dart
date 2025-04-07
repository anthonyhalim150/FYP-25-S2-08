import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://10.0.2.2/api';

  Future<http.Response> getUserProfile(String token) {
    return http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> submitWorkoutData(Map<String, dynamic> data, String token) {
    return http.post(
      Uri.parse('$baseUrl/workout'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: data,
    );
  }
}
