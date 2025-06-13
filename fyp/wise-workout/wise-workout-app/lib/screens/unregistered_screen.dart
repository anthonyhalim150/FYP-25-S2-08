import 'package:flutter/material.dart';
import '../widgets/exercise_stats_card.dart';
import '../widgets/tournament_widget.dart';
import '../widgets/workout_card_home_screen.dart';
import '../widgets/bottom_navigation.dart';
import 'workout_sample_data.dart';

class UnregisteredUserPage extends StatelessWidget {
  final int currentSteps = 3000;
  final int maxSteps = 10000;
  final int caloriesBurned = 250;
  final int xpEarned = 100;

  const UnregisteredUserPage({super.key});

  void _showRegistrationPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Create an Account"),
        content: const Text(
          "Please login or create a account to view more",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Later"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/register');
            },
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }

  Widget _wrapWithPrompt(BuildContext context, Widget child) {
    return GestureDetector(
      onTap: () => _showRegistrationPrompt(context),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with login
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Welcome to FitQuest!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1), // background color
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: _wrapWithPrompt(
                  context,
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: const [
                        SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            'Search on FitQuest',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(Icons.search, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Exercise stats
              _wrapWithPrompt(
                context,
                ExerciseStatsCard(
                  currentSteps: currentSteps,
                  maxSteps: maxSteps,
                  caloriesBurned: caloriesBurned,
                  xpEarned: xpEarned,
                ),
              ),
              const SizedBox(height: 20),

              // Workout title
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Workout",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 10),

              // Workout cards
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: sampleWorkouts.length,
                  itemBuilder: (_, index) {
                    final workout = sampleWorkouts[index];
                    return _wrapWithPrompt(
                      context,
                      WorkoutCardHomeScreen(
                        imagePath: workout.imagePath,
                        workoutName: workout.workoutName,
                        workoutLevel: workout.workoutLevel,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Yellow banner: join challenge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _wrapWithPrompt(
                  context,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF001F6D),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Let's start a journey!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Join challenges or tournaments and reach your fitness goals.",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellow[700],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          child: const Text(
                            "Join a Challenge or Tournament!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Tournaments title
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Tournaments",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 10),

              // Tournament cards
              SizedBox(
                height: 230,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: sampleTournaments.map((tournament) {
                    return _wrapWithPrompt(
                      context,
                      TournamentWidget(
                        tournamentName: tournament.tournamentName,
                        prize: tournament.prize,
                        participants: tournament.participants,
                        daysLeft: tournament.daysLeft,
                        cardWidth: 280,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating action and bottom nav
      floatingActionButton: GestureDetector(
        onTap: () => _showRegistrationPrompt(context),
        child: Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            color: Colors.amber,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.fitness_center, size: 38, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: bottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          _showRegistrationPrompt(context);
        },
      ),
    );
  }
}