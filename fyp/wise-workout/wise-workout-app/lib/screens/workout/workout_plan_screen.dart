import 'package:flutter/material.dart';
import '../../services/fitnessai_service.dart';  // Import your AI service

class WorkoutPlanScreen extends StatefulWidget {
  final List<dynamic> plan;  // Plan passed from FitnessPlanScreen

  const WorkoutPlanScreen({Key? key, required this.plan}) : super(key: key);

  @override
  _WorkoutPlanScreenState createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  final AIFitnessPlanService _aiService = AIFitnessPlanService();  // Service to fetch exercises
  bool _loading = false;
  String? _error;
  List<dynamic> _plan = [];

  @override
  void initState() {
    super.initState();
    _plan = widget.plan;  // Set the passed plan data
  }

  // Build the workout plan list to display per day
  Widget buildPlanList() {
    if (_plan == null || _plan.isEmpty) {
      return const Text(
        "No plan found. Please complete your fitness profile and try again.",
        style: TextStyle(color: Colors.grey),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _plan.length - 1,  // Skipping the plan title at index 0
        itemBuilder: (context, idx) {
          final dayPlan = _plan[idx + 1];  // Skipping the first item (plan_title)
          final isRest = dayPlan['rest'] == true;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayPlan['day_of_month'] != null
                        ? "Day ${dayPlan['day_of_month']}"
                        : "Day ${dayPlan['day']}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  const SizedBox(height: 6),
                  if (isRest) ...[
                    Text(
                      "Rest Day",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                        fontSize: 16,
                      ),
                    ),
                  ] else ...[  // Render exercises if it's not a rest day
                    ...((dayPlan['exercises'] ?? []).map<Widget>((ex) {
                      final name = ex['name'] ?? '';
                      final sets = ex['sets']?.toString() ?? '-';
                      final reps = ex['reps']?.toString() ?? '-';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Text(
                          '$name  |  Sets: $sets  |  Reps: $reps',
                          style: const TextStyle(fontSize: 15),
                        ),
                      );
                    }).toList()),
                  ],
                  if (dayPlan['notes'] != null && dayPlan['notes'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Notes: ${dayPlan['notes']}",
                        style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text(_error!))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_plan.isEmpty)
              const Text(
                "No plan found. Please complete your fitness profile and try again.",
                style: TextStyle(color: Colors.grey),
              )
            else ...[
              // Display the plan's title
              Text(
                _plan[0]['plan_title'] ?? 'Personalized Plan',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.teal),
              ),
              const SizedBox(height: 6),
              buildPlanList(),
            ],
          ],
        ),
      ),
    );
  }
}
