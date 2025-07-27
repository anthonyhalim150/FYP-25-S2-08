import 'package:flutter/material.dart';
import '../widgets/exercise_stats_card.dart';
import '../widgets/tournament_widget.dart';
import '../widgets/workout_card_home_screen.dart';
import '../widgets/bottom_navigation.dart';
import 'workout_sample_data.dart';

class UnregisteredUserPage extends StatelessWidget {
  final int currentSteps = 0;
  final int maxSteps = 0;
  final int caloriesBurned = 0;
  final int xpEarned = 0;

  const UnregisteredUserPage({super.key});

  void _showRegistrationPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Create an Account"),
        content: const Text("Please login or create an account to view more"),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final brightness = theme.brightness;

    final surfaceColor =
    brightness == Brightness.dark ? Colors.grey[800] : colorScheme.surface;
    final hintTextColor =
    brightness == Brightness.dark ? Colors.grey[400] : theme.hintColor;

    final bannerColor = brightness == Brightness.dark
        ? const Color(0xFF1E1E2C)
        : colorScheme.primary;
    final bannerContrast = colorScheme.onPrimary;
    final bannerAccent = colorScheme.secondary;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Welcome to FitQuest!',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: _wrapWithPrompt(
                  context,
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.3)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            'Search on FitQuest',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: hintTextColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child:
                          Icon(Icons.search, color: colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Exercise Stats
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
              // Workout Title
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Workout",
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 10),
              // Workout Cards
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
              // Challenge Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _wrapWithPrompt(
                  context,
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: bannerColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Let's start a challenge!",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: bannerContrast,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Friendly rivalry fires up results. Invite a friend and crush your goals—one challenge at a time!",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: bannerContrast.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: bannerAccent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          child: Text(
                            "Challenge a friend now!",
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSecondary,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tournaments
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Tournaments",
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 10),
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
      bottomNavigationBar: bottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // You don't need to handle anything here
        },
        isRegistered: false, // Important!
      ),
    );
  }
}