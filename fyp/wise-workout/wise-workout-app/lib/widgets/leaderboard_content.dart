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
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text('• on progress', style: TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 4),
            Text('Target: $target'),
            Text('Duration: $duration'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(participants.length, (index) {
                return Column(
                  children: [
                    Container(
                      width: 20,
                      height: 80,
                      color: Colors.primaries[index % Colors.primaries.length],
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            '${values[index]}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(participants[index]),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class TournamentLeaderboardWidget extends StatelessWidget {
  const TournamentLeaderboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          '7 Minutes Sit-Up',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPodium(2, '@mulanDIY', 87, Colors.lightBlue),
            const SizedBox(width: 8),
            _buildPodium(1, '@jacobHealth', 98, Colors.amber),
            const SizedBox(width: 8),
            _buildPodium(3, '@charlieangel', 79, Colors.orange),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              ListTile(leading: Text('4', style: TextStyle(color: Colors.white)), title: Text('@jake_sim04', style: TextStyle(color: Colors.white)), trailing: Text('75 Sit Ups', style: TextStyle(color: Colors.white))),
              ListTile(leading: Text('5', style: TextStyle(color: Colors.white)), title: Text('@anastasia', style: TextStyle(color: Colors.white)), trailing: Text('73 Sit Ups', style: TextStyle(color: Colors.white))),
              ListTile(leading: Text('6', style: TextStyle(color: Colors.white)), title: Text('@pitBull101', style: TextStyle(color: Colors.white)), trailing: Text('69 Sit Ups', style: TextStyle(color: Colors.white))),
              ListTile(leading: Text('7', style: TextStyle(color: Colors.white)), title: Text('@latteplease', style: TextStyle(color: Colors.white)), trailing: Text('66 Sit Ups', style: TextStyle(color: Colors.white))),
              ListTile(leading: Text('8', style: TextStyle(color: Colors.white)), title: Text('@xChick', style: TextStyle(color: Colors.white)), trailing: Text('64 Sit Ups', style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPodium(int rank, String username, int score, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(username, style: const TextStyle(color: Colors.white)),
        Text('$score Sit Ups', style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
