import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppDrawer extends StatelessWidget {
  final String userName;

  const AppDrawer({
    super.key,
    required this.userName,
  });


  Future<void> _logout(BuildContext context) async {
    final secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: 'jwt_cookie');
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Add navigation to settings screen here
            },
          ),
          ListTile(
            leading: const Icon(Icons.track_changes),
            title: const Text('Track Workout'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/workout');
              // Add navigation to settings screen here
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Workout History'),
            onTap: () {
              Navigator.pop(context);
              // Add navigation to workout history here
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text('Achievements'),
            onTap: () {
              Navigator.pop(context);
              // Add navigation to achievements here
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              _logout(context);
            },
          ),
        ],
      ),
    );
  }
}