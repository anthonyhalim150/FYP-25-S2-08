import 'package:flutter/material.dart';

class ProfileInfoRow extends StatelessWidget {
  final String xp;
  final String level;

  const ProfileInfoRow({Key? key, required this.xp, required this.level}) : super(key: key);

  Widget _infoCard(String label, String value) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _infoCard("XP", xp),
          const SizedBox(width: 15),
          _infoCard("Level", level),
        ],
      ),
    );
  }
}