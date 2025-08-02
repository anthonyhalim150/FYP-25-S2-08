import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../services/fitnessai_service.dart';
import 'dart:convert';

class CalendarPlanScreen extends StatefulWidget {
  const CalendarPlanScreen({super.key});

  @override
  State<CalendarPlanScreen> createState() => _CalendarPlanScreenState();
}

class _CalendarPlanScreenState extends State<CalendarPlanScreen> {
  final AIFitnessPlanService _aiService = AIFitnessPlanService();
  bool _loading = true;
  List<dynamic>? _plan;
  String? _error;
  List<Appointment> _appointments = [];

  @override
  void initState() {
    super.initState();
    _fetchPlan();
  }

// In your State class
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
        // Handle days_json as either a String or a List
        if (daysList is String) {
          daysList = daysList.isNotEmpty ? jsonDecode(daysList) as List : [];
        }
      }

      setState(() {
        _plan = daysList;
        _appointments = _generateAppointments(daysList);
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



  List<Appointment> _generateAppointments(dynamic days) {
    if (days == null || days is! List) return [];
    final DateTime today = DateTime.now();
    List<Appointment> appts = [];

    for (var day in days) {
      if (day is! Map) continue;

      int dayNum = day['day_of_month'] is int
          ? day['day_of_month']
          : int.tryParse(day['day_of_month']?.toString() ?? '1') ?? 1;

      final date = DateTime(today.year, today.month, 1).add(Duration(days: dayNum - 1));

      String title;
      String desc;

      if (day['rest'] == true) {
        title = "Rest Day";
        desc = day['notes'] ?? "";
      } else {
        final exercises = (day['exercises'] ?? []) as List;
        desc = [
          ...exercises.map((ex) {
            String exName = ex['name'] ?? ex['exerciseName'] ?? 'Exercise';
            var sets = ex['sets'] ?? ex['exerciseSets'] ?? '';
            var reps = ex['reps'] ?? ex['exerciseReps'] ?? '';
            return '$exName ($sets sets x $reps reps)';
          }),
          if (day['notes'] != null) 'Notes: ${day['notes']}'
        ].join('\n');

        title = "Workout Day $dayNum";
      }

      appts.add(Appointment(
        startTime: date,
        endTime: date,
        subject: title,
        notes: desc,
        isAllDay: true,
        color: day['rest'] == true ? Colors.grey.shade400 : Colors.teal.shade400,
      ));
    }
    return appts;
  }



  void _onTapCalendar(CalendarTapDetails details) {
    if (details.appointments == null || details.appointments!.isEmpty) return;
    final Appointment appt = details.appointments!.first;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(appt.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(child: Text(appt.notes ?? "")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your 30-Day Workout Calendar"),
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
          ? Center(
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      )
          : SfCalendar(
        view: CalendarView.month,
        initialSelectedDate: DateTime.now(),
        dataSource: WorkoutCalendarDataSource(_appointments),
        onTap: _onTapCalendar,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          agendaViewHeight: 180,
        ),
        todayHighlightColor: Colors.orange,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class WorkoutCalendarDataSource extends CalendarDataSource {
  WorkoutCalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}
