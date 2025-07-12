import 'package:flutter/material.dart';

//sub-widget
import '../widgets/bottom_navigation.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({Key? key}) : super(key: key);

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  static const darkBlue = Color(0xFF111A43);
  static const yellow = Color(0xFFFFD94D);
  static const checkColor = Color(0xFF111A43);

  final List<Map<String, dynamic>> _quests = [
    {'text': 'Logged In', 'done': true, 'claimed': false,},
    {'text': 'Do a Strength Workout', 'done': false, 'claimed': false,},
    {'text': 'Message a friend', 'done': true, 'claimed': false,},
    {'text': 'Do a Push Workout', 'done': false, 'claimed': false,},
    {'text': 'Do a Leg Workout', 'done': true, 'claimed': false,},
    {'text': 'Share your Workout to Social Media', 'done': false, 'claimed': false,},
    {'text': 'Complete a cardio workout', 'done': true, 'claimed': false,},
    {'text': 'Spin your Luck Spin', 'done': false, 'claimed': false,},
    {'text': 'Update your profile', 'done': false, 'claimed': false,},
    {'text': 'Login for 5 times', 'done': false, 'claimed': false,},
    {'text': 'Sync your watch', 'done': true, 'claimed': false,},
    {'text': 'Finish a quest', 'done': false, 'claimed': false,},
    {'text': 'Workout for 10 minutes', 'done': true, 'claimed': false,},
  ];

  void _claimXP(int i) {
    setState(() {
      _quests[i]['claimed'] = true;
    });
  }

  void _claimAllXP() {
    setState(() {
      for (var quest in _quests) {
        if (quest['done'] && !quest['claimed']) {
          quest['claimed'] = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int unclaimedCount =
        _quests.where((q) => q['done'] && !q['claimed']).length;

    Widget questCard(int i) {
      final quest = _quests[i];
      final bool done = quest['done'];
      final bool claimed = quest['claimed'];

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
        decoration: BoxDecoration(
          color: done ? yellow : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                quest['text'],
                style: TextStyle(
                  color: done ? checkColor : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (done && !claimed)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  foregroundColor: yellow,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _claimXP(i),
                child: const Text("Claim XP"),
              )
            else if (done && claimed)
              const Icon(Icons.check_circle, color: Colors.green, size: 24),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EA),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 90),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _quests.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Header
                  return Container(
                    padding: const EdgeInsets.only(top: 40, bottom: 30, left: 18, right: 18),
                    decoration: const BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(34),
                        bottomRight: Radius.circular(34),
                      ),
                    ),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(30),
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.arrow_back, color: Colors.white, size: 26),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Center(
                          child: Text(
                            'Daily Quest',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Center(
                          child: Text(
                            'Finish a daily quest and claim the rewards!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (index == 1) {
                  // Space after header
                  return const SizedBox(height: 32);
                } else {
                  // Quest cards
                  return questCard(index - 2);
                }
              },
            ),
          ),
          if (unclaimedCount > 1)
            Positioned(
              left: 16,
              right: 16,
              bottom: 66,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor: yellow,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _claimAllXP,
                  icon: const Icon(Icons.star, color: Colors.amber),
                  label: const Text(
                    "Claim All XP",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/leaderboard');
              break;
            case 2:
              Navigator.pushNamed(context, '/workout-category-dashboard');
              break;
            case 3:
              Navigator.pushNamed(context, '/messages');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}