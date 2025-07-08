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
    final colorScheme = Theme.of(context).colorScheme;

    List<Map<String, dynamic>> badges = List.generate(12, (index) {
      return {
        'image': 'assets/badges/badge_${index + 1}.png',
        // Keep the pastel for illustration, but you could harmonize with your theme if desired
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
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: colorScheme.onBackground,
        ),
        title: Text(
          'Badge Collections',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.secondary.withOpacity(0.19),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Badges',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
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
                                    Icon(Icons.error_outline, size: 32, color: colorScheme.error),
                              ),
                            ),
                          ),
                          if (isLocked)
                            Container(
                              decoration: BoxDecoration(
                                color: colorScheme.background.withOpacity(0.44),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.lock,
                                  color: colorScheme.onBackground.withOpacity(0.82),
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
    final colorScheme = Theme.of(context).colorScheme;
    final isLocked = badge['locked'] as bool;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: colorScheme.surface,
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
                          Icon(Icons.error_outline, size: 100, color: colorScheme.error),
                    ),
                  ),
                ),
                if (isLocked)
                  Positioned(
                    child: Icon(Icons.lock, color: colorScheme.onSurface.withOpacity(0.88), size: 64),
                  ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              isLocked ? "Locked Badge" : "Badge Unlocked!",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (isLocked) ...[
              Text(
                "How to unlock:",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Text(
                badge['unlockInstruction'],
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: colorScheme.onSurface),
              ),
            ] else ...[
              Text(
                "You've unlocked this badge! Congratulations!",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: colorScheme.onSurface),
              ),
            ],
            const SizedBox(height: 22),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                textStyle: Theme.of(context).textTheme.titleMedium,
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