import 'package:flutter/material.dart';

class IncludedWidget extends StatelessWidget {
  const IncludedWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("• Fitness plans for all levels", style: TextStyle(fontSize: 15)),
            SizedBox(height: 4),
            Text("• Advanced progress tracking", style: TextStyle(fontSize: 15)),
            SizedBox(height: 4),
            Text("• Access to new AI-powered features", style: TextStyle(fontSize: 15)),
            SizedBox(height: 4),
            Text("• Access future new content immediately", style: TextStyle(fontSize: 15)),
            SizedBox(height: 4),
            Text("• Support the app’s ongoing development ❤️", style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}