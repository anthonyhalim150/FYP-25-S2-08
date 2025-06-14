import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class SquatPoseScreen extends StatefulWidget {
  const SquatPoseScreen({super.key});

  @override
  State<SquatPoseScreen> createState() => _SquatPoseScreenState();
}

class _SquatPoseScreenState extends State<SquatPoseScreen> {
  final channel = IOWebSocketChannel.connect('ws://10.0.2.2:8080/ws/squats');
  List landmarks = [];

  @override
  void initState() {
    super.initState();
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      if (data['pose'] == 'squats') {
        setState(() {
          landmarks = data['landmarks'];
        });
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Squat Tracker")),
      body: ListView.builder(
        itemCount: landmarks.length,
        itemBuilder: (context, index) {
          final lm = landmarks[index];
          return ListTile(
            title: Text('ID: ${lm[0]}'),
            subtitle: Text('x: ${lm[1]}, y: ${lm[2]}'),
          );
        },
      ),
    );
  }
}
