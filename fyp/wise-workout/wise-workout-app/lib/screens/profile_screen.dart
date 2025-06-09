import 'package:flutter/material.dart';
import 'create_avatar.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final int xp;
  final int tokens;
  final String? profileImagePath;
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
    this.xp = 123,
    this.tokens = 27,
    this.isPremiumUser = false,  // SET THIS TO true FOR PREMIUM DEMO (or pass from auth)
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

  @override
  void initState() {
    super.initState();
    _profileImagePath = widget.profileImagePath;
  }

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
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: _profileImagePath != null
                            ? (_profileImagePath!.startsWith('http')
                            ? NetworkImage(_profileImagePath!)
                            : AssetImage(_profileImagePath!)
                        as ImageProvider)
                            : const AssetImage('assets/icons/Profile.png'),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Hi, ${widget.userName}!',
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
                      final newAvatar = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateAvatarScreen(
                            username: widget.userName,
                            isPremiumUser: widget.isPremiumUser,
                            currentAvatarPath: _profileImagePath,
                          ),
                        ),
                      );
                      if (newAvatar != null) {
                        setState(() {
                          _profileImagePath = newAvatar;
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