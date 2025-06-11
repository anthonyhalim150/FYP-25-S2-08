import 'package:flutter/material.dart';
import 'create_avatar.dart';
import '../services/api_service.dart';
import '../widgets/bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final int xp;
  final int tokens;
  final String? profileImagePath;
  final String? profileBgPath;
  final bool isPremiumUser;

  // Optional icons for bottom navigation bar.
  final Widget? homeIcon;
  final Widget? leaderboardIcon;
  final Widget? messagesIcon;
  final Widget? profileIcon;
  final Widget? workoutIcon;

  const ProfileScreen({
    Key? key,
    required this.userName,
    this.profileImagePath,
    this.profileBgPath,
    this.xp = 123,
    this.tokens = 27,
    this.isPremiumUser = false,
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
  late String _userName;
  late bool _isPremiumUser;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _profileImagePath = widget.profileImagePath;
    _profileBgPath = widget.profileBgPath ?? 'assets/background/black.jpg';
    _isPremiumUser = widget.isPremiumUser;
    _userName = widget.userName;
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await apiService.getCurrentProfile();
      setState(() {
        _isPremiumUser = profile['role'] == 'premium';
        _profileImagePath = profile['avatar'] ?? 'assets/icons/Profile.png';
        _profileBgPath = profile['background'] ?? 'assets/background/black.jpg';
        _userName = profile['username'] ?? widget.userName;
      });
    } catch (e) {
      print('Failed to load profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: _profileBgPath != null && _profileBgPath!.startsWith('http')
                      ? Image.network(
                    _profileBgPath!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    _profileBgPath ?? 'assets/background/black.jpg',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                CircleAvatar(
                  radius: 54,
                  backgroundImage: _profileImagePath != null
                      ? (_profileImagePath!.startsWith('http')
                      ? NetworkImage(_profileImagePath!)
                      : AssetImage(_profileImagePath!) as ImageProvider)
                      : const AssetImage('assets/icons/Profile.png'),
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Hi, $_userName!',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (_isPremiumUser)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  '🌟 Premium User 🌟',
                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            const SizedBox(height: 20),

            // 🔹 Badge Collections Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/badge-collections');
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Badge Collections',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(
                                4,
                                    (index) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 XP + Level
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

            // 🔹 Lucky Spin
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/lucky-spin'),
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
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 4),
                        Text("${widget.tokens} Tokens", style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                    const Icon(Icons.stars, color: Colors.amber, size: 32),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Scrollable Profile Settings
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
                            username: _userName,
                            isPremiumUser: _isPremiumUser,
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
              Navigator.pushNamed(context, '/workout-dashboard');
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

  Widget _infoCard(BuildContext context, String label, String value) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _profileItem(IconData icon, String label, {String? subtitle, VoidCallback? onTap}) {
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