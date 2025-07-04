import 'package:flutter/material.dart';
import '../model/workout_model.dart';
import '../../services/workout_service_try.dart';
import '../../widgets/workout_tile.dart';

class WorkoutListPage extends StatefulWidget {
  final String categoryKey;

  const WorkoutListPage({super.key, required this.categoryKey});

  @override
  State<WorkoutListPage> createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  late Future<List<Workout>> workoutList;
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    workoutList = WorkoutService().fetchWorkoutsByCategory(widget.categoryKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomInset: true,
      body: FutureBuilder<List<Workout>>(
        future: workoutList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No workouts found."));
          }

          final workouts = snapshot.data!
              .where((workout) => workout.workoutName
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
              .toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 280,
                backgroundColor: Colors.white10,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 25, bottom: 16),
                  title: Text(
                    widget.categoryKey.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.orange, // 👈 Set your desired color here
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/workoutCategory/${widget.categoryKey}.jpg',
                        fit: BoxFit.cover,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black54],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Curved container that wraps all content
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar
                        TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Search on FitQuest',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Workout count
                        Text(
                          '${workouts.length} Workouts Found',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Workouts list inside the same container
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: workouts.length,
                          itemBuilder: (context, index) {
                            final workout = workouts[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: WorkoutTile(
                                workout: workout,
                                onTap: () {
                                  print('Tapped on ${workout.workoutName}');
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
