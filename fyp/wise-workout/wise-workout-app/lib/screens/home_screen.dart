import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/workout_card_home_screen.dart';
import '../widgets/exercise_gauge.dart';

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

  void logout(BuildContext context) async {
    final secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: 'jwt_cookie');
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

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
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.black),
                      onSelected: (value) {
                        if (value == 'logout') {
                          logout(context);
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Text('Logout'),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ),

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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Exercise Gauge
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 160,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SizedBox(
                              width: 300,
                              height: 210,
                              child: ExerciseGauge(
                                progress: currentSteps / maxSteps,
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                progressColor: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Positioned(
                              top: 98,
                              left: 5,
                              right: 20,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildStatItem(context, Icons.directions_walk, "Steps", "$currentSteps/$maxSteps"),
                                  const SizedBox(width: 10),
                                  _buildStatItem(context, Icons.local_fire_department, "Calories", "$caloriesBurned"),
                                  const SizedBox(width: 20),
                                  _buildStatItem(context, Icons.star, "XP", "$xpEarned"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
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
                  children: [
                    WorkoutCardHomeScreen(
                      imagePath: 'assets/images/push-up.jpg',
                      workoutName: 'Push Ups',
                      workoutLevel: 'Beginner Level',
                    ),
                    WorkoutCardHomeScreen(
                      imagePath: 'assets/images/squats.jpg',
                      workoutName: 'Squats',
                      workoutLevel: 'Beginner Level',
                    ),
                    WorkoutCardHomeScreen(
                      imagePath: 'assets/images/plank.jpg',
                      workoutName: 'Plank',
                      workoutLevel: 'Beginner Level',
                    ),
                    WorkoutCardHomeScreen(
                      imagePath: 'assets/images/jumping_jacks.jpg',
                      workoutName: 'Jumping Jacks',
                      workoutLevel: 'Beginner Level',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 370,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF071655), // Navy background
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Let's start a journey!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Lorem Ipsum lorem ipsum placeholder. We will explain in marketing way.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // TODO: Add action
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFE066), Color(0xFFFFC300)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Join a Challenge or Tournament!",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
              onTap: () => Navigator.pushNamed(context, '/workout'),
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
                    )
                  ],
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