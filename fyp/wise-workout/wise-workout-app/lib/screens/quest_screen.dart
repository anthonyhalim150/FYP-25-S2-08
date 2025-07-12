import 'package:flutter/material.dart';

//sub-widget
import '../widgets/bottom_navigation.dart';

class QuestScreen extends StatelessWidget {
  const QuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF111A43);
    const yellow = Color(0xFFFFD94D);
    const checkColor = Color(0xFF111A43);

    Widget questCard({
      required String text,
      bool done = false,
      Color? backgroundColor,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: done ? checkColor : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (done)
              Icon(Icons.check, color: checkColor, size: 22)
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(
                top: 40, bottom: 30, left: 18, right: 18),
            decoration: const BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(34),
                bottomRight: Radius.circular(34),
              ),
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.arrow_back, color: Colors.white, size: 26),
                  ),
                ),
                const SizedBox(height: 18),
                const Center(
                  child: Text(
                    'Daily Quest',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                const Center(
                  child: Text(
                    'Finish a daily quest and claim the rewards!',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Quest Cards
          questCard(
            text: 'Logged In',
            done: true,
            backgroundColor: yellow,
          ),
          questCard(
            text: 'Do a Strength Workout',
          ),
          questCard(
            text: 'Message a friend',
            done: true,
            backgroundColor: yellow,
          ),
        ],
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