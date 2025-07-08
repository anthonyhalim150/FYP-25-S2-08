import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'themes/app_theme.dart';      // Your "Normal" (default) theme
import 'themes/christmas_theme.dart';
import 'themes/theme_notifier.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/workout_tracker.dart';
import 'screens/challenge_screen.dart';
import 'screens/questionnaires/questionnaire_screen.dart';
import 'screens/questionnaires/questionnaire_screen_2.dart';
import 'screens/questionnaires/questionnaire_screen_3.dart';
import 'screens/questionnaires/questionnaire_screen_4.dart';
import 'screens/questionnaires/questionnaire_screen_5.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/verify_reset_screen.dart';
import 'screens/workout/workout_dashboard.dart';
import 'screens/unregistered_screen.dart';
import 'screens/badge_collection.dart';
import 'screens/wearable_screen.dart';
import 'screens/history_screen.dart';
import 'screens/buypremium_screen.dart';
import 'screens/message_screen.dart';
import 'screens/change_password.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/workout/workout_selection_screen.dart';
import 'screens/workout/exercise_detail_screen.dart';
import 'screens/workout/exercise_start.dart';
import 'screens/workout/workout_analysis_page.dart';
import 'screens/workout/workout_category_dashboard.dart';
import 'screens/workout/workout_list_page.dart';
import 'screens/appearance_screen.dart';
import 'services/exercise_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: WiseWorkoutApp(),
    ),
  );
}

class WiseWorkoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    // Select the theme based on appThemeMode
    ThemeData usedTheme;
    if (themeNotifier.appThemeMode == AppThemeMode.christmas) {
      usedTheme = christmasTheme;
    } else if (themeNotifier.appThemeMode == AppThemeMode.normal) {
      usedTheme = AppTheme.lightTheme; // Your normal theme
    } else {
      // For dark and system, we use the base theme,
      // but MaterialApp will apply the correct theme based on themeMode
      usedTheme = AppTheme.lightTheme;
    }

    return MaterialApp(
      title: 'Wise Workout',
      debugShowCheckedModeBanner: false,
      theme: usedTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.themeMode, // controls switching for dark/system
      initialRoute: '/unregistered',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(userName: ''),
        '/profile': (context) => ProfileScreen(userName: ''),
        '/register': (context) => const RegisterScreen(),
        '/workout': (context) => WorkoutTracker(),
        '/competition': (context) => CompetitionScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/verify-reset': (context) => const VerifyResetScreen(),
        '/unregistered': (context) => const UnregisteredUserPage(),
        '/leaderboard': (context) => const LeaderboardPage(),
        '/badge-collections': (context) => const BadgeCollectionScreen(),
        '/wearable-screen': (context) => const WearableScreen(),
        '/workout-history': (context) => const HistoryScreen(),
        '/premium-plan': (context) => BuyPremiumScreen(),
        '/messages': (context) => const MessageScreen(),
        '/change-password': (context) => ChangePasswordScreen(),
        '/workout-category-dashboard': (context) => WorkoutCategoryDashboard(),
        '/appearance-settings': (context) => AppearanceScreen(),
        '/exercise-detail': (context) => ExerciseDetailScreen(
          exercise: ModalRoute.of(context)!.settings.arguments as Exercise,
        ),
        '/workout-analysis': (context) => const WorkoutAnalysisPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/exercise-start-screen') {
          final exercise = settings.arguments as Exercise;
          return MaterialPageRoute(
            builder: (_) => ExerciseStartScreen(exercise: exercise),
          );
        }
        if (settings.name == '/workout-list-page') {
          final args = settings.arguments as Map<String, dynamic>;
          final categoryKey = args['categoryKey'];
          return MaterialPageRoute(
            builder: (_) => WorkoutListPage(categoryKey: categoryKey),
          );
        }
        return null;
      },
    );
  }
}