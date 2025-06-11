import 'package:health/health.dart';

class HealthService {
  final Health _health = Health();

  Future<bool> connect() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];
    final permissions = types.map((e) => HealthDataAccess.READ).toList();

    try {

      return await _health.requestAuthorization(types, permissions: permissions);
    } on UnsupportedError catch (_) {

      print('Health Connect not available. Prompting user to install.');
      await _health.installHealthConnect();
      return false;
    } catch (e) {
      print('Error connecting to Health Connect: $e');
      return false;
    }
  }

  Future<int> getTodaySteps() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    try {
      final totalSteps = await _health.getTotalStepsInInterval(startOfDay, now);
      return totalSteps ?? 0;
    } catch (e) {
      print('Error fetching today\'s steps: $e');
      return 0;
    }
  }

  Future<List<HealthDataPoint>> getHealthData(DateTime start, DateTime end) async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    try {
      final data = await _health.getHealthDataFromTypes(
        types: types,
        startTime: start,
        endTime: end,
      );
      return data;
    } catch (e) {
      print('Error fetching health data: $e');
      return [];
    }
  }
}
