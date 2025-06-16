  import 'package:flutter/material.dart';
import 'package:wise_workout_app/screens/exercise_detail_screen.dart';
import 'package:wise_workout_app/screens/workout_sample_data.dart';
import 'package:wise_workout_app/screens/workout_selection_screen.dart';
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
  import 'screens/workout_dashboard.dart';
  import 'screens/unregistered_screen.dart';
  import 'screens/badge_collection.dart';
  import 'screens/wearable_screen.dart';
  import 'screens/history_screen.dart';
  import 'screens/editprofile_screen.dart';
  import 'screens/buypremium_screen.dart';
  import 'screens/exercise_detail_screen.dart';
  import 'services/exercise_service.dart';
  import 'screens/leaderboard_screen.dart';
  import 'screens/exercise_start.dart';



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
            userName: '', //Hardcoded btw
          ),
          '/profile': (context) => ProfileScreen(
            userName: '',
          ),
          '/register': (context) => const RegisterScreen(),
          '/workout': (context) => WorkoutTracker(),
          '/competition': (context) => CompetitionScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/verify-reset': (context) => const VerifyResetScreen(),
          '/workout-dashboard': (context) => WorkoutDashboard(),
          '/unregistered': (context) => const UnregisteredUserPage(),
          '/leaderboard': (context) => const LeaderboardPage(),
          '/badge-collections': (context) => const BadgeCollectionScreen(),
          '/profile-settings': (context) => EditProfileScreen(),
          '/wearable-screen' : (context) => const WearableScreen(),
          '/workout-history': (context) => const HistoryScreen(),
          '/premium-plan': (context) => BuyPremiumScreen(),
          '/workout-selection-screen': (ctx) => WorkoutScreen(
            workoutId: ModalRoute.of(ctx)!.settings.arguments as int,
          workoutName: '',categoryName: '',
          ),
          '/exercise-detail': (context) => ExerciseDetailScreen(
            exercise: ModalRoute.of(context)!.settings.arguments as Exercise,
          ),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/exercise-start-screen') {
            final exercise = settings.arguments as Exercise;
            return MaterialPageRoute(
              builder: (_) => ExerciseStartScreen(exercise: exercise),
            );
          }

          // You can handle other dynamic routes here if needed later
          return null;
        },
      );
    }
  }
