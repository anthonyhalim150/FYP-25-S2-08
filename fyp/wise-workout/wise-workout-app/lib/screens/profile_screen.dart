import 'package:flutter/material.dart';
import 'create_avatar.dart'; // Your avatar creator file

class ProfileScreen extends StatefulWidget {
  final String userName;
  final int xp;
  final int tokens;
  final String? profileImagePath;
  final String? profileBgPath; // Add this if you support avatar background
  final bool isPremiumUser;
  final Widget? homeIcon;
  final Widget? leaderboardIcon;
  final Widget? messagesIcon;
  final Widget? profileIcon;
  final Widget? workoutIcon;

  const ProfileScreen({
    Key? key,
    required this.userName,
    this.profileImagePath,
    this.profileBgPath, // Pass in your user's avatar background if you want
    this.xp = 123,
    this.tokens = 27,
    this.isPremiumUser = true,
    this.homeIcon,
    this.leaderboardIcon,
    this.messagesIcon,
    this.profileIcon,
    this.workoutIcon,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String? _profileImagePath;
  late String? _profileBgPath;

  @override
  void initState() {
    super.initState();
    _profileImagePath = widget.profileImagePath;
    _profileBgPath = widget.profileBgPath ??
        'assets/background/black.jpg'; // Default bg if none set
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      body: SafeArea(
        child: Column(
          children: [
            // Avatar + BG preview at the top
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // BG image circle
                  ClipOval(
                    child: Image.asset(
                      _profileBgPath ?? 'assets/background/black.jpg',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Avatar
                  CircleAvatar(
                    radius: 54,
                    backgroundImage: _profileImagePath != null
                        ? (_profileImagePath!.startsWith('http')
                        ? NetworkImage(_profileImagePath!)
                        : AssetImage(_profileImagePath!)
                    as ImageProvider)
                        : const AssetImage('assets/icons/Profile.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Hi, ${widget.userName}!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // XP and Level Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _infoCard(context, "XP", "${widget.xp} XP"),
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
                              fontSize: 18,
                            )),
                        const SizedBox(height: 4),
                        Text("${widget.tokens} Tokens",
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
                  _profileItem(
                    Icons.person,
                    "Avatar",
                    onTap: () async {
                      final result = await Navigator.push<Map<String, String?>>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateAvatarScreen(
                            username: widget.userName,
                            isPremiumUser: widget.isPremiumUser,
                            currentAvatarPath: _profileImagePath,
                            currentBgPath: _profileBgPath,
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          _profileImagePath = result['avatar'];
                          _profileBgPath = result['background'];
                        });
                      }
                    },
                  ),
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
                icon: widget.homeIcon ?? const Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: widget.leaderboardIcon ?? const Icon(Icons.leaderboard),
                label: 'Leader board',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: widget.messagesIcon ?? const Icon(Icons.message),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: widget.profileIcon ?? const Icon(Icons.person),
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
                  child: widget.workoutIcon ??
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

  Widget _profileItem(
      IconData icon,
      String label, {
        String? subtitle,
        VoidCallback? onTap,
      }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: Colors.purple[300]),
      title: Text(label),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}