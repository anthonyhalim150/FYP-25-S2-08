import 'package:flutter/material.dart';
import '../../services/fitnessai_service.dart';
import '../../services/exercise_service.dart';
import '../model/exercise_model.dart';
import '../model/workout_day_model.dart';

class WorkoutPlanScreen extends StatefulWidget {
  final List<dynamic> plan;

  const WorkoutPlanScreen({Key? key, required this.plan}) : super(key: key);

  @override
  _WorkoutPlanScreenState createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  final AIFitnessPlanService _aiService = AIFitnessPlanService();
  final ExerciseService _exerciseService = ExerciseService();

  bool _loading = false;
  bool _isEditing = false;
  bool _hasChanges = false;
  bool _loadingExercises = false;
  String? _error;
  List<dynamic> _plan = [];
  List<Exercise> _allExercises = [];
  String _planTitle = '';

  @override
  void initState() {
    super.initState();
    _plan = List.from(widget.plan);
    _planTitle = _plan.isNotEmpty && _plan[0]['plan_title'] != null
        ? _plan[0]['plan_title']
        : 'Personalized Plan';
    _fetchAllExercises();
  }

  // Fetch all exercises from database
  Future<void> _fetchAllExercises() async {
    try {
      setState(() => _loadingExercises = true);
      _allExercises = await _exerciseService.fetchAllExercises();
      print('✅ Loaded ${_allExercises.length} exercises from database');
    } catch (e) {
      print('❌ Error fetching exercises: $e');
      setState(() => _error = 'Failed to load exercises: $e');
    } finally {
      setState(() => _loadingExercises = false);
    }
  }

  // Toggle between edit and view mode
  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing && _hasChanges) {
        // Show save confirmation dialog when exiting edit mode with changes
        _showSaveConfirmationDialog();
      }
    });
  }

  // Show exercise selection dialog
  void _addExercise(int dayIndex) {
    if (_allExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No exercises available. Please try again later.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    _showExerciseSelectionDialog(dayIndex);
  }

  // Dialog to select an exercise from all available exercises
  void _showExerciseSelectionDialog(int dayIndex) {
    String searchQuery = '';
    List<Exercise> filteredExercises = _allExercises;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    AppBar(
                      title: const Text('Select Exercise'),
                      automaticallyImplyLeading: false,
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search exercises...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.toLowerCase();
                            filteredExercises = _allExercises
                                .where((exercise) =>
                            exercise.exerciseName.toLowerCase().contains(searchQuery) ||
                                exercise.exerciseDescription.toLowerCase().contains(searchQuery))
                                .toList();
                          });
                        },
                      ),
                    ),
                    // Exercise list
                    Expanded(
                      child: filteredExercises.isEmpty
                          ? const Center(
                        child: Text('No exercises found'),
                      )
                          : ListView.builder(
                        itemCount: filteredExercises.length,
                        itemBuilder: (context, index) {
                          final exercise = filteredExercises[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: ListTile(
                              title: Text(
                                exercise.exerciseName,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                exercise.exerciseDescription,
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(Icons.add_circle, color: Colors.teal),
                              onTap: () {
                                Navigator.pop(context);
                                _showSetRepsDialog(dayIndex, exercise);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Dialog to input sets and reps for selected exercise
  void _showSetRepsDialog(int dayIndex, Exercise exercise) {
    final TextEditingController setsController = TextEditingController(text: '3');
    final TextEditingController repsController = TextEditingController(text: '10');
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add ${exercise.exerciseName}'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: setsController,
                  decoration: const InputDecoration(
                    labelText: 'Sets',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of sets';
                    }
                    final sets = int.tryParse(value);
                    if (sets == null || sets <= 0) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: repsController,
                  decoration: const InputDecoration(
                    labelText: 'Reps',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of reps';
                    }
                    final reps = int.tryParse(value);
                    if (reps == null || reps <= 0) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final sets = int.parse(setsController.text);
                  final reps = int.parse(repsController.text);

                  _addExerciseToDay(dayIndex, exercise, sets, reps);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Add Exercise'),
            ),
          ],
        );
      },
    );
  }

  // Add exercise to specific day
  void _addExerciseToDay(int dayIndex, Exercise exercise, int sets, int reps) {
    setState(() {
      final dayPlan = _plan[dayIndex + 1]; // +1 because first item is plan title
      if (dayPlan['exercises'] == null) {
        dayPlan['exercises'] = [];
      }

      // Add the new exercise
      dayPlan['exercises'].add({
        'name': exercise.exerciseName,
        'sets': sets,
        'reps': reps,
        'exercise_id': exercise.exerciseId,
      });

      _hasChanges = true;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${exercise.exerciseName} added successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Remove exercise from day
  void _removeExercise(int dayIndex, int exerciseIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Exercise'),
          content: const Text('Are you sure you want to remove this exercise?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  final dayPlan = _plan[dayIndex + 1];
                  if (dayPlan['exercises'] != null) {
                    final removedExercise = dayPlan['exercises'][exerciseIndex];
                    dayPlan['exercises'].removeAt(exerciseIndex);
                    _hasChanges = true;

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${removedExercise['name']} removed successfully!'),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  // Show save confirmation dialog
  void _showSaveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Changes'),
          content: const Text('Do you want to save the changes to your workout plan?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _hasChanges = false);
              },
              child: const Text('Discard Changes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _savePlanToDatabase();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }

  // Save plan to database
  Future<void> _savePlanToDatabase() async {
    try {
      setState(() => _loading = true);

      // Convert the plan to WorkoutDay models
      final workoutDays = _aiService.parsePlanToModels(_plan);

      // Save to backend
      await _aiService.savePlanToBackend(_planTitle, workoutDays);

      setState(() {
        _hasChanges = false;
        _isEditing = false; // Exit edit mode after saving
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout plan saved successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('❌ Error saving plan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save plan: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  // Build individual exercise card with edit functionality
  Widget _buildEditableExerciseCard(int dayIndex) {
    final dayPlan = _plan[dayIndex + 1];
    final isRest = dayPlan['rest'] == true;
    final exercises = dayPlan['exercises'] as List? ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day header with add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dayPlan['day_of_month'] != null
                      ? "Day ${dayPlan['day_of_month']}"
                      : "Day ${dayPlan['day']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal,
                  ),
                ),
                if (_isEditing && !isRest)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white, size: 20),
                      onPressed: () => _addExercise(dayIndex),
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Rest day or exercises
            if (isRest) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "🛌 Rest Day",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ] else ...[
              if (exercises.isEmpty && _isEditing)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal[200]!, width: 2, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.fitness_center, color: Colors.teal, size: 32),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _addExercise(dayIndex),
                        style: TextButton.styleFrom(foregroundColor: Colors.teal),
                        child: const Text('Add First Exercise'),
                      ),
                    ],
                  ),
                )
              else
                ...exercises.asMap().entries.map<Widget>((entry) {
                  final exerciseIndex = entry.key;
                  final ex = entry.value;
                  final name = ex['name'] ?? '';
                  final sets = ex['sets']?.toString() ?? '-';
                  final reps = ex['reps']?.toString() ?? '-';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.fitness_center, color: Colors.teal, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sets: $sets  |  Reps: $reps',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_isEditing)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                              onPressed: () => _removeExercise(dayIndex, exerciseIndex),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
            ],

            // Notes section
            if (dayPlan['notes'] != null && dayPlan['notes'].toString().isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        dayPlan['notes'],
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.blue,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Build the workout plan list
  Widget buildPlanList() {
    if (_plan.isEmpty || _plan.length <= 1) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                "No workout plan found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please complete your fitness profile and try again.",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _plan.length - 1,
        itemBuilder: (context, idx) {
          return _buildEditableExerciseCard(idx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasChanges) {
          _showSaveConfirmationDialog();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Workout Plan"),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            // Unsaved changes indicator
            if (_hasChanges)
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: const Icon(Icons.circle, color: Colors.orange, size: 12),
              ),

            // Edit toggle button
            IconButton(
              icon: Icon(_isEditing ? Icons.check : Icons.edit),
              onPressed: _loadingExercises ? null : _toggleEditMode,
              tooltip: _isEditing ? 'Finish Editing' : 'Edit Plan',
            ),

            // Save button (only visible when there are changes)
            if (_hasChanges && !_loading)
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _savePlanToDatabase,
                tooltip: 'Save Changes',
              ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.teal[50]!, Colors.white],
              stops: const [0.0, 0.3],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _loading
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 16),
                  Text('Saving your workout plan...'),
                ],
              ),
            )
                : _loadingExercises
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.teal),
                  SizedBox(height: 16),
                  Text('Loading exercises...'),
                ],
              ),
            )
                : _error != null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(_error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchAllExercises,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and editing indicator
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _planTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    if (_isEditing)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'EDITING',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                // Changes indicator
                if (_hasChanges)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.edit, size: 14, color: Colors.orange),
                        const SizedBox(width: 4),
                        const Text(
                          'You have unsaved changes',
                          style: TextStyle(color: Colors.orange, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 16),

                // Exercise info for editing mode
                if (_isEditing && _allExercises.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.teal[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.teal),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${_allExercises.length} exercises available to add',
                            style: const TextStyle(color: Colors.teal),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Workout plan list
                buildPlanList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}