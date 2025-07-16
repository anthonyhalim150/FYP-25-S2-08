import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wise_workout_app/widgets/exercise_stats_card.dart';
import '../../services/health_service.dart';

class DailySummaryPage extends StatefulWidget {
  const DailySummaryPage({super.key});

  @override
  State<DailySummaryPage> createState() => _DailySummaryPageState();
}

class _DailySummaryPageState extends State<DailySummaryPage> {
  final HealthService _healthService = HealthService();

  bool _isLoading = true;
  List<int> _hourlySteps = List.filled(24, 0);
  List<int> _hourlyCalories = List.filled(24, 0);
  int _currentSteps = 0;
  int _caloriesBurned = 0;
  int _xpEarned = 0; // Example XP calculation

  @override
  void initState() {
    super.initState();
    _initHealthData();
  }

  Future<void> _initHealthData() async {
    final connected = await _healthService.connect();
    if (!connected) {
      setState(() => _isLoading = false);
      return;
    }

    final steps = await _healthService.getTodaySteps();
    final hourlySteps = await _healthService.getHourlyStepsForToday();
    final hourlyCalories = await _healthService.getHourlyCaloriesForToday();

    setState(() {
      _currentSteps = steps;
      _hourlySteps = hourlySteps;
      _hourlyCalories = hourlyCalories;
      _caloriesBurned = hourlyCalories.fold(0, (prev, c) => prev + c);
      _xpEarned = (_currentSteps / 100).round();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F0EB),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Daily Activity", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: const [Icon(Icons.calendar_today, color: Colors.black)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "${currentDate.day} ${_monthName(currentDate.month)} ${currentDate.year}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),

              /// Exercise Stats
              ExerciseStatsCard(
                currentSteps: _currentSteps,
                maxSteps: 10000,
                caloriesBurned: _caloriesBurned,
                xpEarned: _xpEarned,
              ),

              const SizedBox(height: 20),

              /// Steps Chart
              _TimeBasedChart(
                icon: Icons.directions_walk,
                title: "Steps",
                currentValue: _currentSteps.toString(),
                avgValue: "9,121", // Optionally compute weekly average
                barColor: Colors.blue,
                maxY: 10000,
                data: _hourlySteps,
              ),

              const SizedBox(height: 20),

              /// Calories Chart
              _TimeBasedChart(
                icon: Icons.local_fire_department,
                title: "Calories",
                currentValue: _caloriesBurned.toString(),
                avgValue: "234", // Optionally compute weekly average
                barColor: Colors.red,
                maxY: 300,
                data: _hourlyCalories,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}

class _TimeBasedChart extends StatelessWidget {
  final IconData icon;
  final String title;
  final String currentValue;
  final String avgValue;
  final Color barColor;
  final double maxY;
  final List<int> data;

  const _TimeBasedChart({
    required this.icon,
    required this.title,
    required this.currentValue,
    required this.avgValue,
    required this.barColor,
    required this.maxY,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: barColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: barColor),
              const SizedBox(width: 6),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(currentValue, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Current", style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              Column(
                children: [
                  Text(avgValue, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Daily avg last week", style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        if (value.toInt() % 6 == 0) {
                          return Text("${value.toInt()}h", style: const TextStyle(fontSize: 10));
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: maxY / 3,
                      getTitlesWidget: (value, _) => Text("${value.toInt()}", style: const TextStyle(fontSize: 10)),
                      reservedSize: 30,
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: List.generate(data.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i].toDouble(),
                        color: barColor,
                        width: 6,
                        borderRadius: BorderRadius.circular(4),
                      )
                    ],
                  );
                }),
                maxY: maxY,
                gridData: FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}