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

  Future<List<HealthDataPoint>> getHeartRateDataInRange(DateTime start, DateTime end) async {
    try {
      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: start,
        endTime: end,
      );
      return data;
    } catch (e) {
      print("Error fetching heart rate data: $e");
      return [];
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
      );

      final total = data.fold<double>(0.0, (prev, point) {
        return prev + (point.value is double ? point.value as double : (point.value as int).toDouble());
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

    try {
      for (int hour = 0; hour < 24; hour++) {
        final start = DateTime(now.year, now.month, now.day, hour);
        final end = start.add(const Duration(hours: 1));
        final steps = await _health.getTotalStepsInInterval(start, end);
        hourlySteps[hour] = steps ?? 0;
      }
      return hourlySteps;
    } catch (e) {
      print('Error fetching hourly steps: $e');
      return List.filled(24, 0);
    }
  }

  Future<List<int>> getHourlyCaloriesForToday() async {
    final now = DateTime.now();
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

  Future<int> getStepsInRange(DateTime start, DateTime end) async {
    try {
      final steps = await _health.getTotalStepsInInterval(start, end);
      return steps ?? 0;
    } catch (e) {
      print('Error getting steps in range: $e');
      return 0;
    }
  }

  Future<int> getCaloriesInRange(DateTime start, DateTime end) async {
    try {
      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: start,
        endTime: end,
      );

      final total = data.fold<double>(0.0, (prev, point) {
        return prev + (point.value is double ? point.value as double : (point.value as int).toDouble());
      });

      return total.round();
    } catch (e) {
      print('Error getting calories in range: $e');
      return 0;
    }
  }

  Future<List<int>> getDailyStepsInRange(DateTime start, DateTime end) async {
    final days = end.difference(start).inDays + 1;
    List<int> stepsPerDay = [];

    for (int i = 0; i < days; i++) {
      final dayStart = DateTime(start.year, start.month, start.day + i);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final steps = await _health.getTotalStepsInInterval(dayStart, dayEnd);
      stepsPerDay.add(steps ?? 0);
    }
    return stepsPerDay;
  }

  Future<List<int>> getDailyCaloriesInRange(DateTime start, DateTime end) async {
    final days = end.difference(start).inDays + 1;
    List<int> caloriesPerDay = [];

    for (int i = 0; i < days; i++) {
      final dayStart = DateTime(start.year, start.month, start.day + i);
      final dayEnd = dayStart.add(const Duration(days: 1));
      final data = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: dayStart,
        endTime: dayEnd,
      );

      final total = data.fold<double>(0.0, (prev, point) {
        return prev + (point.value is double ? point.value as double : (point.value as int).toDouble());
      });

      caloriesPerDay.add(total.round());
    }
    return caloriesPerDay;
  }
}
