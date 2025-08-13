import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wise_workout_app/widgets/exercise_stats_card.dart';
import '../../services/health_service.dart';
import '../../services/api_service.dart';
import '../buypremium_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../services/workout_service.dart';

class DailySummaryPage extends StatefulWidget {
  const DailySummaryPage({super.key});
  @override
  State<DailySummaryPage> createState() => _DailySummaryPageState();
}

class _DailySummaryPageState extends State<DailySummaryPage> {
  final HealthService _healthService = HealthService();
  bool _isLoading = true;

  List<int> _hourlySteps = List.filled(24, 0);
  List<double> _hourlyCalories = List.filled(24, 0.0);

  int _currentSteps = 0;
  double _caloriesBurned = 0.0;
  int _xpEarned = 0;
  DateTime _selectedDate = DateTime.now();

  bool _isPremiumUser = false;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _initHealthData(_selectedDate);
  }

  Future<void> _fetchProfile() async {
    final profile = await ApiService().getCurrentProfile();
    if (profile != null) {
      setState(() {
        _isPremiumUser = profile['role'] == 'premium';
      });
    }
  }

  List<double> _preferBackendPerHour(List<double> backend, List<double> health) {
    final out = List<double>.filled(24, 0.0);
    for (int i = 0; i < 24; i++) {
      final b = (i < backend.length) ? backend[i] : 0.0;
      final h = (i < health.length) ? health[i] : 0.0;
      out[i] = b > 0 ? b : h;
    }
    return out;
  }

  double _sum(List<double> values) {
    double s = 0;
    for (final v in values) s += v;
    return s;
  }

  Future<void> _initHealthData(DateTime date) async {
    setState(() => _isLoading = true);

    List<double> backendHourly = List.filled(24, 0.0);
    try {
      backendHourly = await WorkoutService().fetchHourlyCaloriesForDate(date);
    } catch (e) {
    }

    final connected = await _healthService.connect();
    if (!connected) {
      final merged = backendHourly;
      setState(() {
        _selectedDate = date;
        _hourlyCalories = merged;
        _caloriesBurned = _sum(merged);
        _hourlySteps = List<int>.filled(24, 0);
        _currentSteps = 0;
        _xpEarned = 0;
        _isLoading = false;
      });
      return;
    }

    // 3) Health hourly + steps
    final steps = await _healthService.getStepsForDate(date);
    final hourlySteps = await _healthService.getHourlyStepsForDate(date);
    final healthHourly = (await _healthService.getHourlyCaloriesForDate(date))
        .map((e) => e.toDouble())
        .toList();

    // 4) Merge (per-hour)
    final mergedHourly = _preferBackendPerHour(backendHourly, healthHourly);

    // 5) Recompute the “current calories” from the bars so it matches the chart
    final totalCalories = _sum(mergedHourly);

    setState(() {
      _selectedDate = date;
      _currentSteps = steps;
      _hourlySteps = hourlySteps;
      _hourlyCalories = mergedHourly;
      _caloriesBurned = totalCalories;
      _xpEarned = (_currentSteps / 100).round();
      _isLoading = false;
    });
  }

  double _calculateAdaptiveMaxY(List<double> data, double minDefault) {
    if (data.isEmpty) return minDefault;
    final highest = data.reduce((a, b) => a > b ? a : b);
    if (highest <= minDefault) return minDefault;
    final roundedUp = (((highest * 1.1) / 1000).ceil()) * 1000;
    return roundedUp.toDouble();
  }

  void _changeDate(int offsetDays) {
    final newDate = _selectedDate.add(Duration(days: offsetDays));
    // allow yesterday and earlier; block future
    if (!newDate.isAfter(DateTime.now())) {
      _initHealthData(newDate);
    }
  }

  String _formattedDate(DateTime date) {
    return "${date.day} ${_monthName(date.month)} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final isToday = _selectedDate.year == DateTime.now().year &&
        _selectedDate.month == DateTime.now().month &&
        _selectedDate.day == DateTime.now().day;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: BackButton(color: colorScheme.onBackground),
        title: Text("daily_summary_title".tr(),
            style:
            textTheme.titleLarge?.copyWith(color: colorScheme.onBackground)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: _isPremiumUser ? colorScheme.onBackground : Colors.grey.shade400,
            ),
            onPressed: () {
              if (_isPremiumUser) {
                Navigator.pushNamed(context, '/weekly-monthly-summary');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BuyPremiumScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colorScheme.primary))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: colorScheme.primary),
                    onPressed: () => _changeDate(-1),
                  ),
                  Text(
                    _formattedDate(_selectedDate),
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color: isToday ? Colors.transparent : colorScheme.primary,
                    ),
                    onPressed: isToday ? null : () => _changeDate(1),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ExerciseStatsCard(
                currentSteps: _currentSteps,
                maxSteps: 10000,
                caloriesBurned: double.parse(_caloriesBurned.toStringAsFixed(1)),
                xpEarned: _xpEarned,
              ),
              const SizedBox(height: 20),
              _TimeBasedChart(
                icon: Icons.directions_walk,
                title: "steps_chart_title".tr(),
                currentValue: _currentSteps.toString(),
                barColor: colorScheme.primary,
                maxY: _calculateAdaptiveMaxY(
                  _hourlySteps.map((e) => e.toDouble()).toList(),
                  3000,
                ),
                data: _hourlySteps.map((e) => e.toDouble()).toList(),
              ),
              const SizedBox(height: 20),
              _TimeBasedChart(
                icon: Icons.local_fire_department,
                title: "calories_chart_title".tr(),
                currentValue: _caloriesBurned.toStringAsFixed(1),
                barColor: colorScheme.secondary,
                maxY: _calculateAdaptiveMaxY(_hourlyCalories, 200),
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
    return "month_$month".tr();
  }
}

class _TimeBasedChart extends StatelessWidget {
  final IconData icon;
  final String title;
  final String currentValue;
  final Color barColor;
  final double maxY;
  final List<double> data;

  const _TimeBasedChart({
    required this.icon,
    required this.title,
    required this.currentValue,
    required this.barColor,
    required this.maxY,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final shadowColor = Theme.of(context).shadowColor;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: barColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.04),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: barColor),
              const SizedBox(width: 6),
              Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                Text(
                  currentValue,
                  style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text("current_label".tr(),
                    style: textTheme.bodySmall,
                ),
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
                        // label every 6 hours: 0h, 6h, 12h, 18h
                        if (value.toInt() % 6 == 0) {
                          return Text("${value.toInt()}h", style: textTheme.labelSmall);
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: maxY / 3,
                      getTitlesWidget: (value, _) => Text("${value.toInt()}", style: textTheme.labelSmall),
                      reservedSize: 30,
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                barGroups: List.generate(data.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: data[i],
                        color: barColor,
                        width: 6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
                maxY: maxY,
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
