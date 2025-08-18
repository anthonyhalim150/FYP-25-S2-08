import 'package:flutter/material.dart';

class TournamentWidget extends StatelessWidget {
  final String tournamentName;
  final String daysLeft;
  final String participants;
  final double cardWidth;
  final VoidCallback? onJoin;
  final bool isJoined;

  const TournamentWidget({
    super.key,
    required this.tournamentName,
    required this.daysLeft,
    this.participants = '',
    this.cardWidth = 300,
    this.onJoin,
    this.isJoined = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = isJoined;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    tournamentName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF176),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    daysLeft,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildParticipantsRow(),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: disabled
                      ? Colors.grey
                      : Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: disabled ? null : onJoin,
                child: Text(
                  disabled ? 'Joined' : 'Join Now',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Restored helper
  Widget _buildParticipantsRow() {
    return Row(
      children: [
        Icon(Icons.people, size: 18, color: Colors.blue.shade400),
        const SizedBox(width: 6),
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 11,
              backgroundColor: Colors.blue.shade100,
              child: const Text("A", style: TextStyle(fontSize: 12)),
            ),
            Positioned(
              left: 14,
              child: CircleAvatar(
                radius: 11,
                backgroundColor: Colors.green.shade100,
                child: const Text("B", style: TextStyle(fontSize: 12)),
              ),
            ),
            Positioned(
              left: 28,
              child: CircleAvatar(
                radius: 11,
                backgroundColor: Colors.orange.shade100,
                child: const Text("C", style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
        const SizedBox(width: 38),
        Text(
          '$participants participants',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
