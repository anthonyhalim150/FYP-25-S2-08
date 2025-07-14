import 'package:flutter/material.dart';
import '../services/daily_quest_service.dart';
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

  List<Map<String, dynamic>> _quests = [];
  bool _loading = true;
  bool _claiming = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchQuests();
  }

  Future<void> _fetchQuests() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final quests = await DailyQuestService().fetchDailyQuests();
      setState(() {
        _quests = quests;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _claimXP(int i) async {
    if (_claiming) return;
    setState(() => _claiming = true);
    try {
      final questCode = _quests[i]['quest_code'] as String;
      await DailyQuestService().claimQuest(questCode);
      await _fetchQuests();
    } catch (e) {
      // Optionally show a snackbar with error
    } finally {
      setState(() => _claiming = false);
    }
  }

  Future<void> _claimAllXP() async {
    if (_claiming) return;
    setState(() => _claiming = true);
    try {
      await DailyQuestService().claimAllQuests();
      await _fetchQuests();
    } catch (e) {
      // Optionally show a snackbar with error
    } finally {
      setState(() => _claiming = false);
    }
  }

  Widget questCard(int i) {
    final quest = _quests[i];
    final String text = quest['text'] ?? '';
    final bool done = quest['done'] == 1 || quest['done'] == true;
    final bool claimed = quest['claimed'] == 1 || quest['claimed'] == true;

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
              text,
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
              onPressed: _claiming ? null : () => _claimXP(i),
              child: const Text("Claim XP"),
            )
          else if (done && claimed)
            const Icon(Icons.check_circle, color: Colors.green, size: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int unclaimedCount = _quests
        .where((q) =>
            (q['done'] == 1 || q['done'] == true) &&
            (q['claimed'] == 0 || q['claimed'] == false))
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EA),
      body: Stack(
        children: [
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Center(child: Text(_error!, style: TextStyle(color: Colors.red)))
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _quests.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
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
                    return const SizedBox(height: 32);
                  } else {
                    return questCard(index - 2);
                  }
                },
              ),
            ),
          if (!_loading && unclaimedCount > 1)
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
                  onPressed: _claiming ? null : _claimAllXP,
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