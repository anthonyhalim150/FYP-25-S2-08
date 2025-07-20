import 'package:flutter/material.dart';

class MoneyBackWidget extends StatelessWidget {
  const MoneyBackWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.verified, color: Colors.green[700], size: 33),
            const SizedBox(width: 14),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "7-Day Money Back Guarantee\n",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text:
                      "Try any premium plan risk-free. Cancel anytime in the first 7 days for a full refund.",
                      style: TextStyle(color: Colors.black87, fontSize: 13.8),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}