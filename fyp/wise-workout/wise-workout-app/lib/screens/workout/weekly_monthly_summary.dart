import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/health_service.dart';
import '../../widgets/time_based_chart.dart';
import '../../widgets/week_picker_dialog.dart';

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

  List<int> _stepsData = List.filled(24, 0);
  List<int> _caloriesData = List.filled(24, 0);
  int _totalSteps = 0;
  int _totalCalories = 0;
  int _averageSteps = 0;
  int _averageCalories = 0;

  @override
  void initState() {
    super.initState();
    _healthService.connect();
    _selectedWeek = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 6)),
      end: DateTime.now(),
    );
    _fetchSummaryData(_selectedWeek!.start, _selectedWeek!.end);
  }

  Future<void> _fetchSummaryData(DateTime start, DateTime end) async {
    setState(() => _isLoading = true);
    final totalSteps = await _healthService.getStepsInRange(start, end);
    final totalCalories = await _healthService.getCaloriesInRange(start, end);
    final stepsData = await _healthService.getDailyStepsInRange(start, end);
    final caloriesData = await _healthService.getDailyCaloriesInRange(start, end);

    setState(() {
      _totalSteps = totalSteps;
      _totalCalories = totalCalories;
      _stepsData = stepsData;
      _caloriesData = caloriesData;
      _averageSteps = stepsData.isNotEmpty ? (stepsData.reduce((a, b) => a + b) ~/ stepsData.length) : 0;
      _averageCalories = caloriesData.isNotEmpty ? (caloriesData.reduce((a, b) => a + b) ~/ caloriesData.length) : 0;
      _isLoading = false;
    });
  }

  Widget _buildToggleTabs() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.orange.shade100,
      ),
      child: Row(
        children: [
          _toggleButton("Weekly", true),
          _toggleButton("Monthly", false),
        ],
      ),
    );
  }

  Widget _toggleButton(String label, bool isWeekly) {
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
            color: isSelected ? Colors.orange : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    if (_isWeeklyView) {
      return Column(
        children: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
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
              child: const Text("Select Week"),
            ),
          ),
          if (_selectedWeek != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "${_selectedWeek!.start.day} ${_monthName(_selectedWeek!.start.month)} - "
                    "${_selectedWeek!.end.day} ${_monthName(_selectedWeek!.end.month)}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
            icon: const Icon(Icons.chevron_left),
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: isLatestMonth ? Colors.grey : Colors.black),
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Text("Summary", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildToggleTabs(),
            const SizedBox(height: 12),
            _buildDatePicker(),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView(
                  children: [
                    TimeBasedChart(
                      icon: Icons.directions_walk,
                      title: "Steps",
                      currentValue: "$_totalSteps",
                      avgValue: "$_averageSteps",
                      barColor: Colors.orange,
                      maxY: 10000,
                      data: _stepsData,
                    ),
                    const SizedBox(height: 20),
                    TimeBasedChart(
                      icon: Icons.local_fire_department,
                      title: "Calories",
                      currentValue: "$_totalCalories kcal",
                      avgValue: "$_averageCalories kcal",
                      barColor: Colors.redAccent,
                      maxY: 300,
                      data: _caloriesData,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
