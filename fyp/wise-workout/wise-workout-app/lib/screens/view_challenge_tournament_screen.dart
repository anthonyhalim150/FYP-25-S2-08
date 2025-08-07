import 'package:flutter/material.dart';
import '../widgets/view_challenge_widget.dart';
import '../widgets/view_tournament_widget.dart';
import '../services/tournament_service.dart';
import '../services/challenge_service.dart';

class ViewChallengeTournamentScreen extends StatefulWidget {
  final bool isPremium;
  const ViewChallengeTournamentScreen({super.key, required this.isPremium});

  @override
  State<ViewChallengeTournamentScreen> createState() => _ViewChallengeTournamentScreenState();
}

class _ViewChallengeTournamentScreenState extends State<ViewChallengeTournamentScreen> {
  late Future<List<dynamic>> tournamentsFuture;
  late Future<List<Map<String, dynamic>>> challengesFuture;
  final TournamentService _tournamentService = TournamentService();
  final ChallengeService _challengeService = ChallengeService();
  List<Map<String, dynamic>>? editableChallenges;

  @override
  void initState() {
    super.initState();
    challengesFuture = _challengeService.getAllChallenges();
    tournamentsFuture = _tournamentService.getAllTournaments();
  }

  void reloadTournaments() {
    setState(() {
      tournamentsFuture = _tournamentService.getAllTournaments();
    });
  }

  void editChallenge(int index, Map<String, dynamic> originalChallenge) async {
    final updated = await showEditChallengePopup(
      context,
      originalChallenge['value'],
      '${originalChallenge['duration']} days',
    );
    if (updated != null) {
      setState(() {
        if (editableChallenges != null && index < editableChallenges!.length) {
          editableChallenges![index]['value'] = updated['target'];
          editableChallenges![index]['duration'] = int.tryParse(
              RegExp(r'\d+').firstMatch(updated['duration'] ?? '')?.group(0) ?? '') ?? editableChallenges![index]['duration'];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2B5C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                tabs: widget.isPremium
                    ? const [Tab(text: 'Challenge'), Tab(text: 'Tournament')]
                    : const [Tab(text: 'Tournament')],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                indicator: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: widget.isPremium
              ? [
                  buildChallengeTab(context),
                  buildTournamentTab(context),
                ]
              : [buildTournamentTab(context)],
        ),
      ),
    );
  }

  Widget buildChallengeTab(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: challengesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load challenges\n${snapshot.error}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        }
        List<Map<String, dynamic>> challenges = snapshot.data ?? [];
        if (editableChallenges == null) {
          // Make a deep copy for editing
          editableChallenges = challenges.map((e) => Map<String, dynamic>.from(e)).toList();
        }
        if (editableChallenges!.isEmpty) {
          return const Center(
            child: Text('No challenges found.', style: TextStyle(color: Colors.white)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: editableChallenges!.length,
          itemBuilder: (context, index) {
            final challenge = editableChallenges![index];
            return ChallengeCard(
              title: challenge['type'],
              target: challenge['value'],
              duration: '${challenge['duration']} days',
              onInvite: () => showInviteFriendPopup(
                context,
                challenge['type'],
                challenge['value'],
                '${challenge['duration']} days',
              ),
              onEdit: () => editChallenge(index, challenge),
            );
          },
        );
      },
    );
  }

  Widget buildTournamentTab(BuildContext context) {
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
                'id': t['id'],
                'title': t['title'],
                'description': t['description'],
                'endDate': t['endDate'],
                'features': (t['features'] as List).map((e) => e.toString()).toList(),
              },
              onJoin: () => showTournamentJoinPopup(
                context,
                {
                  'id': t['id'],
                  'title': t['title'],
                  'description': t['description'],
                  'endDate': t['endDate'],
                  'features': (t['features'] as List).map((e) => e.toString()).toList(),
                },
                onJoin: () async {
                  String status = "";
                  try {
                    status = await _tournamentService.joinTournament(t['id']);
                  } catch (e) {
                    status = "";
                  }
                  if (!mounted) return;
                  if (status == "joined") {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Joined tournament!")));
                    reloadTournaments();
                  } else if (status == "already_joined") {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("You have already joined this tournament!")));
                  } else {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Could not join tournament.")));
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}