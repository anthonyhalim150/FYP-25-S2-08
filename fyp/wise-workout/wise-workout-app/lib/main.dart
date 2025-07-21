import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'services/notification_service.dart';

import 'themes/app_theme.dart';
import 'themes/christmas_theme.dart';
import 'themes/theme_notifier.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/workout_tracker.dart';
import 'screens/challenge_screen(removed).dart';
import 'screens/questionnaires/questionnaire_screen.dart';
import 'screens/questionnaires/questionnaire_screen_2.dart';
import 'screens/questionnaires/questionnaire_screen_3.dart';
import 'screens/questionnaires/questionnaire_screen_4.dart';
import 'screens/questionnaires/questionnaire_screen_5.dart';
import 'screens/questionnaires/questionnaire_screen_6.dart';
import 'screens/questionnaires/questionnaire_screen_7.dart';
import 'screens/questionnaires/questionnaire_screen_8.dart';
import 'screens/questionnaires/questionnaire_screen_9.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/verify_reset_screen.dart';
import 'screens/unregistered_screen.dart';
import 'screens/badge_collection.dart';
import 'screens/wearable_screen.dart';
import 'screens/history_screen.dart';
import 'screens/buypremium_screen.dart';
import 'screens/message_screen.dart';
import 'screens/change_password.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/workout/exercise_detail_screen.dart';
import 'screens/workout/workout_analysis_page.dart';
import 'screens/workout/workout_category_dashboard.dart';
import 'screens/workout/workout_list_page.dart';
import 'screens/appearance_screen.dart';
import 'screens/language_settings_screen.dart';
import 'services/exercise_service.dart';
import 'screens/model/exercise_model.dart';
import 'screens/workout/exercise_list_page.dart';
import 'screens/view_challenge_tournament_screen.dart';
import 'screens/workout/exercise_log_page.dart';
import 'screens/workout/daily_summary_page.dart';
import 'screens/workout/weekly_monthly_summary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await NotificationService.init();

  final storage = FlutterSecureStorage();
  String? langCode = await storage.read(key: 'language_code');
  Locale initialLocale = langCode != null
      ? Locale(langCode)
      : const Locale('en');

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('id'),
        Locale('zh'),
        Locale('ms'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      startLocale: initialLocale,
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const WiseWorkoutApp(),
      ),
    ),
  );
}

class WiseWorkoutApp extends StatelessWidget {
  const WiseWorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    ThemeData usedTheme;
    if (themeNotifier.appThemeMode == AppThemeMode.christmas) {
      usedTheme = christmasTheme;
    } else if (themeNotifier.appThemeMode == AppThemeMode.normal) {
      usedTheme = AppTheme.lightTheme;
    } else {
      usedTheme = AppTheme.lightTheme;
    }

    return MaterialApp(
      title: 'Wise Workout',
      debugShowCheckedModeBanner: false,
      theme: usedTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: '/unregistered',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(userName: ''),
        '/profile': (context) => ProfileScreen(userName: ''),
        '/register': (context) => const RegisterScreen(),
        '/workout': (context) => WorkoutTracker(),
        '/competition': (context) => ChallengeScreen(),
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
        '/language-settings': (context) => const LanguageSettingsScreen(),
        '/dailySummary': (context) => const DailySummaryPage(),
        '/weekly-monthly-summary': (context) => const WeeklyMonthlySummaryPage(),

      },
        onGenerateRoute: (settings) {
          if (settings.name == '/workout-list-page') {
            final args = settings.arguments as Map<String, dynamic>;
            final categoryKey = args['categoryKey'];  // Extract categoryKey
            return MaterialPageRoute(
              builder: (_) => WorkoutListPage(categoryKey: categoryKey),
            );
          }

          if (settings.name == '/exercise-list-page') {
            final args = settings.arguments as Map<String, dynamic>;
            final workoutId = args['workoutId'];  // Extract workoutId
            final workoutName = args['workoutName'];  // Extract workoutName

            return MaterialPageRoute(
              builder: (_) => ExerciseListPage(
                workoutId: workoutId,  // Pass workoutId
                workoutName: workoutName,
              ),
            );
          }// Fallback for unknown routes


        if (settings.name == '/exercise-log') {
          final Exercise exercise = settings.arguments as Exercise;
          return MaterialPageRoute(
            builder: (context) => ExerciseLogPage(exercise: exercise),
          );
        }
        if (settings.name == '/challenge-list') {
          final args = settings.arguments as Map<String, dynamic>;
          final bool isPremium = args['isPremium'] ?? false;

          return MaterialPageRoute(
            builder: (_) => ViewChallengeTournamentScreen(isPremium: isPremium),
          );
        }
        return null;
      },
    );
  }
}
