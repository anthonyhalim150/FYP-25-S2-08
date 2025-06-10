import 'package:flutter/material.dart';
import 'package:wise_workout_app/widgets/journey_card.dart';
import '../widgets/workout_card_home_screen.dart';
import '../widgets/tournament_widget.dart';
import 'workout_sample_data.dart';
import 'competition_screen.dart';
import '../widgets/app_drawer.dart'; // Import the new drawer file
import '../widgets/journey_card.dart';
import '../widgets/exercise_stats_card.dart';

class HomeScreen extends StatelessWidget {
  final String userName;
  final int currentSteps = 8542;
  final int maxSteps = 10000;
  final int caloriesBurned = 420;
  final int xpEarned = 150;

  final Widget? homeIcon;
  final Widget? leaderboardIcon;
  final Widget? messagesIcon;
  final Widget? profileIcon;
  final Widget? workoutIcon;

  const HomeScreen({
    super.key,
    required this.userName,
    this.homeIcon,
    this.leaderboardIcon,
    this.messagesIcon,
    this.profileIcon,
    this.workoutIcon,
  });

  Widget _buildStatItem(BuildContext context, IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: appDrawer(userName: userName, parentContext: context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                child: Row(
                  children: [
                    Text(
                      'Hello, $userName!',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Rest of your existing home screen content...
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search on FitQuest',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(Icons.search, color: Colors.black),
                      ),],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Exercise Gauge
              ExerciseStatsCard(
                currentSteps: currentSteps,
                maxSteps: maxSteps,
                caloriesBurned: caloriesBurned,
                xpEarned: xpEarned,
              ),

              const SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  "Workout",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Workout Cards
              SizedBox(
                height: 147,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: sampleWorkouts
                      .map((workout) => WorkoutCardHomeScreen(
                    imagePath: workout.imagePath,
                    workoutName: workout.workoutName,
                    workoutLevel: workout.workoutLevel,
                  ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              const JourneyCard(),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  "Tournaments",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    const SizedBox(width: 5),
                    ...sampleTournaments
                        .map((tournament) => TournamentWidget(
                      tournamentName: tournament.tournamentName,
                      prize: tournament.prize,
                      participants: tournament.participants,
                      daysLeft: tournament.daysLeft,
                      cardWidth: 280,
                    ))
                        .toList(),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.black54,
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/home');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/leaderboard');
                  break;
                case 2:
                  break;
                case 3:
                  Navigator.pushNamed(context, '/messages');
                  break;
                case 4:
                  Navigator.pushNamed(context, '/profile');
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: homeIcon ?? const Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: leaderboardIcon ?? const Icon(Icons.leaderboard),
                label: 'Leader board',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: messagesIcon ?? const Icon(Icons.message),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: profileIcon ?? const Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/workout-dashboard'),
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),]
                ),
                child: Center(
                  child: workoutIcon ??
                      const Icon(Icons.fitness_center, size: 36, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}