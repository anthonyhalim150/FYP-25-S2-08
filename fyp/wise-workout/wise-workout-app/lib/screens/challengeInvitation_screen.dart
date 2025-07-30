import 'package:flutter/material.dart';

class Challenge {
  final String title;
  final String senderName;
  final String target;
  final int duration; // in days
  final int daysLeft;

  Challenge({
    required this.title,
    required this.senderName,
    required this.target,
    required this.duration,
    this.daysLeft = 0,
  });
}

class ChallengeInvitationScreen extends StatefulWidget {
  final List<Challenge> pendingInvites;
  final List<Challenge> ongoingChallenges;

  const ChallengeInvitationScreen({
    super.key,
    required this.pendingInvites,
    required this.ongoingChallenges,
  });

  @override
  State<ChallengeInvitationScreen> createState() => _ChallengeInvitationScreenState();
}

class _ChallengeInvitationScreenState extends State<ChallengeInvitationScreen> {
  @override
  Widget build(BuildContext context) {
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
                tabs: [Tab(text: 'Invitations'), Tab(text: 'Ongoing')],
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                indicator: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
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
    final invites = widget.pendingInvites;
    if (invites.isEmpty) {
      return const Center(
        child: Text("No pending invitations.", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: invites.length,
      itemBuilder: (context, index) {
        final challenge = invites[index];
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
              Text('Duration: ${challenge.duration} days'),
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
    final ongoing = widget.ongoingChallenges;
    if (ongoing.isEmpty) {
      return const Center(
        child: Text("No ongoing challenges.", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ongoing.length,
      itemBuilder: (context, index) {
        final challenge = ongoing[index];
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

  void acceptChallenge(BuildContext context, Challenge challenge) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Accepted ${challenge.title}')),
    );
  }

  void rejectChallenge(BuildContext context, Challenge challenge) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rejected ${challenge.title}')),
    );
  }
}