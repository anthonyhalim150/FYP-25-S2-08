import 'package:flutter/material.dart';
import 'dart:async';
import 'questionnaire_screen_dob.dart';

class SplashAndOnboardingWrapper extends StatefulWidget {
  const SplashAndOnboardingWrapper({super.key});

  @override
  State<SplashAndOnboardingWrapper> createState() => _SplashAndOnboardingWrapperState();
}

class _SplashAndOnboardingWrapperState extends State<SplashAndOnboardingWrapper> {
  bool showOnboarding = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      setState(() {
        showOnboarding = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return showOnboarding ? const OnboardingScreen() : const SplashScreen();
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4ED),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('WELCOME TO', style: TextStyle(fontSize: 30)),
            Image.asset(
              'assets/icons/fitquest-icon.png',
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4ED),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.fitness_center, size: 60, color: Colors.amber),
                const SizedBox(height: 20),
                const Text(
                  "We’re excited to have you on board!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Let’s begin with a few questions to customize your experience and support your fitness goals!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuestionnaireDobScreen(step: 1, responses: {}),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      "Let's Get Started!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
