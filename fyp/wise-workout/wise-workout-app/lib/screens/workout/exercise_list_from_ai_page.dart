import 'package:flutter/material.dart';
import '../model/exercise_model.dart';
import '../../services/exercise_service.dart';
import '../../widgets/exercise_tile.dart';


class ExerciseListFromAIPage extends StatefulWidget {
  final List<String> exerciseNames;
  final String dayLabel;
  const ExerciseListFromAIPage({
    super.key,
    required this.exerciseNames,
    required this.dayLabel,
  });

  @override
  State<ExerciseListFromAIPage> createState() => _ExerciseListFromAIPageState();
}

class _ExerciseListFromAIPageState extends State<ExerciseListFromAIPage> {
  late Future<List<Exercise>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = ExerciseService().fetchExercisesByNames(widget.exerciseNames);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dayLabel),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Exercise>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No exercises found."));
          }
          final exercises = snapshot.data!;
          return ListView.separated(
            itemCount: exercises.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            padding: const EdgeInsets.all(18),
            itemBuilder: (context, index) {
              final ex = exercises[index];
              return ExerciseTile(
                exercise: ex,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/exercise-detail',
                    arguments: ex,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
