import 'package:flutter/material.dart';

class bottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Widget? workoutIcon;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color backgroundColor;

  const bottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.workoutIcon,
    this.selectedItemColor = Colors.amber,
    this.unselectedItemColor = Colors.black54,
    this.backgroundColor = Colors.white,
  });

  // Define image icons here
  static const double _iconSize = 24;

  static Widget _imageIcon(String assetName) {
    return Image.asset(
      'assets/icons/$assetName',
      height: _iconSize,
      fit: BoxFit.contain,
    );
  }

  static final Widget _homeIcon = _imageIcon('Home.png');
  static final Widget _leaderboardIcon = _imageIcon('Leaderboard.png');
  static final Widget _messagesIcon = _imageIcon('Messages.png');
  static final Widget _profileIcon = _imageIcon('Profile.png');

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        BottomNavigationBar(
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          backgroundColor: backgroundColor,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
              icon: _homeIcon,
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _leaderboardIcon,
              label: 'Leader board',
            ),
            const BottomNavigationBarItem(
              icon: SizedBox.shrink(),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _messagesIcon,
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: _profileIcon,
              label: 'Profile',
            ),
          ],
        ),
        Positioned(
          bottom: 40,
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/workout-dashboard'),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: selectedItemColor,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: workoutIcon ??
                    const Icon(Icons.fitness_center, size: 36, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
