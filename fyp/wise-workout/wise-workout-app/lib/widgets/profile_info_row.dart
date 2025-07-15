import 'package:flutter/material.dart';

class ProfileInfoRow extends StatelessWidget {
  final String xp;
  final String level;
  final int progressInLevel;
  final int xpForThisLevel;

  const ProfileInfoRow({
    Key? key,
    required this.xp,
    required this.level,
    required this.progressInLevel,
    required this.xpForThisLevel,
  }) : super(key: key);

  Widget _infoCard(String label, String value, {String? subLabel}) {
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
            if (subLabel != null) ...[
              const SizedBox(height: 4),
              Text(
                subLabel,
                style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500, fontSize: 12),
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String progressText = "$progressInLevel / $xpForThisLevel XP";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _infoCard("XP", progressText),
          const SizedBox(width: 15),
          _infoCard("Level", level),
        ],
      ),
    );
  }
}
