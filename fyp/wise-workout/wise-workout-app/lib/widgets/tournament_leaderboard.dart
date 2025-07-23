import 'package:flutter/material.dart';

class TournamentLeaderboardWidget extends StatefulWidget {
  const TournamentLeaderboardWidget({super.key});

  @override
  State<TournamentLeaderboardWidget> createState() =>
      _TournamentLeaderboardWidgetState();
}

class _TournamentLeaderboardWidgetState
    extends State<TournamentLeaderboardWidget> {
  final List<Map<String, dynamic>> tournaments = [
    {
      'title': '7 Minutes Sit-Up',
      'podium': [
        {
          'rank': 2,
          'username': '@mulanDIY',
          'score': 87,
          'color': Colors.lightBlue,
          'height': 80.0,
          'image': 'assets/avatars/free/free2.png',
        },
        {
          'rank': 1,
          'username': '@jacobHealth',
          'score': 98,
          'color': Colors.amber,
          'height': 110.0,
          'image': 'assets/avatars/premium/premium5.png',
        },
        {
          'rank': 3,
          'username': '@charlieangel',
          'score': 79,
          'color': Colors.orange,
          'height': 60.0,
          'image': 'assets/avatars/free/free1.png',
        },
      ],
      'others': [
        {'rank': 4, 'username': '@jake_sim04', 'score': '75 Sit Ups'},
        {'rank': 5, 'username': '@anastasia', 'score': '73 Sit Ups'},
        {'rank': 6, 'username': '@pitBull101', 'score': '69 Sit Ups'},
        {'rank': 7, 'username': '@latteplease', 'score': '66 Sit Ups'},
        {'rank': 8, 'username': '@xChick', 'score': '64 Sit Ups'},
      ],
    },
    {
      'title': '5 Minute Push-Up',
      'podium': [
        {
          'rank': 2,
          'username': '@fitJane',
          'score': 110,
          'color': Colors.lightBlue,
          'height': 100.0,
          'image': 'assets/avatars/free/free3.png',
        },
        {
          'rank': 1,
          'username': '@fitTom',
          'score': 120,
          'color': Colors.amber,
          'height': 115.0,
          'image': 'assets/avatars/premium/premium2.png',
        },
        {
          'rank': 3,
          'username': '@jasonFit',
          'score': 105,
          'color': Colors.orange,
          'height': 95.0,
          'image': 'assets/avatars/free/free1.png',
        },
      ],
      'others': [
        {'rank': 4, 'username': '@alphaZ', 'score': '95 Push Ups'},
        {'rank': 5, 'username': '@runnerX', 'score': '90 Push Ups'},
      ],
    },
  ];

  int currentIndex = 0;

  void _changeChallenge(int direction) {
    setState(() {
      currentIndex = (currentIndex + direction) % tournaments.length;
      if (currentIndex < 0) currentIndex += tournaments.length;
    });
  }

  void _promptJoinChallenge(String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Join Tournament?"),
        content: Text("Do you want to join \"$title\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Joined $title")));
            },
            child: const Text("Join"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;
    final primaryTextColor = theme.colorScheme.onPrimary;

    final tournament = tournaments[currentIndex];
    final title = tournament['title'];
    final podium = tournament['podium'];
    final others = tournament['others'];

    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => _changeChallenge(-1),
              icon: Icon(Icons.chevron_left, color: textColor),
            ),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white, // Always white
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () => _changeChallenge(1),
              icon: Icon(Icons.chevron_right, color: textColor),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildPodium(podium[0], primaryTextColor),
            _buildPodium(podium[1], primaryTextColor),
            _buildPodium(podium[2], primaryTextColor),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[700],
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 6,
            ),
            onPressed: () => _promptJoinChallenge(title),
            child: const Text(
              'Join Challenge',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              children: others.map<Widget>((entry) {
                return ListTile(
                  leading: Text(
                    '${entry['rank']}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  title: Text(
                    entry['username'],
                    style:
                    theme.textTheme.bodyMedium?.copyWith(color: textColor),
                  ),
                  trailing: Text(
                    entry['score'],
                    style:
                    theme.textTheme.bodyMedium?.copyWith(color: textColor),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPodium(Map<String, dynamic> user, Color primaryTextColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(user['image']),
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(height: 6),
        Container(
          width: 40,
          height: user['height'],
          decoration: BoxDecoration(
            color: user['color'],
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${user['rank']}',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user['username'],
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 12), // White text
        ),
        Text(
          '${user['score']} Sit Ups',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 12), // White text
        ),
      ],
    );
  }
}