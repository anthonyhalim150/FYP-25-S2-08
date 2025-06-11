import 'package:flutter/material.dart';

class BadgeCollectionScreen extends StatelessWidget {
  const BadgeCollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> badges = List.generate(12, (index) {
      return {
        'image': 'assets/badges/badge_${index + 1}.png',
        'color': [
          '#DCF0F7', '#F0FDD7', '#FFF3AD', '#EAD8FF', '#FFDEDE',
          '#D6EDFF', '#D0F0FF', '#FFD6BD', '#C5F9D7', '#E5E5E5',
          '#FFE6E6', '#D9F0F4',
        ][index % 12],
        'locked': index >= 6,
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
          color: Color(0xFFFFD233), // Yellow background
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
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
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

                    return Stack(
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
                          const Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(Icons.lock, color: Colors.black54, size: 32),
                            ),
                          ),
                      ],
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

// 💡 Utility to convert hex color string to Color
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