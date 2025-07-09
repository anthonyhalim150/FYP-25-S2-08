import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'create_avatar.dart';
import '../services/api_service.dart';
import '../widgets/bottom_navigation.dart';
import 'editprofile_screen.dart';
import 'privacypolicy_screen.dart';
// Sub-widgets
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_badge_collection.dart';
import '../widgets/profile_info_row.dart';
import '../widgets/profile_lucky_spin_card.dart';
import '../widgets/profile_menu_list.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final int xp;
  final String? profileImagePath;
  final String? profileBgPath;
  final bool isPremiumUser;

  ProfileScreen({
    Key? key,
    required this.userName,
    this.profileImagePath,
    this.profileBgPath,
    this.xp = 123,
    this.isPremiumUser = false,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String? _profileImagePath;
  late String? _profileBgPath;
  late String _userName;
  late String? _dob;
  late bool _isPremiumUser;
  int _tokens = 23;
  final ApiService apiService = ApiService();
  Map<String, dynamic> _profileData = {};
  final List<String> unlockedBadges = [
    'assets/badges/badge_4.png',
    'assets/badges/badge_5.png',
    'assets/badges/badge_6.png',
  ];

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String _selectedLanguageCode = 'en';

  @override
  void initState() {
    super.initState();
    _profileImagePath = widget.profileImagePath;
    _profileBgPath = widget.profileBgPath ?? 'assets/background/black.jpg';
    _isPremiumUser = widget.isPremiumUser;
    _userName = widget.userName;
    _loadProfile();
    _loadLanguagePreference();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await apiService.getCurrentProfile();
      if (!mounted) return;
      setState(() {
        _profileData = profile;
        _isPremiumUser = profile['role'] == 'premium';
        _profileImagePath = profile['avatar'];
        _profileBgPath = profile['background'] ?? 'assets/background/black.jpg';
        _userName = profile['username'] ?? widget.userName;
        _dob = profile['dob'];
        _tokens = profile['tokens'] ?? 0;
      });
    } catch (e) {
      print('Failed to load profile: $e');
    }
  }

  Future<void> _loadLanguagePreference() async {
    final storedCode = await _secureStorage.read(key: 'language_code');
    if (storedCode != null && mounted) {
      setState(() {
        _selectedLanguageCode = storedCode;
      });
    }
  }

  String _languageNameFromCode(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'id':
        return 'Bahasa Indonesia';
      case 'zh':
        return 'Chinese';
      case 'ms':
        return 'Malay';
      default:
        return 'English';
    }
  }

  void _showAvatarPopup(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (_profileBgPath != null)
                    ClipOval(
                      child: _profileBgPath!.startsWith('http')
                          ? Image.network(_profileBgPath!,
                          width: 220, height: 220, fit: BoxFit.cover)
                          : Image.asset(_profileBgPath!,
                          width: 220, height: 220, fit: BoxFit.cover),
                    ),
                  if (_profileImagePath != null && _profileImagePath!.isNotEmpty)
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: _profileImagePath!.startsWith('http')
                          ? NetworkImage(_profileImagePath!)
                          : AssetImage(_profileImagePath!) as ImageProvider<Object>,
                      backgroundColor: Colors.transparent,
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(_userName, style: Theme.of(context).textTheme.titleLarge),
              if (_isPremiumUser)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '🌟 Premium User 🌟',
                    style: TextStyle(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileItem(IconData icon, String label,
      {String? subtitle, VoidCallback? onTap}) {
    VoidCallback? handleTap = onTap;
    if (handleTap == null) {
      switch (label) {
        case "Avatar":
          handleTap = () async {
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
          };
          break;
        case "Profile":
          handleTap = () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditProfileScreen(
                  firstName: _profileData['firstName'] ?? '',
                  lastName: _profileData['lastName'] ?? '',
                  username: _profileData['username'] ?? '',
                  dob: _profileData['dob'] ?? '',
                  email: _profileData['email'] ?? '',
                  level: "Beginner",
                  accountType: _profileData['role'] ?? 'user',
                  profileImage: _profileImagePath ?? '',
                  backgroundImage: _profileBgPath ?? 'assets/background/black.jpg',
                ),
              ),
            );
            if (result != null) {
              _loadProfile();
            }
          };
          break;
        case "Password":
          handleTap = () => Navigator.pushNamed(context, '/change-password');
          break;
        case "Wearable":
          handleTap = () => Navigator.pushNamed(context, '/wearable-screen');
          break;
        case "Workout History":
          handleTap = () => Navigator.pushNamed(context, '/workout-history');
          break;
        case "Body Metrics":
          handleTap = () => Navigator.pushNamed(context, '/body-metrics');
          break;
        case "Notifications":
          handleTap = () => Navigator.pushNamed(context, '/notification-settings');
          break;
        case "Premium Plan":
          handleTap = () => Navigator.pushNamed(context, '/premium-plan');
          break;
        case "Language":
          handleTap = () async {
            await Navigator.pushNamed(context, '/language-settings');
            _loadLanguagePreference();
          };
          break;
        case "Privacy Policy":
          handleTap = () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
          );
          break;
        case "Appearance":
          handleTap = () => Navigator.pushNamed(context, '/appearance-settings');
          break;
        default:
          print('No route defined for $label');
          break;
      }
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))
          : null,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).iconTheme.color),
      onTap: handleTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ProfileAvatarSection(
              profileImg: _profileImagePath,
              profileBg: _profileBgPath,
              username: _userName,
              isPremiumUser: _isPremiumUser,
              onAvatarTap: () => _showAvatarPopup(context),
            ),
            const SizedBox(height: 20),
            ProfileBadgeCollection(unlockedBadges: unlockedBadges), // update it to use theme!
            const SizedBox(height: 20),
            ProfileInfoRow(xp: "${widget.xp} XP", level: "Beginner"), // update it to use theme!
            const SizedBox(height: 20),
            ProfileLuckySpinCard(
              tokens: _tokens,
              onSpinComplete: (newTokens) => setState(() {
                _tokens = newTokens;
              }),
            ),
            const SizedBox(height: 20),
            ProfileMenuList(
              isPremiumUser: _isPremiumUser,
              menuItems: [
                _profileItem(Icons.person, "Avatar"),
                _profileItem(Icons.settings, "Profile", subtitle: "Username, Phone, etc."),
                _profileItem(Icons.lock, "Password"),
                _profileItem(Icons.watch, "Wearable", subtitle: "Redmi Watch Active 3"),
                _profileItem(Icons.history, "Workout History"),
                _profileItem(Icons.bar_chart, "Body Metrics"),
                _profileItem(Icons.notifications, "Notifications"),
                if (!_isPremiumUser)
                  _profileItem(Icons.workspace_premium, "Premium Plan"),
                _profileItem(Icons.language, "Language", subtitle: _languageNameFromCode(_selectedLanguageCode)),
                _profileItem(Icons.privacy_tip, "Privacy Policy"),
                _profileItem(Icons.palette, "Appearance", subtitle: "Default"),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(
        currentIndex: 4,
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
}