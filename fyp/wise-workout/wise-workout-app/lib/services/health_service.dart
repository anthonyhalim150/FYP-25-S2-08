import 'package:health/health.dart';

class HealthService {
  final Health _health = Health();

  Future<bool> connect() async {
    try {
      await _health.configure();

      final types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.ACTIVE_ENERGY_BURNED,
      ];
      final permissions = types.map((e) => HealthDataAccess.READ).toList();

      return await _health.requestAuthorization(types, permissions: permissions);
    } on UnsupportedError {
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
    print('DAPET steps');

    try {
      final totalSteps = await _health.getTotalStepsInInterval(startOfDay, now);
      return totalSteps ?? 0;
    } catch (e) {
      print('Error fetching today\'s steps: $e');
      return 0;
    }
  }

  Future<int> getTodayCalories() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    print('Fetching calories from $startOfDay to $now');

    try {
      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: startOfDay,
        endTime: now,
        // REMOVE filters for now
        // recordingMethodsToFilter: [],
      );

      print('🧠 CALORIE RECORD COUNT: ${data.length}');
      for (final point in data) {
        print('🔥 ${point.value} kcal | ${point.sourceName} | ${point.dateFrom} → ${point.dateTo}');
      }

      final total = data.fold<double>(0.0, (prev, point) {
        return prev + (point.value is double
            ? point.value as double
            : (point.value as int).toDouble());
      });

      return total.round();
    } catch (e) {
      print("❌ Error fetching today's calories: $e");
      return 0;
    }
  }

  Future<List<HealthDataPoint>> getTodayHeartRateData() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    print('DAPET HR');

    try {
      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: startOfDay,
        endTime: now,
      );

      return data;
    } catch (e) {
      print("Error fetching today's heart rate data: $e");
      return [];
    }
  }






  Future<List<int>> getHourlyStepsForToday() async {
    final now = DateTime.now();
    List<int> hourlySteps = List.filled(24, 0);
    print("Fetching hourly steps...");

    try {
      for (int hour = 0; hour < 24; hour++) {
        final start = DateTime(now.year, now.month, now.day, hour);
        final end = start.add(const Duration(hours: 1));

        final data = await _health.getHealthDataFromTypes(
          types: [HealthDataType.STEPS],
          startTime: start,
          endTime: end,
        );

        final sum = data.fold<int>(0, (prev, point) {
          return prev + (point.value is int ? point.value as int : (point.value as double).round());
        });

        hourlySteps[hour] = sum;
      }

      return hourlySteps;
    } catch (e) {
      print('Error fetching hourly steps: $e');
      return List.filled(24, 0);
    }
  }

  Future<List<int>> getHourlyCaloriesForToday() async {
    final now = DateTime.now();
    print("Fetching hourly calories...");
    List<int> hourlyCalories = List.filled(24, 0);

    try {
      for (int hour = 0; hour < 24; hour++) {
        final start = DateTime(now.year, now.month, now.day, hour);
        final end = start.add(const Duration(hours: 1));

        final data = await _health.getHealthDataFromTypes(
          types: [HealthDataType.ACTIVE_ENERGY_BURNED],
          startTime: start,
          endTime: end,
        );

       final sum = data.fold<double>(0.0, (prev, point) {
          return prev + (point.value is double ? point.value as double : (point.value as int).toDouble());
        });

        hourlyCalories[hour] = sum.round();
      }
      return hourlyCalories;
    } catch (e) {
      print('Error fetching hourly calories: $e');
      return List.filled(24, 0);
    }
  }
}
