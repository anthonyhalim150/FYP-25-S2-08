import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to Wise Workout", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/workout');
              },
              child: Text("Start Workout"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/competition');
              },
              child: Text("View Competitions"),
            ),
          ],
        ),
      ),
    );
  }
}
