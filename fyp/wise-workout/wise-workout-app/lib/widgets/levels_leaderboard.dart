// levels_leaderboard_widget.dart
import 'package:flutter/material.dart';

class LevelsLeaderboardWidget extends StatelessWidget {
  const LevelsLeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> users = [
      {
        'rank': 1,
        'username': '@dragonSlayer',
        'level': 28,
        'image': 'assets/avatars/premium/premium2.png',
      },
      {
        'rank': 2,
        'username': '@fitMaster',
        'level': 26,
        'image': 'assets/avatars/premium/premium3.png',
      },
      {
        'rank': 3,
        'username': '@zenDude',
        'level': 25,
        'image': 'assets/avatars/premium/premium4.png',
      },
      {
        'rank': 4,
        'username': '@aquaStorm',
        'level': 23,
        'image': 'assets/avatars/free/free1.png',
      },
      {
        'rank': 5,
        'username': '@lightSpeed',
        'level': 21,
        'image': 'assets/avatars/free/free2.png',
      },
    ];

    final top3 = users.take(3).toList();
    final others = users.skip(3).toList();

    return Column(
      children: [
        const SizedBox(height: 24),
        const Text(
          'Top Levels',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildTopUser(user: top3[1], size: 60),
            _buildTopUser(user: top3[0], size: 72),
            _buildTopUser(user: top3[2], size: 60),
          ],
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF7F7F7),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.separated(
              itemCount: others.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final user = others[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(user['image']),
                  ),
                  title: Text(user['username'], style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Lv. ${user['level']}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopUser({required Map<String, dynamic> user, required double size}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: size,
          backgroundImage: AssetImage(user['image']),
        ),
        const SizedBox(height: 6),
        Text(
          user['username'],
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          'Lv. ${user['level']}',
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}