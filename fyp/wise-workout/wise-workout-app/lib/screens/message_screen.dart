import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'add_friend_screen.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/all_friends.dart';
import '../widgets/requests_friends.dart';
import '../widgets/pending_friends.dart';
import '../services/friend_service.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  int selectedTab = 0;
  String search = '';
  List<dynamic> friends = [];
  List<dynamic> requests = [];
  List<dynamic> pending = [];
  bool loading = true;
  final FriendService _friendService = FriendService();

  @override
  void initState() {
    super.initState();
    _loadFriendsData();
  }

  Future<void> _loadFriendsData() async {
    setState(() { loading = true; });
    try {
      final friendsList = await _friendService.getFriends();
      final pendingList = await _friendService.getPendingRequests();
      final sentList = await _friendService.getSentRequests();
      setState(() {
        friends = friendsList;
        requests = pendingList;
        pending = sentList;
        loading = false;
      });
    } catch (e) {
      setState(() {
        friends = [];
        requests = [];
        pending = [];
        loading = false;
      });
    }
  }
  void acceptRequest(int friendId) async {
    try {
      await _friendService.acceptRequest(friendId.toString());
      setState(() {
        requests.removeWhere((f) => f['id'] == friendId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request accepted')),
      );
      _loadFriendsData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to accept request')),
      );
    }
  }

  void ignoreRequest(int friendId) async {
    try {
      await _friendService.rejectRequest(friendId.toString());
      setState(() {
        requests.removeWhere((f) => f['id'] == friendId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request ignored')),
      );
      _loadFriendsData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to ignore request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredFriends = friends
        .where((f) =>
            (f['name'] ?? f['username'] ?? '').toLowerCase().contains(search.toLowerCase()) ||
            (f['handle'] ?? f['email'] ?? '').toLowerCase().contains(search.toLowerCase()))
        .toList()
        .cast<Map<String, dynamic>>();
    final filteredRequests = requests
        .where((f) =>
            (f['name'] ?? f['username'] ?? '').toLowerCase().contains(search.toLowerCase()) ||
            (f['handle'] ?? f['email'] ?? '').toLowerCase().contains(search.toLowerCase()))
        .toList()
        .cast<Map<String, dynamic>>();
    final filteredPending = pending
        .where((f) =>
            (f['name'] ?? f['username'] ?? '').toLowerCase().contains(search.toLowerCase()) ||
            (f['handle'] ?? f['email'] ?? '').toLowerCase().contains(search.toLowerCase()))
        .toList()
        .cast<Map<String, dynamic>>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF7F2EA),
      body: SafeArea(
        child: Column(
          children: [
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AddFriendScreen()),
                          ).then((_) => _loadFriendsData());
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
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      color: Colors.white,
                      child: Builder(builder: (context) {
                        if (selectedTab == 0) {
                          return AllFriendsTab(
                            friends: filteredFriends,
                            onFriendTap: (friend) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatScreen(
                                    friendName: friend['name'] ?? friend['username'] ?? '',
                                    friendHandle: friend['handle'] ?? friend['email'] ?? '',
                                    friendAvatar: friend['avatar'] ?? 'assets/avatars/free/free1.png',
                                    isPremium: false,
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (selectedTab == 1) {
                          return RequestsTab(
                            requests: filteredRequests,
                            acceptRequest: acceptRequest,
                            ignoreRequest: ignoreRequest,
                          );
                        } else {
                          return PendingTab(
                            pending: filteredPending,
                          );
                        }
                      }),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(
        currentIndex: 3,
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