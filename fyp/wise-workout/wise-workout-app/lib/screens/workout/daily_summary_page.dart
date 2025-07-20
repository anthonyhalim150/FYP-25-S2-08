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
  int _xpEarned = 0;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initHealthData(_selectedDate);
  }

  Future<void> _initHealthData(DateTime date) async {
    setState(() => _isLoading = true);

    final connected = await _healthService.connect();
    if (!connected) {
      setState(() => _isLoading = false);
      return;
    }
    final steps = await _healthService.getTodaySteps();
    final hourlySteps = await _healthService.getHourlyStepsForToday();
    final hourlyCalories = await _healthService.getHourlyCaloriesForToday();
    final calories = await _healthService.getTodayCalories();

    setState(() {
      _selectedDate = date;
      _currentSteps = steps;
      _hourlySteps = hourlySteps;
      _hourlyCalories = hourlyCalories;
      _caloriesBurned = hourlyCalories.fold(0, (prev, c) => prev + c);
      _xpEarned = (_currentSteps / 100).round();
      _isLoading = false;
    });
  }

  void _changeDate(int offsetDays) {
    final newDate = _selectedDate.add(Duration(days: offsetDays));
    if (!newDate.isAfter(DateTime.now())) {
      _initHealthData(newDate);
    }
  }

  String _formattedDate(DateTime date) {
    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final isToday = _selectedDate.year == DateTime.now().year &&
        _selectedDate.month == DateTime.now().month &&
        _selectedDate.day == DateTime.now().day;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F0EB),
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Daily Activity", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/weekly-monthly-summary');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// Date Selector with Arrows
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () => _changeDate(-1),
                  ),
                  Text(
                    _formattedDate(_selectedDate),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color: isToday ? Colors.transparent : Colors.black,
                    ),
                    onPressed: isToday ? null : () => _changeDate(1),
                  ),
                ],
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

              _TimeBasedChart(
                icon: Icons.directions_walk,
                title: "Steps",
                currentValue: _currentSteps.toString(),
                avgValue: "9,121",
                barColor: Colors.blue,
                maxY: 10000,
                data: _hourlySteps,
              ),

              const SizedBox(height: 20),

              _TimeBasedChart(
                icon: Icons.local_fire_department,
                title: "Calories",
                currentValue: _caloriesBurned.toString(),
                avgValue: "234",
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
  final String avgValue; // still kept for compatibility, not shown
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
          Center(
            child: Column(
              children: [
                Text(currentValue, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text("Current", style: TextStyle(color: Colors.grey[600])),
              ],
            ),
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
