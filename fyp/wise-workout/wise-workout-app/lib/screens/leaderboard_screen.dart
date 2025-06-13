import 'package:flutter/material.dart';
import '../widgets/leaderboard_content.dart'; // The widget we'll create for the middle content
import '../widgets/bottom_navigation.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  int _currentIndex = 1; // Leaderboard is at index 1
  bool _isChallengeSelected = true;

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Navigate based on index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
      // Already on leaderboard
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/messages');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1C3A), // Dark background like image
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/profile');
          },
        ),
        title: const Text('Leaderboard', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleButton('Challenge', _isChallengeSelected, () {
                  setState(() {
                    _isChallengeSelected = true;
                  });
                }),
                const SizedBox(width: 8),
                _buildToggleButton('Tournament', !_isChallengeSelected, () {
                  setState(() {
                    _isChallengeSelected = false;
                  });
                }),
              ],
            ),
          ),
          Expanded(
            child: LeaderboardContent(isChallengeSelected: _isChallengeSelected),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.amber : Colors.grey.shade700,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
