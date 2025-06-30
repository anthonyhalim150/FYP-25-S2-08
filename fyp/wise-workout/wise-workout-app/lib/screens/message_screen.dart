import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import 'chat_screen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  int selectedTab = 0; // 0: All Friends, 1: Requests, 2: Pending

  // Hardcoded list
  final List<Map<String, String>> friends = [
    {
      'name': 'Anthony Halim',
      'handle': '@pitbull101',
      'avatar': 'assets/avatars/free/free1.png',
    },
    {
      'name': 'Matilda Yeo',
      'handle': '@pitbull101',
      'avatar': 'assets/avatars/free/free2.png',
    },
    {
      'name': 'Jackson Wang',
      'handle': '@pitbull101',
      'avatar': 'assets/avatars/free/free3.png',
    },
    {
      'name': 'Rose Herledya',
      'handle': '@pitbull101',
      'avatar': 'assets/avatars/premium/premium4.png',
    },
    {
      'name': 'Brendan Tanujaya',
      'handle': '@pitbull101',
      'avatar': 'assets/avatars/premium/premium5.png',
    },
    {
      'name': 'Clarybel Sutanto',
      'handle': '@pitbull101',
      'avatar': 'assets/avatars/premium/premium6.png',
    },
    {
      'name': 'Goh Wei Bin',
      'handle': '@pitbull101',
      'avatar': 'assets/avatars/premium/premium7.png',
    },
    {
      'name': 'Javier Cheng',
      'handle': '@pitbull101',
      'avatar': 'assets/avatars/premium/premium2.png',
    },
  ];

  String search = '';

  @override
  Widget build(BuildContext context) {
    // Filter friends by search query
    final filteredFriends = friends
        .where((f) =>
    f['name']!.toLowerCase().contains(search.toLowerCase()) ||
        f['handle']!.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF7F2EA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  const Text(
                    'Friends',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.menu, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (v) => setState(() => search = v),
                decoration: InputDecoration(
                  hintText: 'Search by username or email',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _tabButton('All Friends', 0, selectedTab == 0),
                    _tabButton('Requests', 1, selectedTab == 1),
                    _tabButton('Pending', 2, selectedTab == 2),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 6.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                        },
                        icon: const Icon(Icons.add, color: Colors.white, size: 18),
                        label: const Text("Add New"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF2176FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 12),
                          textStyle: const TextStyle(fontSize: 15),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 0, thickness: 1),
            // Friends List
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, i) {
                    final f = filteredFriends[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(f['avatar']!),
                        radius: 28,
                      ),
                      title: Text(
                        f['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                      subtitle: Text(
                        f['handle']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              friendName: f['name']!,
                              friendHandle: f['handle']!,
                              friendAvatar: f['avatar']!,
                              isPremium: true, // Hardcoded for now (this is to show challenge)
                            ),
                          ),
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(
                    thickness: 1,
                    indent: 24,
                    endIndent: 24,
                  ),
                  itemCount: filteredFriends.length,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(
        currentIndex: 3, // Messages tab index
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/leaderboard');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/workout-dashboard');
              break;
            case 3:
            // Already on messages
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _tabButton(String label, int idx, bool selected) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: idx == 0 ? 16 : 4),
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = idx),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFCB35) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: selected ? FontWeight.bold : FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}