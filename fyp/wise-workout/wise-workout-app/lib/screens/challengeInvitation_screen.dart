import 'package:flutter/material.dart';
import '../services/challenge_service.dart';

class Challenge {
  final int id;
  final String title;
  final String senderName;
  final String target;
  final int duration;
  final String durationUnit;
  final int daysLeft;

  Challenge({
    required this.id,
    required this.title,
    required this.senderName,
    required this.target,
    required this.duration,
    this.durationUnit = 'days',
    this.daysLeft = 0,
  });
}

class ChallengeInvitationScreen extends StatefulWidget {
  const ChallengeInvitationScreen({super.key});

  @override
  State<ChallengeInvitationScreen> createState() => _ChallengeInvitationScreenState();
}

class _ChallengeInvitationScreenState extends State<ChallengeInvitationScreen> {
  final ChallengeService _challengeService = ChallengeService();

  List<Challenge> pendingInvites = [];
  List<Challenge> ongoingChallenges = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChallenges();
  }

  Future<void> fetchChallenges() async {
    setState(() {
      isLoading = true;
    });
    try {
      final invitationsData = await _challengeService.getInvitations();
      final acceptedData = await _challengeService.getAcceptedChallenges();

      List<Challenge> fetchedInvites = invitationsData.map<Challenge>((data) {
        return Challenge(
          id: data['id'],
          title: data['type'] ?? 'Challenge',
          senderName: data['senderName'] ?? 'Unknown',
          target: data['custom_value'] ?? data['value'] ?? '',
          duration: int.tryParse(data['custom_duration_value']?.toString() ?? '') ??
                   int.tryParse(data['duration']?.toString() ?? '') ?? 0,
          durationUnit: data['custom_duration_unit'] ?? 'days',
          daysLeft: 0,
        );
      }).toList();

      List<Challenge> fetchedOngoing = acceptedData.map<Challenge>((data) {
        return Challenge(
          id: data['id'],
          title: data['type'] ?? 'Challenge',
          senderName: data['senderName'] ?? 'Unknown',
          target: data['custom_value'] ?? data['value'] ?? '',
          duration: int.tryParse(data['custom_duration_value']?.toString() ?? '') ??
                   int.tryParse(data['duration']?.toString() ?? '') ?? 0,
          durationUnit: data['custom_duration_unit'] ?? 'days',
          daysLeft: int.tryParse(data['daysLeft']?.toString() ?? '0') ?? 0,
        );
      }).toList();

      setState(() {
        pendingInvites = fetchedInvites;
        ongoingChallenges = fetchedOngoing;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Failed to fetch challenges: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load challenges: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0B1741),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF0B1741),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B1741),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Challenge Center", style: TextStyle(color: Colors.white)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48.0),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2B5C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                tabs: const [Tab(text: 'Invitations'), Tab(text: 'Ongoing')],
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
          children: [
            buildInvitationsTab(context),
            buildOngoingTab(context),
          ],
        ),
      ),
    );
  }

  Widget buildInvitationsTab(BuildContext context) {
    if (pendingInvites.isEmpty) {
      return const Center(
        child: Text("No pending invitations.", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pendingInvites.length,
      itemBuilder: (context, index) {
        final challenge = pendingInvites[index];
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
              Text('${challenge.senderName} invited you',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Target: ${challenge.target}'),
              Text('Duration: ${challenge.duration} ${challenge.durationUnit}'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => acceptChallenge(context, challenge),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('+ Accept', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => rejectChallenge(context, challenge),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Reject', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildOngoingTab(BuildContext context) {
    if (ongoingChallenges.isEmpty) {
      return const Center(
        child: Text("No ongoing challenges.", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ongoingChallenges.length,
      itemBuilder: (context, index) {
        final challenge = ongoingChallenges[index];
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
              Text(challenge.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Target: ${challenge.target}'),
              Text('${challenge.daysLeft} days left'),
            ],
          ),
        );
      },
    );
  }

  void acceptChallenge(BuildContext context, Challenge challenge) async {
    try {
      await _challengeService.acceptChallenge(challenge.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Accepted ${challenge.title}')),
      );
      await fetchChallenges();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept challenge: $e')),
      );
    }
  }

  void rejectChallenge(BuildContext context, Challenge challenge) async {
    try {
      await _challengeService.rejectChallenge(challenge.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rejected ${challenge.title}')),
      );
      await fetchChallenges();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject challenge: $e')),
      );
    }
  }
}