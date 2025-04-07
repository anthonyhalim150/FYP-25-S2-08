import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/workout_tracker.dart';
import 'screens/competition_screen.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(WiseWorkoutApp());
}

class WiseWorkoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wise Workout',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/workout': (context) => WorkoutTracker(),
        '/competition': (context) => CompetitionScreen(),
      },
    );
  }
}
