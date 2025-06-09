import 'package:http/http.dart' as http;
import 'dart:convert';

class FitService {
  Future<Map<String, dynamic>> getSteps(String accessToken, DateTime start, DateTime end) async {
    final url = Uri.parse('https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "aggregateBy": [{
          "dataTypeName": "com.google.step_count.delta",
          "dataSourceId": "derived:com.google.step_count.delta:com.google.android.gms:estimated_steps"
        }],
        "bucketByTime": { "durationMillis": 86400000 }, // 1 day
        "startTimeMillis": start.millisecondsSinceEpoch,
        "endTimeMillis": end.millisecondsSinceEpoch,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch steps: ${response.body}");
    }
  }

  Future<int> getTodaySteps(String accessToken) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final data = await getSteps(accessToken, startOfDay, now);

    // Extract step count from API response
    try {
      final bucket = data['bucket'][0];
      final dataset = bucket['dataset'][0];
      final points = dataset['point'];

      if (points.isNotEmpty) {
        return points[0]['value'][0]['intVal'] ?? 0;
      }
      return 0;
    } catch (e) {
      print("Error parsing steps: $e");
      return 0;
    }
  }
}