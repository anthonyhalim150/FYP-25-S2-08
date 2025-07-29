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
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white70,
            indicator: BoxDecoration(
              color: Colors.yellow, // 👈 selected tab background color
              borderRadius: BorderRadius.circular(20)
            ),
          ),
        ),
        body: TabBarView(
          children: isPremium
              ? [
            _buildChallengeList(context, challenges),
            _buildTournamentList(context, tournaments),
          ]
              : [_buildTournamentList(context, tournaments)],
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
          onInvite: () => showInviteFriendPopup(
            context,
            challenge['title']!,
            challenge['target']!,
            challenge['duration']!,
          ),
        );
      },
    );
  }

  Widget _buildTournamentList(BuildContext context, List<Map<String, dynamic>> tournaments) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tournaments.length,
      itemBuilder: (context, index) {
        final tournament = tournaments[index];
        return TournamentCard(
          tournament: tournament,
          onJoin: () => showTournamentJoinPopup(context, tournament),
        );
      },
    );
  }
}