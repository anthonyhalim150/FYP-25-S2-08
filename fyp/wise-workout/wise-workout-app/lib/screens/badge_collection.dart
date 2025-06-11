import 'package:flutter/material.dart';

class BadgeCollectionScreen extends StatelessWidget {
  const BadgeCollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Badge Collections')),
      body: const Center(child: Text("Your badges will appear here!")),
    );
  }
}