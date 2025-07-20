import 'package:flutter/material.dart';

class BenefitsWidget extends StatelessWidget {
  const BenefitsWidget({Key? key}) : super(key: key);

  Widget _benefitTile(IconData icon, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Icon(icon, color: Colors.purple[300]),
        const SizedBox(width: 14),
        Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            )),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Column(
          children: [
            _benefitTile(Icons.block, "100% Ad-free experience"),
            _benefitTile(Icons.emoji_emotions, "Exclusive avatar selections"),
            _benefitTile(Icons.smart_toy, "Auto-suggested plan with AI"),
            _benefitTile(Icons.play_circle_filled, "Step-by-step HD video tutorials"),
            _benefitTile(Icons.flash_on, "Priority support and faster updates"),
          ],
        ),
      ),
    );
  }
}