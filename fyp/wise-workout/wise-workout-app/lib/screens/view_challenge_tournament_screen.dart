import 'package:flutter/material.dart';
import '../widgets/viewCTwidget.dart'; // Adjust path based on your structure

class ViewChallengeTournamentScreen extends StatelessWidget {
  const ViewChallengeTournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final challenges = [
      {
        'title': 'Push Up Challenge',
        'target': '150 Push Ups',
        'duration': '7 days',
      },
      {
        'title': 'Squat Challenge',
        'target': '1,200 Calories',
        'duration': '3 days',
      },
      {
        'title': 'Squat Jump Challenge',
        'target': '90 squat jumps',
        'duration': '3 days',
      },
      {
        'title': 'Squat Jump Challenge',
        'target': '80 squat jumps',
        'duration': '3 days',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B1741),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1741),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Challenge',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              // Optional: Add tournament tab logic
            },
            child: const Text(
              'Tournament',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return ViewCTWidget(
            title: challenge['title']!,
            target: challenge['target']!,
            duration: challenge['duration']!,
            onInvite: () => _showInviteFriendPopup(context, challenge['title']!),
          );
        },
      ),
    );
  }

  void _showInviteFriendPopup(BuildContext context, String challengeName) {
    final friends = [
      {'name': 'Anthony Halim', 'username': '@pitbull101'},
      {'name': 'Matilda Yeo', 'username': '@pitbull101'},
      {'name': 'Jackson Wang', 'username': '@pitbull101'},
      {'name': 'Rose Herledya', 'username': '@pitbull101'},
      {'name': 'Brendan Tanujaya', 'username': '@pitbull101'},
      {'name': 'Clarybel Sutanto', 'username': '@pitbull101'},
      {'name': 'Goh Wei Bin', 'username': '@pitbull101'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                challengeName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...friends.map((friend) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(friend['name']!),
                  subtitle: Text(friend['username']!),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      // Add logic to invite friend
                    },
                  ),
                );
              }).toList(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: const Size.fromHeight(45),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
