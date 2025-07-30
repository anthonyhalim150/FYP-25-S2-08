import 'package:flutter/material.dart';
import '../widgets/viewCTwidget.dart';
import '../services/tournament_service.dart';

class ViewChallengeTournamentScreen extends StatefulWidget {
  final bool isPremium;
  const ViewChallengeTournamentScreen({super.key, required this.isPremium});

  @override
  State<ViewChallengeTournamentScreen> createState() => _ViewChallengeTournamentScreenState();
}

class _ViewChallengeTournamentScreenState extends State<ViewChallengeTournamentScreen> {
  late Future<List<dynamic>> tournamentsFuture;
  final TournamentService _tournamentService = TournamentService();

  @override
  void initState() {
    super.initState();
    tournamentsFuture = _tournamentService.getAllTournaments();
  }

  @override
  Widget build(BuildContext context) {
    final challenges = [
      {'title': 'Push Up Challenge', 'target': '150 Push Ups', 'duration': '7 days'},
      {'title': 'Squat Challenge', 'target': '1,200 Calories', 'duration': '3 days'},
      {'title': 'Jumping Jack Blitz', 'target': '900 jumping jacks', 'duration': '5 days'},
    ];

    return DefaultTabController(
      length: widget.isPremium ? 2 : 1,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1741),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B1741),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
<<<<<<< Updated upstream
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2B5C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                tabs: isPremium
                    ? const [
                  Tab(text: 'Challenge'),
                  Tab(text: 'Tournament'),
                ]
                    : const [
                  Tab(text: 'Tournament'),
                ],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                indicator: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                indicatorSize: TabBarIndicatorSize.tab, // 👈 ensure full tab background
              ),
            ),
=======
          bottom: TabBar(
            tabs: widget.isPremium
                ? const [Tab(text: 'Challenge'), Tab(text: 'Tournament')]
                : const [Tab(text: 'Tournament')],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white70,
            indicator: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(20)),
>>>>>>> Stashed changes
          ),
        ),
        body: TabBarView(
          children: widget.isPremium
              ? [
            _buildChallengeList(context, challenges),
            _buildTournamentFuture(context),
          ]
              : [_buildTournamentFuture(context)],
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

  Widget _buildTournamentFuture(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: tournamentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load tournaments\n${snapshot.error}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }
        final tournaments = snapshot.data ?? [];
        if (tournaments.isEmpty) {
          return const Center(
            child: Text('No tournaments found.', style: TextStyle(color: Colors.white)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tournaments.length,
          itemBuilder: (context, index) {
            final t = tournaments[index];
            return TournamentCard(
              tournament: {
                'title': t['title'],
                'description': t['description'],
                'endDate': t['endDate'],
                // Parsing features to make sure it's List<String>
                'features': (t['features'] as List).map((e) => e.toString()).toList(),
              },
              onJoin: () => showTournamentJoinPopup(context, t),
            );
          },
        );
      },
    );
  }
}