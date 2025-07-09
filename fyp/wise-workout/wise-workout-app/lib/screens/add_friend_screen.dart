import 'package:flutter/material.dart';
import '../services/friend_service.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key}) : super(key: key);

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  String search = '';
  List<dynamic> searchResults = [];
  bool loading = false;
  final FriendService _friendService = FriendService();

  Future<void> _searchUsers(String query) async {
    setState(() { loading = true; });
    try {
      final results = await _friendService.searchUsers(query);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      setState(() {
        searchResults = [];
      });
    }
    setState(() { loading = false; });
  }

  Future<void> _sendFriendRequest(String friendId, String name) async {
    try {
      await _friendService.sendRequest(friendId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Friend request sent to $name")),
      );
      if (search.trim().isNotEmpty) {
        _searchUsers(search.trim());
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send request")),
      );
    }
  }

  Widget _buildTrailing(dynamic u) {
    final status = u['relationship_status'];
    if (status == 'friends') {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          minimumSize: const Size(60, 36),
        ),
        child: const Text('Friend', style: TextStyle(fontWeight: FontWeight.bold)),
      );
    } else if (status == 'sent') {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[400],
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          minimumSize: const Size(60, 36),
        ),
        child: const Text('Sent', style: TextStyle(fontWeight: FontWeight.bold)),
      );
    } else if (status == 'pending') {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[400],
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          minimumSize: const Size(60, 36),
        ),
        child: const Text('Pending', style: TextStyle(fontWeight: FontWeight.bold)),
      );
    }
    return ElevatedButton(
      onPressed: () => _sendFriendRequest(
          u['id'].toString(), u['name'] ?? u['username'] ?? ''),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        minimumSize: const Size(60, 36),
      ),
      child: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              onChanged: (v) {
                setState(() => search = v);
                if (v.trim().isNotEmpty) {
                  _searchUsers(v.trim());
                } else {
                  setState(() => searchResults = []);
                }
              },
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
            child: loading
                ? Center(child: CircularProgressIndicator())
                : (searchResults.isEmpty || search.isEmpty)
                    ? Center(
                        child: Text("No users found.",
                            style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                      )
                    : ListView.separated(
                        itemCount: searchResults.length,
                        separatorBuilder: (_, __) => const Divider(
                          thickness: 1,
                          indent: 24,
                          endIndent: 24,
                        ),
                        itemBuilder: (context, i) {
                          final u = searchResults[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  u['avatar'] ?? 'assets/avatars/free/free1.png'),
                              radius: 28,
                            ),
                            title: Text(
                              u['name'] ?? u['username'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            ),
                            subtitle: Text(
                              u['handle'] ?? u['email'] ?? '',
                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            ),
                            trailing: _buildTrailing(u),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
