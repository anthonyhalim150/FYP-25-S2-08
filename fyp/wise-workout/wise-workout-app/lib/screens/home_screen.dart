import 'package:flutter/material.dart';
import 'package:wise_workout_app/widgets/journey_card.dart';
import 'workout_sample_data.dart';
import '../services/health_service.dart';
import '../services/api_service.dart';
import '../screens/camera/SquatPoseScreen.dart';
import 'buypremium_screen.dart';
//sub-widgets
import '../widgets/workout_card_home_screen.dart';
import '../widgets/tournament_widget.dart';
import '../widgets/app_drawer.dart';
import '../widgets/exercise_stats_card.dart';
import '../widgets/bottom_navigation.dart';


class HomeScreen extends StatefulWidget {
  final String userName;
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

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HealthService _healthService = HealthService();
  int _currentSteps = 0;
  final int maxSteps = 10000;
  final int caloriesBurned = 420;
  final int xpEarned = 150;
  String? _displayName;
  bool _isPremiumUser = false;

  final List<String> unlockedBadges = [
    'assets/badges/badge_4.png',
    'assets/badges/badge_5.png',
    'assets/badges/badge_6.png',
  ];

  @override
  void initState() {
    super.initState();
    fetchTodaySteps();
    _fetchProfile();
  }

  Future<void> fetchTodaySteps() async {
    final connected = await _healthService.connect();
    if (connected) {
      final steps = await _healthService.getTodaySteps();
      setState(() => _currentSteps = steps);
    }
  }

  Future<void> _fetchProfile() async {
    final profile = await ApiService().getCurrentProfile();
    if (profile != null) {
      setState(() {
        _displayName = profile['username'];
        _isPremiumUser = profile['role'] == 'premium';
      });
    }
  }

  Widget buildStatItem(
      BuildContext context,
      IconData icon,
      String label,
      String value,
      ) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.bold),
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

  Widget buildBadgeCollection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/badge-collections'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Badge Collections',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor:
                            Theme.of(context).colorScheme.surface,
                            backgroundImage: index < unlockedBadges.length
                                ? AssetImage(unlockedBadges[index])
                                : const AssetImage('assets/icons/lock.jpg'),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 16, color: Theme.of(context).iconTheme.color),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: appDrawer(
        userName: _displayName ?? widget.userName,
        parentContext: context,
      ),
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
                      'Hello, ${_displayName ?? widget.userName}!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: _isPremiumUser
                            ? colorScheme.onBackground
                            : Colors.grey.withOpacity(0.35),
                      ),
                      onPressed: () {
                        if (_isPremiumUser) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SquatPoseScreen()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BuyPremiumScreen()),
                          );
                        }
                      },
                    ),
                    const Spacer(),
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.menu, color: colorScheme.onBackground),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search on FitQuest',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color:
                                colorScheme.onSurface.withOpacity(0.5)),
                          ),
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(Icons.search, color: colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ExerciseStatsCard(
                currentSteps: _currentSteps,
                maxSteps: maxSteps,
                caloriesBurned: caloriesBurned,
                xpEarned: xpEarned,
              ),
              const SizedBox(height: 20),
              buildBadgeCollection(context),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  "Workout",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: colorScheme.onBackground,
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
              if (_isPremiumUser) JourneyCard(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tournaments",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.normal,
                        color: colorScheme.onBackground,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/challenge-list');
                      },
                      child: Text(
                        "View all",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
                    ...sampleTournaments.map((tournament) => TournamentWidget(
                      tournamentName: tournament.tournamentName,
                      prize: tournament.prize,
                      participants: tournament.participants,
                      daysLeft: tournament.daysLeft,
                      cardWidth: 280,
                    )),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(
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
              Navigator.pushNamed(context, '/workout-category-dashboard');
              break;
            case 3:
              Navigator.pushNamed(context, '/messages');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}