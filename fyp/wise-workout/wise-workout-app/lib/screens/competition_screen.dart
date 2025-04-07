import 'package:flutter/material.dart';
import '../widgets/competition_card.dart';

class CompetitionScreen extends StatelessWidget {
  final List<Map<String, String>> competitions = [
    {"opponent": "Alex", "status": "Challenged you"},
    {"opponent": "Jordan", "status": "You’re winning"},
    {"opponent": "Sam", "status": "Tie"},
  ];

  void handleChallenge() {
    print("Challenge accepted");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Competitions")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Your Current Challenges", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: competitions.length,
                itemBuilder: (context, index) {
                  final item = competitions[index];
                  return CompetitionCard(
                    opponentName: item["opponent"]!,
                    status: item["status"]!,
                    onPressed: handleChallenge,
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.person_add),
              label: Text("Start New Competition"),
              onPressed: () {
                // Navigate to challenge form
              },
            )
          ],
        ),
      ),
    );
  }
}
