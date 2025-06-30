import 'package:flutter/material.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key}) : super(key: key);

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  String search = '';
  // Hardcoded, need to implement backend!
  final List<Map<String, String>> allUsers = [
    {
      'name': 'Jake Sim',
      'handle': '@jakesim1415',
      'avatar': 'assets/avatars/free/free2.png',
    },
    {
      'name': 'Lucia Foo',
      'handle': '@lucyfoo88',
      'avatar': 'assets/avatars/free/free3.png',
    }
    // Add more users as needed
  ];

  @override
  Widget build(BuildContext context) {
    final results = allUsers
        .where((u) =>
    u['name']!.toLowerCase().contains(search.toLowerCase()) ||
        u['handle']!.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Add Friend',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              autofocus: true,
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
          const Divider(height: 0, thickness: 1),
          Expanded(
            child: results.isEmpty || search.isEmpty
                ? Center(
              child: Text("No users found.",
                  style:
                  TextStyle(color: Colors.grey[600], fontSize: 16)),
            )
                : ListView.separated(
              itemCount: results.length,
              separatorBuilder: (_, __) => const Divider(
                thickness: 1,
                indent: 24,
                endIndent: 24,
              ),
              itemBuilder: (context, i) {
                final u = results[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(u['avatar']!),
                    radius: 28,
                  ),
                  title: Text(
                    u['name']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  subtitle: Text(
                    u['handle']!,
                    style:
                    TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Friend request sent to ${u['name']}")));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(60, 36),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}