// lib/screens/view_challenge_tournament_screen.dart
import 'package:flutter/material.dart';
import '../widgets/viewCTwidget.dart';

class ViewChallengeTournamentScreen extends StatelessWidget {
  final bool isPremium;
  const ViewChallengeTournamentScreen({super.key, required this.isPremium});

  @override
  Widget build(BuildContext context) {
    final challenges = [
      {'title': 'Push Up Challenge', 'target': '150 Push Ups', 'duration': '7 days'},
      {'title': 'Squat Challenge', 'target': '1,200 Calories', 'duration': '3 days'},
      {'title': 'Jumping Jack Blitz', 'target': '900 jumping jacks', 'duration': '5 days'},
    ];

    final tournaments = [
      {
        'title': 'Ultimate Warrior Cup',
        'description': 'Compete with the best in endurance and power.',
        'endDate': 'Ends in 4 days',
        'features': ['🔥 Daily Leaderboards', '🏆 Weekly Rewards', '💪 Muscle Power Rounds']
      },
      {
        'title': 'Speed & Agility Showdown',
        'description': 'Boost your reaction time and movement speed.',
        'endDate': 'Ends in 2 days',
        'features': ['⚡ Sprint Events', '📏 Agility Ladder Test', '⏱️ Time Trials']
      },
      {
        'title': 'Flex Master Tournament',
        'description': 'Show off your strength and flexibility.',
        'endDate': 'Ends in 6 days',
        'features': ['🏋️ Heavy Lifts', '🤸‍♂️ Balance Tasks', '🧘 Flexibility Scoring']
      },
    ];

    return DefaultTabController(
      length: isPremium ? 2 : 1,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1741),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B1741),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            tabs: isPremium
                ? const [Tab(text: 'Challenge'), Tab(text: 'Tournament')]
                : const [Tab(text: 'Tournament')],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.yellow,
          ),
        ),
        body: TabBarView(
          children: isPremium
              ? [
            _buildChallengeList(context, challenges),
            _buildTournamentList(tournaments),
          ]
              : [_buildTournamentList(tournaments)],
        ),
      ),
    );
  }

  Widget _buildChallengeList(BuildContext context, List<Map<String, String>> challenges) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return ViewCTWidget(
          title: challenge['title']!,
          target: challenge['target']!,
          duration: challenge['duration']!,
          onInvite: () => _showInviteFriendPopup(
            context,
            challenge['title']!,
            challenge['target']!,
            challenge['duration']!,
          ),
        );
      },
    );
  }

  Widget _buildTournamentList(List<Map<String, dynamic>> tournaments) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tournaments.length,
      itemBuilder: (context, index) {
        final tournament = tournaments[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tournament['title'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(tournament['description']),
              const SizedBox(height: 6),
              Text(tournament['endDate'], style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              ...List<Widget>.from(
                (tournament['features'] as List<dynamic>).map(
                      (feature) => Row(
                    children: [
                      const Icon(Icons.check, size: 16, color: Colors.green),
                      const SizedBox(width: 6),
                      Text(feature),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showInviteFriendPopup(
      BuildContext context,
      String title,
      String target,
      String duration,
      ) {
    final friends = [
      {'name': 'Anthony Halim', 'username': '@pitbull101'},
      {'name': 'Matilda Yeo', 'username': '@matyeo'},
      {'name': 'Jackson Wang', 'username': '@jackson'},
    ];

    final Set<int> selectedIndices = {};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(ctx).pop(),
          child: GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.9,
              builder: (_, controller) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Target: $target"),
                                Text("Duration: $duration"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              controller: controller,
                              itemCount: friends.length,
                              itemBuilder: (context, index) {
                                final friend = friends[index];
                                final isSelected = selectedIndices.contains(index);
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.person, color: Colors.white),
                                  ),
                                  title: Text(friend['name']!),
                                  subtitle: Text(friend['username']!),
                                  trailing: IconButton(
                                    icon: Icon(
                                      isSelected ? Icons.check_circle : Icons.add_circle_outline,
                                      color: isSelected ? Colors.blue : Colors.yellow[700],
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (isSelected) {
                                          selectedIndices.remove(index);
                                        } else {
                                          selectedIndices.add(index);
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[700],
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              minimumSize: const Size.fromHeight(48),
                            ),
                            child: const Text("Done", style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}