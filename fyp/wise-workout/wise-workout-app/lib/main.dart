import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/workout_tracker.dart';
import 'screens/competition_screen.dart';
import 'themes/app_theme.dart';
import 'screens/register_screen.dart';
import 'screens/questionnaires/questionnaire_screen.dart';
import 'screens/questionnaires/questionnaire_screen_2.dart';
import 'screens/questionnaires/questionnaire_screen_3.dart';
import 'screens/questionnaires/questionnaire_screen_4.dart';
import 'screens/questionnaires/questionnaire_screen_5.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/verify_reset_screen.dart';

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
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/verify-reset': (context) => const VerifyResetScreen(),
        '/workout': (context) => WorkoutTracker(),
        '/competition': (context) => CompetitionScreen(),
      },
    );
  }
}
