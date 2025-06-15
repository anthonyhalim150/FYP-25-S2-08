import 'package:flutter/material.dart';

class LeaderboardContent extends StatelessWidget {
  final bool isChallengeSelected;

  const LeaderboardContent({super.key, required this.isChallengeSelected});

  @override
  Widget build(BuildContext context) {
    return isChallengeSelected
        ? const ChallengeLeaderboardWidget()
        : const TournamentLeaderboardWidget();
  }
}

// -------------------- CHALLENGE LEADERBOARD --------------------
class ChallengeLeaderboardWidget extends StatelessWidget {
  const ChallengeLeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildChallengeCard(
          title: 'Push Up Challenge',
          target: '150 Push Ups',
          duration: '5/7 days',
          participants: ['Cps', 'Brode'],
          values: [120, 110],
        ),
        const SizedBox(height: 12),
        _buildChallengeCard(
          title: 'Squat Challenge',
          target: '1200 Calories',
          duration: '3/3 days',
          participants: ['Brode', 'Cps', 'Loopy'],
          values: [1001, 890, 1199],
        ),
        const SizedBox(height: 12),
        _buildChallengeCard(
          title: 'Squat Jump Challenge',
          target: '1200 Calories',
          duration: '2/3 days',
          participants: ['Cps', 'Brode'],
          values: [800, 600],
        ),
      ],
    );
  }

  Widget _buildChallengeCard({
    required String title,
    required String target,
    required String duration,
    required List<String> participants,
    required List<int> values,
  }) {
    final maxVal = values.reduce((a, b) => a > b ? a : b).toDouble();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Text('• on progress',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 6),
          Text('Target: $target', style: const TextStyle(fontSize: 13)),
          Text('Duration: $duration', style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 16),

          // Bars with background container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(participants.length, (index) {
                final barHeight = (values[index] / maxVal) * 100;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 32,
                      height: barHeight + 20,
                      decoration: BoxDecoration(
                        color: _getColor(index),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${values[index]}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(participants[index], style: const TextStyle(fontSize: 12)),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Better colors for clarity and variety
  Color _getColor(int index) {
    const colors = [
      Color(0xFFD32F2F), // Red
      Color(0xFFFFC107), // Amber
      Color(0xFFEC407A), // Pink
      Color(0xFF7E57C2), // Purple
      Color(0xFF26C6DA), // Cyan
    ];
    return colors[index % colors.length];
  }
}


// -------------------- TOURNAMENT LEADERBOARD --------------------
class TournamentLeaderboardWidget extends StatefulWidget {
  const TournamentLeaderboardWidget({super.key});

  @override
  State<TournamentLeaderboardWidget> createState() => _TournamentLeaderboardWidgetState();
}

class _TournamentLeaderboardWidgetState extends State<TournamentLeaderboardWidget> {
  final List<Map<String, dynamic>> tournaments = [
    {
      'title': '7 Minutes Sit-Up',
      'podium': [
        {'rank': 2, 'username': '@mulanDIY', 'score': 87, 'color': Colors.lightBlue, 'height': 80.0},
        {'rank': 1, 'username': '@jacobHealth', 'score': 98, 'color': Colors.amber, 'height': 110.0},
        {'rank': 3, 'username': '@charlieangel', 'score': 79, 'color': Colors.orange, 'height': 60.0},
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
        {'rank': 2, 'username': '@fitJane', 'score': 110, 'color': Colors.lightBlue, 'height': 100.0},
        {'rank': 1, 'username': '@fitTom', 'score': 120, 'color': Colors.amber, 'height': 115.0},
        {'rank': 3, 'username': '@jasonFit', 'score': 105, 'color': Colors.orange, 'height': 95.0},
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Joined $title")));
            },
            child: const Text("Join"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              icon: const Icon(Icons.chevron_left, color: Colors.white),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () => _changeChallenge(1),
              icon: const Icon(Icons.chevron_right, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildPodium(
              podium[0]['rank'],
              podium[0]['username'],
              podium[0]['score'],
              podium[0]['color'],
              podium[0]['height'],
            ),
            _buildPodium(
              podium[1]['rank'],
              podium[1]['username'],
              podium[1]['score'],
              podium[1]['color'],
              podium[1]['height'],
            ),
            _buildPodium(
              podium[2]['rank'],
              podium[2]['username'],
              podium[2]['score'],
              podium[2]['color'],
              podium[2]['height'],
            ),
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
            child: const Text('Join Challenge', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF7F7F7),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              children: others.map<Widget>((entry) {
                return _RankTile(
                  rank: entry['rank'],
                  username: entry['username'],
                  score: entry['score'],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPodium(int rank, String username, int score, Color color, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Container(
          width: 40,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '$rank',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(username, style: const TextStyle(color: Colors.white, fontSize: 12)),
        Text('$score Sit Ups', style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class _RankTile extends StatelessWidget {
  final int rank;
  final String username;
  final String score;

  const _RankTile({
    required this.rank,
    required this.username,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('$rank', style: const TextStyle(fontWeight: FontWeight.bold)),
      title: Text(username),
      trailing: Text(score),
    );
  }
}


