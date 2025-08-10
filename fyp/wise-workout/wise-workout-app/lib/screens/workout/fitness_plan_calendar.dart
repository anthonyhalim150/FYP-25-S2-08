import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/fitnessai_service.dart';
import 'dart:convert';
import '../workout/exercise_list_from_ai_page.dart';

class CalendarPlanScreen extends StatefulWidget {
  const CalendarPlanScreen({super.key});

  @override
  State<CalendarPlanScreen> createState() => _CalendarPlanScreenState();
}

class _CalendarPlanScreenState extends State<CalendarPlanScreen> {
  final AIFitnessPlanService _aiService = AIFitnessPlanService();
  bool _loading = true;
  String? _error;
  List<dynamic> _days = [];
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;
  Map<String, dynamic>? _selectedDayData;
  DateTime? _planStartDate;

  @override
  void initState() {
    super.initState();
    _fetchPlan();
  }

  Future<void> _fetchPlan() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _aiService.fetchSavedPlanFromBackend();
      final plans = result['plan'] ?? [];
      dynamic daysList = [];

      if (plans is List && plans.isNotEmpty && plans.first is Map && plans.first.containsKey('days_json')) {
        final firstPlan = plans.first;
        daysList = firstPlan['days_json'];
        if (daysList is String) {
          daysList = daysList.isNotEmpty ? jsonDecode(daysList) as List : [];
        }

        final createdAtString = firstPlan['created_at'];
        try {
          _planStartDate = DateTime.parse(createdAtString);
        } catch (e) {
          _planStartDate = DateTime.now();
        }
      }

      setState(() {
        _days = daysList ?? [];

        if (_planStartDate != null) {
          for (int i = 0; i < _days.length; i++) {
            _days[i]['calendar_date'] = _planStartDate!.add(Duration(days: i));
          }
        }

        final today = DateTime.now();
        final planTodayIdx = _days.indexWhere(
              (d) =>
          d['calendar_date'] != null &&
              DateUtils.isSameDay(d['calendar_date'], today),
        );

        if (planTodayIdx != -1) {
          _selectedDate = _days[planTodayIdx]['calendar_date'];
          _selectedDayData = _days[planTodayIdx];
        } else if (_days.isNotEmpty) {
          _selectedDate = _days.first['calendar_date'];
          _selectedDayData = _days.first;
        } else {
          _selectedDate = null;
          _selectedDayData = null;
        }

        _currentMonth = _selectedDate ?? _planStartDate ?? DateTime.now();
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month);
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _onMonthChanged(int direction) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + direction,
      );
    });
  }

  void _onSelectDay(DateTime cellDate) {
    setState(() {
      _selectedDate = cellDate;
      _selectedDayData = _days.firstWhere(
            (d) =>
        d['calendar_date'] != null &&
            DateUtils.isSameDay(d['calendar_date'], cellDate),
        orElse: () => null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstWeekday = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday;
    final calendarDays = [
      ...List.filled(firstWeekday - 1, null),
      ...List.generate(daysInMonth, (i) => i + 1)
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Calendar", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _fetchPlan,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 28),
                  onPressed: () => _onMonthChanged(-1),
                ),
                GestureDetector(
                  onTap: () async {
                  },
                  child: Text(
                    DateFormat.yMMMM().format(_currentMonth),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 28),
                  onPressed: () => _onMonthChanged(1),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                  .map((d) => Expanded(
                child: Center(child: Text(d, style: TextStyle(fontWeight: FontWeight.bold))),
              ))
                  .toList(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 8,
                ),
                itemCount: calendarDays.length,
                itemBuilder: (context, index) {
                  final dayNum = calendarDays[index];
                  final cellDate = dayNum == null
                      ? null
                      : DateTime(_currentMonth.year, _currentMonth.month, dayNum);

                  final planDay = cellDate == null
                      ? null
                      : _days.firstWhere(
                        (d) =>
                    d['calendar_date'] != null &&
                        DateUtils.isSameDay(d['calendar_date'], cellDate),
                    orElse: () => null,
                  );

                  final isSelected = cellDate != null &&
                      _selectedDate != null &&
                      DateUtils.isSameDay(cellDate, _selectedDate!);
                  final isRestDay = planDay?['rest'] == true;
                  final isPastDate = cellDate != null &&
                      _planStartDate != null &&
                      cellDate.isBefore(DateTime.now()) &&
                      !DateUtils.isSameDay(cellDate, DateTime.now());

                  return dayNum == null
                      ? const SizedBox.shrink()
                      : GestureDetector(
                    onTap: planDay != null ? () => _onSelectDay(cellDate!) : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF7B2FF2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(color: const Color(0xFF7B2FF2), width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$dayNum",
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : planDay == null
                                    ? Colors.grey[350]
                                    : isPastDate
                                    ? Colors.grey
                                    : isRestDay
                                    ? Colors.blueGrey
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            if (planDay != null && isRestDay)
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(Icons.hotel, size: 13, color: Colors.blueGrey),
                              ),
                            if (planDay != null && !isRestDay)
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(Icons.fitness_center, size: 13, color: Colors.teal),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 8,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: _selectedDayData == null
                ? const Center(child: Text("No activities selected."))
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedDayData != null && _selectedDate != null)
                  Text(
                    "Activities for Day ${_days.indexOf(_selectedDayData!) + 1} (${DateFormat('MMMM d').format(_selectedDate!)})",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                const SizedBox(height: 6),
                if (_selectedDayData?['rest'] == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _selectedDayData?['notes'] ?? "Rest and recover.",
                      style: TextStyle(color: Colors.blueGrey[700], fontSize: 15),
                    ),
                  )
                else if ((_selectedDayData?['exercises'] as List?)?.isNotEmpty ?? false)
                  ...[
                    ...(_selectedDayData!['exercises'] as List).map((ex) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "${ex['name'] ?? ex['exerciseName']} (${ex['sets'] ?? ex['exerciseSets']} sets x ${ex['reps'] ?? ex['exerciseReps']} reps)",
                        style: const TextStyle(fontSize: 15),
                      ),
                    )),
                    if ((_selectedDayData!['exercises'] as List).isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.list_alt),
                          label: const Text('View Exercise Details'),
                          onPressed: () {
                            final exerciseNames = (_selectedDayData!['exercises'] as List)
                                .map<String>((ex) => (ex['name'] ?? ex['exerciseName']) as String)
                                .toList();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExerciseListFromAIPage(
                                  exerciseNames: exerciseNames,
                                  dayLabel: "Day ${_days.indexOf(_selectedDayData!) + 1} Exercises",
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (_selectedDayData?['notes'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          _selectedDayData?['notes'],
                          style: const TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ),
                  ]
                else
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text("No activities for this day."),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}