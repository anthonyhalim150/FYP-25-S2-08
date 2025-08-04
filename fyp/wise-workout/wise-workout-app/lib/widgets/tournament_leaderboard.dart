import 'package:flutter/material.dart';
import '../services/tournament_service.dart';

class TournamentLeaderboardWidget extends StatefulWidget {
  const TournamentLeaderboardWidget({super.key});

  @override
  State<TournamentLeaderboardWidget> createState() =>
      _TournamentLeaderboardWidgetState();
}

class _TournamentLeaderboardWidgetState
    extends State<TournamentLeaderboardWidget> {
  final TournamentService _service = TournamentService();

  List<Map<String, dynamic>> tournaments = [];
  int currentIndex = 0;
  List<dynamic> leaderboard = [];
  bool loadingLeaderboard = true;
  bool loadingTournaments = true;
  String leaderboardError = '';
  String tournamentError = '';

  @override
  void initState() {
    super.initState();
    _fetchTournaments();
  }

  Future<void> _fetchTournaments() async {
    setState(() {
      loadingTournaments = true;
      tournamentError = '';
    });
    try {
      final data = await _service.getAllTournaments();
      setState(() {
        tournaments = List<Map<String, dynamic>>.from(data);
        loadingTournaments = false;
      });
      if (tournaments.isNotEmpty) {
        await _fetchLeaderboardForCurrent();
      }
    } catch (e) {
      setState(() {
        loadingTournaments = false;
        tournamentError = 'Failed to load tournaments';
      });
    }
  }

  Future<void> _fetchLeaderboardForCurrent() async {
    setState(() {
      loadingLeaderboard = true;
      leaderboardError = '';
    });
    if (tournaments.isEmpty) {
      setState(() {
        loadingLeaderboard = false;
        leaderboard = [];
      });
      return;
    }
    final tournamentId = tournaments[currentIndex]['id'];
    try {
      final entries = await _service.getLeaderboard(tournamentId);
      setState(() {
        leaderboard = entries;
        loadingLeaderboard = false;
      });
    } catch (e) {
      setState(() {
        loadingLeaderboard = false;
        leaderboard = [];
        leaderboardError = 'Failed to load leaderboard';
      });
    }
  }

  void _changeChallenge(int direction) async {
    if (tournaments.isEmpty) return;
    setState(() {
      currentIndex = (currentIndex + direction) % tournaments.length;
      if (currentIndex < 0) currentIndex += tournaments.length;
    });
    await _fetchLeaderboardForCurrent();
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

    if (loadingTournaments) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tournamentError.isNotEmpty) {
      return Center(child: Text(tournamentError));
    }
    if (tournaments.isEmpty) {
      return Center(child: Text("No tournaments available."));
    }

    final tournament = tournaments[currentIndex];
    final title = tournament['title'] ?? 'Tournament';

    // Prepare podium/others for rendering
    List<dynamic> podium = leaderboard.length >= 3
        ? leaderboard.sublist(0, 3)
        : leaderboard;
    List<dynamic> others =
    leaderboard.length > 3 ? leaderboard.sublist(3) : [];

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
        if (loadingLeaderboard)
          const Padding(
              padding: EdgeInsets.all(16), child: CircularProgressIndicator())
        else if (leaderboardError.isNotEmpty)
          Padding(
              padding: const EdgeInsets.all(16),
              child: Text(leaderboardError,
                  style: TextStyle(color: Colors.red)))
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(3, (i) {
              if (podium.length > i) {
                return _buildPodium(podium[i], i + 1, theme);
              }
              // In case less than 3 participant: empty slot
              return Container(width: 40, height: 80);
            }),
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
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              children: others.asMap().entries.map<Widget>((e) {
                final idx = e.key;
                final entry = e.value;
                return ListTile(
                  leading: Text(
                    '${idx + 4}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  title: Text(
                    entry['username'] ?? '',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: textColor),
                  ),
                  trailing: Text(
                    '${entry['progress']}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: textColor),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPodium(Map entry, int rank, ThemeData theme) {
    Color podiumColor;
    double height;
    switch (rank) {
      case 1:
        podiumColor = Colors.amber;
        height = 110;
        break;
      case 2:
        podiumColor = Colors.lightBlue;
        height = 80;
        break;
      case 3:
        podiumColor = Colors.orange;
        height = 60;
        break;
      default:
        podiumColor = theme.colorScheme.primary;
        height = 60;
    }
    String username = entry['username'] ?? 'Unknown';

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          radius: 24,
          child: Text(username.isNotEmpty ? username[0] : '?', style: const TextStyle(fontSize: 20)),
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(height: 6),
        Container(
          width: 40,
          height: height,
          decoration: BoxDecoration(
            color: podiumColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '$rank',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          username,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        Text('${entry['progress']}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}