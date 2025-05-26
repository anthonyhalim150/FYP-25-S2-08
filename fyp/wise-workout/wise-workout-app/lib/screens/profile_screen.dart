import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final int xp;
  final int tokens;

  final Widget? homeIcon;
  final Widget? leaderboardIcon;
  final Widget? messagesIcon;
  final Widget? profileIcon;
  final Widget? workoutIcon;

  const ProfileScreen({
    super.key,
    required this.userName,
    this.xp = 123,
    this.tokens = 27,
    this.homeIcon,
    this.leaderboardIcon,
    this.messagesIcon,
    this.profileIcon,
    this.workoutIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFDCB39),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/icons/Profile.png'),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Hi, $userName!',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        4,
                            (_) => const CircleAvatar(
                          backgroundColor: Color(0xFFDADADA),
                          radius: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // XP and Level Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _infoCard(context, "XP", "$xp XP"),
                  const SizedBox(width: 15),
                  _infoCard(context, "Level", "Beginner"),
                ],
              ),
            ),

            const SizedBox(height: 20),

// Lucky Spin Card (Clickable)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/lucky-spin');
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF071655),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Lucky Spin",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        const SizedBox(height: 4),
                        Text("$tokens Tokens",
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                    const Icon(Icons.stars, color: Colors.amber, size: 32),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Profile Settings List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _profileItem(Icons.person, "Avatar"),
                  _profileItem(Icons.settings, "Profile", subtitle: "Username, Phone, etc."),
                  _profileItem(Icons.lock, "Password"),
                  _profileItem(Icons.watch, "Wearable", subtitle: "Redmi Watch Active 3"),
                  _profileItem(Icons.history, "Workout History"),
                  _profileItem(Icons.bar_chart, "Body Metrics"),
                  _profileItem(Icons.notifications, "Notifications"),
                  _profileItem(Icons.workspace_premium, "Premium Plan"),
                  _profileItem(Icons.language, "Language", subtitle: "English"),
                  _profileItem(Icons.privacy_tip, "Privacy Policy"),
                  _profileItem(Icons.palette, "Appearance", subtitle: "Default"),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation with FAB
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            selectedItemColor: Colors.amber,
            unselectedItemColor: Colors.black54,
            backgroundColor: Colors.white,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            currentIndex: 4, // This is Profile
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/home');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/leaderboard');
                  break;
                case 2:
                  break;
                case 3:
                  Navigator.pushNamed(context, '/messages');
                  break;
                case 4:
                  break; // Already on Profile
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: homeIcon ?? const Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: leaderboardIcon ?? const Icon(Icons.leaderboard),
                label: 'Leader board',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: messagesIcon ?? const Icon(Icons.message),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: profileIcon ?? const Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/workout'),
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    )
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
      ),
    );
  }

  Widget _infoCard(BuildContext context, String label, String value) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.black54),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileItem(IconData icon, String label, {String? subtitle}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: Colors.purple[300]),
      title: Text(label),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
