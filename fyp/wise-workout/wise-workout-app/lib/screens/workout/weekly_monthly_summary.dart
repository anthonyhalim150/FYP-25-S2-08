import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/health_service.dart';
import '../../widgets/time_based_chart.dart';
import '../../widgets/week_picker_dialog.dart';
import '../../services/workout_service.dart';
import '../../services/api_service.dart';

class WeeklyMonthlySummaryPage extends StatefulWidget {
  const WeeklyMonthlySummaryPage({super.key});
  @override
  State<WeeklyMonthlySummaryPage> createState() => _WeeklyMonthlySummaryPageState();
}

class _WeeklyMonthlySummaryPageState extends State<WeeklyMonthlySummaryPage> {
  final HealthService _healthService = HealthService();
  bool _isLoading = false;

  bool _isWeeklyView = true;
  DateTimeRange? _selectedWeek;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  List<int> _stepsData = const [];
  List<int> _caloriesData = const [];
  int _totalSteps = 0;
  int _totalCalories = 0;
  int _averageSteps = 0;
  int _averageCalories = 0;

  double? _weightKg;
  int? _heightCm;
  String? _gender;

  @override
  void initState() {
    super.initState();
    _healthService.connect();
    _selectedWeek = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 6)),
      end: DateTime.now(),
    );
    _loadProfile().then((_) {
      _fetchSummaryData(_selectedWeek!.start, _selectedWeek!.end);
    });
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await ApiService().getCurrentProfile();
      if (profile != null) {
        _weightKg = (profile['weight_kg'] is num) ? (profile['weight_kg'] as num).toDouble() : null;
        _heightCm = (profile['height_cm'] is num) ? (profile['height_cm'] as num).toInt() : null;
        _gender = (profile['gender'] as String?)?.toLowerCase();
      }
    } catch (_) {}
  }

  // ---- Estimation helpers (per-day) ----
  double _strideMeters({int? heightCm, String? gender}) {
    final h = (heightCm ?? 170).toDouble();
    const factor = 0.415; // walking step length ≈ 41.5% of height
    return (h * factor) / 100.0; // meters
  }

  List<int> _estimateCaloriesFromStepsDaily(List<int> dailySteps) {
    final weight = _weightKg ?? 70.0;
    final strideM = _strideMeters(heightCm: _heightCm, gender: _gender);
    const kcalPerKgKmWalking = 0.53;

    return List<int>.generate(dailySteps.length, (i) {
      final steps = dailySteps[i];
      final km = (steps * strideM) / 1000.0;
      final kcal = km * weight * kcalPerKgKmWalking;
      return kcal.round(); // return ints for your charts
    });
  }

  List<int> _padOrTrim(List<int> list, int len) {
    if (list.length == len) return list;
    if (list.length > len) return list.sublist(0, len);
    return List<int>.from(list)..addAll(List.filled(len - list.length, 0));
  }

  Future<List<int>> _fetchBackendCaloriesSeries(DateTime start, DateTime end) async {
    try {
      final series = await WorkoutService().fetchDailyCaloriesSeries(from: start, to: end);
      final values = (series['values'] as List).map((e) {
        if (e is num) return e.round();
        return int.tryParse('$e') ?? 0;
      }).toList();
      return List<int>.from(values);
    } catch (_) {
      return [];
    }
  }

  Future<void> _fetchSummaryData(DateTime start, DateTime end) async {
    setState(() => _isLoading = true);

    // Normalize range to whole days
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);
    final dayCount = endDay.difference(startDay).inDays + 1;

    // Health data
    final totalSteps = await _healthService.getStepsInRange(startDay, endDay);

    // ❌ Turn off fetching total calories burned
    // final healthTotalCalories = await _healthService.getCaloriesInRange(startDay, endDay);

    final stepsDaily = await _healthService.getDailyStepsInRange(startDay, endDay);

    // ❌ Turn off fetching daily active energy burned
    // final healthCaloriesDaily = await _healthService.getDailyCaloriesInRange(startDay, endDay);

    final stepsDailyFixed = _padOrTrim(stepsDaily, dayCount);

    // Since we’re not using healthCaloriesDaily anymore, create an empty list
    final healthCaloriesFixed = List<int>.filled(dayCount, 0);

    // Steps→calories estimate per day
    final stepsCaloriesDaily = _estimateCaloriesFromStepsDaily(stepsDailyFixed);

    // Backend (workout) daily calories
    final backendCalories = await _fetchBackendCaloriesSeries(startDay, endDay);
    final backendFixed = _padOrTrim(backendCalories, dayCount);

    // Merge: backend + (stepsEstimated only)
    final mergedCalories = List<int>.generate(dayCount, (i) {
      // Previously: used healthCaloriesFixed[i] if > 0
      final movement = stepsCaloriesDaily[i];
      return backendFixed[i] + movement;
    });

    // Totals / averages
    final mergedTotalCalories = mergedCalories.fold<int>(0, (s, v) => s + v);
    final avgSteps = stepsDailyFixed.isNotEmpty
        ? (stepsDailyFixed.reduce((a, b) => a + b) ~/ stepsDailyFixed.length)
        : 0;
    final avgCalories = mergedCalories.isNotEmpty
        ? (mergedCalories.reduce((a, b) => a + b) ~/ mergedCalories.length)
        : 0;

    setState(() {
      _totalSteps = totalSteps;
      _stepsData = stepsDailyFixed;

      _totalCalories = mergedTotalCalories;
      _caloriesData = mergedCalories;

      _averageSteps = avgSteps;
      _averageCalories = avgCalories;
      _isLoading = false;
    });
  }


  // ---- Chart scaling ----
  double _calculateAdaptiveMaxY(List<int> data, double defaultMax,
      {double step = 2000, double headroom = 1.1, double maxCap = 50000}) {
    if (data.isEmpty) return defaultMax;
    final highest = data.reduce((a, b) => a > b ? a : b).toDouble();
    if (highest <= defaultMax) return defaultMax;
    final roundedUp = (((highest * headroom) / step).ceil()) * step;
    return roundedUp > maxCap ? maxCap : roundedUp;
  }

  double _calculateCaloriesMaxY(List<int> data,
      {int baseline = 300, int step = 100, int maxCap = 20000}) {
    if (data.isEmpty) return baseline.toDouble();
    final highest = data.reduce((a, b) => a > b ? a : b);
    if (highest <= baseline) return baseline.toDouble();
    final withHeadroom = highest + step;
    final roundedUp = ((withHeadroom / step).ceil()) * step;
    return roundedUp > maxCap ? maxCap.toDouble() : roundedUp.toDouble();
  }

  // ---- UI helpers ----
  Widget _buildToggleTabs(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.secondaryContainer,
      ),
      child: Row(
        children: [
          _toggleButton("Weekly", true, context),
          _toggleButton("Monthly", false, context),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, bool isWeekly, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isSelected = _isWeeklyView == isWeekly;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _isWeeklyView = isWeekly);
          if (isWeekly) {
            _fetchSummaryData(_selectedWeek!.start, _selectedWeek!.end);
          } else {
            final start = DateTime(_selectedYear, _selectedMonth, 1);
            final end = DateTime(_selectedYear, _selectedMonth + 1, 1).subtract(const Duration(days: 1));
            _fetchSummaryData(start, end);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_isWeeklyView) {
      return Column(
        children: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                final picked = await showModalBottomSheet<DateTimeRange>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  isScrollControlled: true,
                  builder: (context) => WeekPickerDialog(initialRange: _selectedWeek),
                );
                if (picked != null) {
                  setState(() => _selectedWeek = picked);
                  _fetchSummaryData(picked.start, picked.end);
                }
              },
              child: Text("Select Week", style: textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary)),
            ),
          ),
          if (_selectedWeek != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "${_selectedWeek!.start.day} ${_monthName(_selectedWeek!.start.month)} - "
                    "${_selectedWeek!.end.day} ${_monthName(_selectedWeek!.end.month)}",
                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      );
    } else {
      final isLatestMonth = (_selectedYear == DateTime.now().year && _selectedMonth == DateTime.now().month);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: colorScheme.primary),
            onPressed: () {
              setState(() {
                _selectedMonth--;
                if (_selectedMonth < 1) {
                  _selectedMonth = 12;
                  _selectedYear--;
                }
              });
              final start = DateTime(_selectedYear, _selectedMonth, 1);
              final end = DateTime(_selectedYear, _selectedMonth + 1, 1).subtract(const Duration(days: 1));
              _fetchSummaryData(start, end);
            },
          ),
          Text(
            "${_monthName(_selectedMonth)} $_selectedYear",
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: isLatestMonth ? colorScheme.outline : colorScheme.primary),
            onPressed: isLatestMonth
                ? null
                : () {
              setState(() {
                _selectedMonth++;
                if (_selectedMonth > 12) {
                  _selectedMonth = 1;
                  _selectedYear++;
                }
              });
              final start = DateTime(_selectedYear, _selectedMonth, 1);
              final end = DateTime(_selectedYear, _selectedMonth + 1, 1).subtract(const Duration(days: 1));
              _fetchSummaryData(start, end);
            },
          ),
        ],
      );
    }
  }

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Text(
                    "Summary",
                    style: textTheme.headlineSmall?.copyWith(
                      fontSize: 24,
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildToggleTabs(context),
            const SizedBox(height: 12),
            _buildDatePicker(context),
            const SizedBox(height: 20),
            if (_isLoading)
              Center(child: CircularProgressIndicator(color: colorScheme.primary))
            else
              Expanded(
                child: ListView(
                  children: [
                    TimeBasedChart(
                      icon: Icons.directions_walk,
                      title: "Steps",
                      currentValue: "$_totalSteps",
                      avgValue: "$_averageSteps",
                      barColor: colorScheme.primary,
                      maxY: _calculateAdaptiveMaxY(_stepsData, 10000),
                      data: _stepsData,
                    ),
                    const SizedBox(height: 20),
                    TimeBasedChart(
                      icon: Icons.local_fire_department,
                      title: "Calories",
                      currentValue: "$_totalCalories kcal",
                      avgValue: "$_averageCalories kcal",
                      barColor: colorScheme.secondary,
                      maxY: _calculateCaloriesMaxY(_caloriesData),
                      data: _caloriesData,
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
