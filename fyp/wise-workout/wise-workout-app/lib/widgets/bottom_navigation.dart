import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Widget? homeIcon;
  final Widget? leaderboardIcon;
  final Widget? messagesIcon;
  final Widget? profileIcon;
  final Widget? workoutIcon;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final Color backgroundColor;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.homeIcon,
    this.leaderboardIcon,
    this.messagesIcon,
    this.profileIcon,
    this.workoutIcon,
    this.selectedItemColor = Colors.amber,
    this.unselectedItemColor = Colors.black54,
    this.backgroundColor = Colors.white,
  });

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
          icon: homeIcon ?? _buildDefaultIcon('assets/icons/Home.png'),
          activeIcon: homeIcon ?? _buildDefaultIcon('assets/icons/Home.png', isActive: true),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: leaderboardIcon ?? _buildDefaultIcon('assets/icons/Leaderboard.png'),
          activeIcon: leaderboardIcon ?? _buildDefaultIcon('assets/icons/Leaderboard.png', isActive: true),
          label: 'Leader board',
        ),
        const BottomNavigationBarItem(
          icon: SizedBox.shrink(),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: messagesIcon ?? _buildDefaultIcon('assets/icons/Messages.png'),
          activeIcon: messagesIcon ?? _buildDefaultIcon('assets/icons/Messages.png', isActive: true),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: profileIcon ?? _buildDefaultIcon('assets/icons/Profile.png'),
          activeIcon: profileIcon ?? _buildDefaultIcon('assets/icons/Profile.png', isActive: true),
          label: 'Profile',
        ),
      ],
    ),
    Positioned(
    bottom: 40,
    child: GestureDetector(
    onTap: () => onTap(2),
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
    )],
    ),
    child: Center(
    child: workoutIcon ?? _buildDefaultIcon('assets/icons/Workout.png', size: 36),
    ),
    ),
    ),
    ),
    ],
    );
  }

  Widget _buildDefaultIcon(String assetPath, {bool isActive = false, double size = 24}) {
    return Image.asset(
      assetPath,
      height: size,
      width: size,
      fit: BoxFit.contain,
      color: isActive ? selectedItemColor : unselectedItemColor,
    );
  }
}