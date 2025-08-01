import 'package:flutter/material.dart';
import '../services/fitnessai_service.dart';
import 'edit_preferences_screen.dart';
import '../screens/model/workout_day_model.dart';
import '../screens/model/exercise_model.dart';

class FitnessPlanScreen extends StatefulWidget {
  const FitnessPlanScreen({Key? key}) : super(key: key);
  @override
  State<FitnessPlanScreen> createState() => _FitnessPlanScreenState();
}

class _FitnessPlanScreenState extends State<FitnessPlanScreen> {
  final AIFitnessPlanService _aiService = AIFitnessPlanService();
  bool _loading = false;
  bool _generatingPlan = false;
  List<dynamic>? _plan;
  Map<String, dynamic>? _preferences;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPreferences();
  }

  Future<void> _fetchPreferences() async {
    setState(() {
      _loading = true;
      _preferences = null;
      _plan = null;
      _error = null;
    });

    try {
      final prefs = await _aiService.fetchPreferencesOnly(); // or UserPreferencesService
      setState(() {
        _preferences = prefs;
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


  Future<void> _fetchPlan() async {
    setState(() {
      _generatingPlan = true;
      _plan = null;
      _error = null;
    });

    try {
      final result = await _aiService.fetchPlanFromDB();
      final fetchedPlan = result['plan'];
      setState(() {
        if (fetchedPlan is List) {
          _plan = fetchedPlan;
        } else if (fetchedPlan is Map) {
          _plan = [fetchedPlan];
        } else {
          _plan = [];
        }
        // Don't overwrite preferences here to preserve edited state
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _generatingPlan = false;
      });
    }
  }

  Widget buildPreferencesCard() {
    if (_preferences == null) return const SizedBox();
    return Card(
      elevation: 3,
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 18),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Your Fitness Preferences",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  tooltip: "Edit Preferences",
                  onPressed: () async {
                    final updatedPrefs = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPreferencesScreen(
                          preferences: Map<String, dynamic>.from(_preferences!),
                        ),
                      ),
                    );
                    if (updatedPrefs != null) {
                      setState(() {
                        _preferences = updatedPrefs;
                        _plan = null; // Clear existing plan if any, since preferences changed
                      });
                    }
                  },
                ),
              ],
            ),
            const Divider(),
            ..._preferences!.entries.map(
                  (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  "${_preferenceLabel(e.key)}: ${e.value ?? '-'}",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _preferenceLabel(String key) {
    switch (key) {
      case 'fitness_goal':
        return 'Goal';
      case 'fitness_level':
        return 'Level';
      case 'workout_days':
        return 'Workout Days';
      case 'workout_time':
        return 'Workout Time';
      case 'equipment_pref':
        return 'Equipment';
      case 'weight_kg':
        return 'Weight (kg)';
      case 'height_cm':
        return 'Height (cm)';
      case 'gender':
        return 'Gender';
      case 'injury':
        return 'Injury';
      case 'enjoyed_workouts':
        return 'Enjoyed Workouts';
      case 'bmi_value':
        return 'BMI';
      default:
        return key;
    }
  }

  Widget buildPlanList() {
    if (_plan == null || _plan!.isEmpty) {
      return const Text(
        "No plan found. Please complete your fitness profile and try again.",
        style: TextStyle(color: Colors.grey),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: _plan!.length - 1,
        itemBuilder: (context, idx) {
          final dayPlan = _plan![idx + 1];
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
                        : (dayPlan['day_of_week'] ?? (dayPlan['day'] != null ? "Day ${dayPlan['day']}" : '-')),
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
                  ] else ...[
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

  Widget buildGeneratePlanButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 24),
      child: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.bolt, color: Colors.amber),
          label: const Text(
            "Generate AI Fitness Plan",
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          ),
          onPressed: _generatingPlan ? null : _fetchPlan,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Fitness Plan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "Edit Preferences",
            onPressed: _preferences == null
                ? null
                : () async {
              final updatedPrefs = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditPreferencesScreen(
                        preferences: Map<String, dynamic>.from(_preferences!),
                      ),
                ),
              );
              if (updatedPrefs != null) {
                setState(() {
                  _preferences = updatedPrefs;
                  _plan = null;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh Plan",
            onPressed: _loading ? null : _fetchPreferences,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_preferences != null) buildPreferencesCard(),
            if (_preferences != null && (_plan == null || _plan!.isEmpty))
              buildGeneratePlanButton(),
            if (_plan != null && _plan!.isNotEmpty) ...[
              Text(
                _plan![0]['plan_title'] != null
                    ? _plan![0]['plan_title']
                    : 'Personalized Plan',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.teal,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save This Plan'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    onPressed: (_plan == null || _plan!.isEmpty)
                        ? null
                        : () async {
                      setState(() => _loading = true);
                      try {
                        final String planTitle = _plan![0]['plan_title'];
                        final List<dynamic> planDaysJson = _plan!.sublist(1);

                        final List<WorkoutDay> workoutDays = planDaysJson.map<WorkoutDay>((dayJson) {
                          final exercises = (dayJson['exercises'] as List?)
                              ?.map<Exercise>((e) => Exercise.fromAiJson(e))
                              .toList() ?? [];
                          return WorkoutDay(
                            dayOfMonth: dayJson['day_of_month'],
                            exercises: exercises,
                            notes: dayJson['notes'] ?? '',
                            isRest: dayJson['rest'] ?? false,
                          );
                        }).toList();


                        await _aiService.savePlanToBackend(planTitle, workoutDays);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Plan saved successfully!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      } finally {
                        setState(() => _loading = false);
                      }
                    },
                  ),
                ),
              ),
              buildPlanList(),
            ]
          ],
        ),
      ),
    );
  }
}
