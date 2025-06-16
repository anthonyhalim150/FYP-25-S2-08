import 'package:flutter/material.dart';

// Instructions to earn a badge
const List<String> badgeUnlockInstructions = [
  "Complete 100 workouts to earn this badge.",
  "Maintain a workout streak for 30 consecutive days.",
  "Burn more calories in a single session than ever before.",
  "Achieve your personal best in any tracked category.",
  "Record your longest workout session.",
  "Maintain consistently high performance in your workouts.",
  "Level up by gaining enough experience points.",
  "Reach a new workout streak milestone.",
  "Win a workout challenge.",
  "Complete a workout with a friend.",
  "Complete 50 workouts.",
  "Complete a mindful or recovery activity.",
];

class BadgeCollectionScreen extends StatelessWidget {
  const BadgeCollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> badges = List.generate(12, (index) {
      return {
        'image': 'assets/badges/badge_${index + 1}.png',
        'color': [
          '#DCF0F7',
          '#F0FDD7',
          '#FFF3AD',
          '#EAD8FF',
          '#FFDEDE',
          '#D6EDFF',
          '#D0F0FF',
          '#FFD6BD',
          '#C5F9D7',
          '#E5E5E5',
          '#FFE6E6',
          '#D9F0F4',
        ][index % 12],
        'locked': index >= 6,
        'unlockInstruction': badgeUnlockInstructions[index],
      };
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          'Badge Collections',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFFFFD233),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Badges',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: GridView.builder(
                  itemCount: badges.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final badge = badges[index];
                    final isLocked = badge['locked'] as bool;

                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => _BadgeDetailDialog(badge: badge),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: HexColor.fromHex(badge['color']),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: ColorFiltered(
                              colorFilter: isLocked
                                  ? ColorFilter.mode(
                                Colors.grey.withOpacity(0.6),
                                BlendMode.saturation,
                              )
                                  : const ColorFilter.mode(
                                  Colors.transparent, BlendMode.multiply),
                              child: Image.asset(
                                badge['image'],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error_outline, size: 32),
                              ),
                            ),
                          ),
                          if (isLocked)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.lock,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BIGGER BADGE DIALOG
class _BadgeDetailDialog extends StatelessWidget {
  final Map<String, dynamic> badge;
  const _BadgeDetailDialog({required this.badge});

  @override
  Widget build(BuildContext context) {
    final isLocked = badge['locked'] as bool;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: HexColor.fromHex(badge['color']),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: ColorFiltered(
                    colorFilter: isLocked
                        ? ColorFilter.mode(
                      Colors.grey.withOpacity(0.7),
                      BlendMode.saturation,
                    )
                        : const ColorFilter.mode(
                        Colors.transparent, BlendMode.multiply),
                    child: Image.asset(
                      badge['image'],
                      height: 220,
                      width: 220,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error_outline, size: 100),
                    ),
                  ),
                ),
                if (isLocked)
                  const Positioned(
                    child: Icon(Icons.lock, color: Colors.white, size: 64),
                  ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              isLocked ? "Locked Badge" : "Badge Unlocked!",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 16),
            if (isLocked) ...[
              Text(
                "How to unlock:",
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                badge['unlockInstruction'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17, color: Colors.black87),
              ),
            ] else ...[
              const Text(
                "You've unlocked this badge! Congratulations!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: Colors.black87),
              ),
            ],
            const SizedBox(height: 22),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
              child: const Text("Close"),
            )
          ],
        ),
      ),
    );
  }
}

/// Utility to convert hex color string to Color class
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    final colorStr = hexColor.toUpperCase().replaceAll("#", "");
    if (colorStr.length == 6) {
      return int.parse("FF$colorStr", radix: 16);
    } else {
      return int.parse(colorStr, radix: 16);
    }
  }

  HexColor.fromHex(String hexColor) : super(_getColorFromHex(hexColor));
}