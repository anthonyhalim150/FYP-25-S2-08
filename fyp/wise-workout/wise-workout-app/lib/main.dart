  import 'package:flutter/material.dart';
  import 'screens/login_screen.dart';
  import 'screens/home_screen.dart';
  import 'screens/profile_screen.dart';
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
  import 'screens/lucky_spin_screen.dart';
  import 'screens/workout_dashboard.dart';
  import 'screens/unregistered_screen.dart';
  import 'screens/badge_collection.dart';


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
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/unregistered',
        routes: {
          '/': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(
            userName: 'John', //Hardcoded btw
          ),
          '/profile': (context) => ProfileScreen(
            userName: 'John',
          ),
          '/register': (context) => const RegisterScreen(),
          '/workout': (context) => WorkoutTracker(),
          '/competition': (context) => CompetitionScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/verify-reset': (context) => const VerifyResetScreen(),
          '/lucky-spin': (context) => const LuckySpinScreen(),
          '/workout-dashboard': (context) => WorkoutDashboard(),
          '/unregistered': (context) => const UnregisteredUserPage(),
          '/badge-collections': (context) => const BadgeCollectionScreen(),
        },
      );
    }
  }
