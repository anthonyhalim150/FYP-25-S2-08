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
          values: [120, 90],
        ),
        const SizedBox(height: 10),
        _buildChallengeCard(
          title: 'Squat Challenge',
          target: '1200 Calories',
          duration: '3/3 days',
          participants: ['Brode', 'Cps', 'Loopy'],
          values: [1000, 950, 1200],
        ),
        const SizedBox(height: 10),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Text('• on progress',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Target: $target'),
          Text('Duration: $duration'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(participants.length, (index) {
              final maxVal = values.reduce((a, b) => a > b ? a : b);
              final barHeight = (values[index] / maxVal) * 100;
              return Column(
                children: [
                  Container(
                    width: 20,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: Colors.primaries[index % Colors.primaries.length],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        '${values[index]}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(participants[index],
                      style: const TextStyle(fontSize: 12)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

// -------------------- TOURNAMENT LEADERBOARD --------------------

class TournamentLeaderboardWidget extends StatelessWidget {
  const TournamentLeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          '7 Minutes Sit-Up',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildPodium(2, '@mulanDIY', 87, Colors.lightBlue, 80),
            const SizedBox(width: 8),
            _buildPodium(1, '@jacobHealth', 98, Colors.amber, 110),
            const SizedBox(width: 8),
            _buildPodium(3, '@charlieangel', 79, Colors.orange, 60),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF7F7F7),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              children: const [
                _RankTile(rank: 4, username: '@jake_sim04', score: '75 Sit Ups'),
                _RankTile(rank: 5, username: '@anastasia', score: '73 Sit Ups'),
                _RankTile(rank: 6, username: '@pitBull101', score: '69 Sit Ups'),
                _RankTile(rank: 7, username: '@latteplease', score: '66 Sit Ups'),
                _RankTile(rank: 8, username: '@xChick', score: '64 Sit Ups'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPodium(int rank, String username, int score, Color color, double height) {
    return Column(
      children: [
        CircleAvatar(
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
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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

  const _RankTile(
      {required this.rank, required this.username, required this.score});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('$rank', style: const TextStyle(fontWeight: FontWeight.bold)),
      title: Text(username),
      trailing: Text(score),
    );
  }
}
