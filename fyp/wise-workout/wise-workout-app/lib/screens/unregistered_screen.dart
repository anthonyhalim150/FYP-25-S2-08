import 'dart:ui';
import 'package:flutter/material.dart';

class UnregisteredUserPage extends StatelessWidget {
  const UnregisteredUserPage({super.key});

  void _promptLogin(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('Please register or log in to access this content.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamed(context, '/');
              });
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurredCard({required BuildContext context, required Widget child}) {
    return GestureDetector(
      onTap: () => _promptLogin(context),
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTournamentCard({
    required BuildContext context,
    required String title,
    required String reward,
    required String participants,
    required String duration,
    required Color badgeColor,
    required Color cardColor,
  }) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 10),
      child: _buildBlurredCard(
        context: context,
        child: Container(
          height: 160,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(duration,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.emoji_events, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(reward, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Icon(Icons.group, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(participants),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _promptLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF52796F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Join Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F3EF),
        elevation: 0,
        title: const Text(
          'Hello, John!',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamed(context, '/');
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF0D1B52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search on FitQuest',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildBlurredCard(
              context: context,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.orange[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(Icons.fitness_center, size: 40, color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Workout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildBlurredCard(
                    context: context,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/push-up.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Push Up\nBeginner Level',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildBlurredCard(
                    context: context,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/squats.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Squat\nAdvance Level',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B52),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Let’s start a journey!",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Lorem Ipsum lorem ipsum placeholder. We will explain in marketing way.",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => _promptLogin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text('Join a Challenge or Tournament!'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Challenges & Tournament',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTournamentCard(
                    context: context,
                    title: 'Summer Challenge',
                    reward: '\$5,000',
                    participants: '2.4k',
                    duration: '5 Days',
                    badgeColor: Colors.yellow[200]!,
                    cardColor: Colors.grey[100]!,
                  ),
                  _buildTournamentCard(
                    context: context,
                    title: 'Plank Challenge',
                    reward: 'Premium',
                    participants: '1.2k',
                    duration: '7 Days',
                    badgeColor: Colors.green[100]!,
                    cardColor: Colors.grey[100]!,
                  ),
                  _buildTournamentCard(
                    context: context,
                    title: 'Yoga Mastery',
                    reward: 'Free Merch',
                    participants: '900',
                    duration: '10 Days',
                    badgeColor: Colors.purple[100]!,
                    cardColor: Colors.grey[100]!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () => _promptLogin(context),
          backgroundColor: Colors.amber,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.fitness_center,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomIcon(context, 'assets/icons/Home.png', 'Home'),
              _bottomIcon(context, 'assets/icons/Leaderboard.png', 'Leaderboa...'),
              const SizedBox(width: 40), // space for FAB
              _bottomIcon(context, 'assets/icons/Messages.png', 'Messages'),
              _bottomIcon(context, 'assets/icons/Profile.png', 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomIcon(BuildContext context, String assetPath, String label) {
    return GestureDetector(
      onTap: () => _promptLogin(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(assetPath, width: 24, height: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
