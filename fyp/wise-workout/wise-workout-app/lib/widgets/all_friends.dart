import 'package:flutter/material.dart';

class AllFriendsTab extends StatelessWidget {
  final List<Map<String, dynamic>> friends;
  final Function(Map<String, dynamic> friend) onFriendTap;

  const AllFriendsTab({
    Key? key,
    required this.friends,
    required this.onFriendTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return Center(child: Text('No friends found.'));
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: friends.length,
      itemBuilder: (context, i) {
        final f = friends[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(
              f['avatar'] ?? 'assets/avatars/free/free1.png'
            ),
            radius: 28,
          ),
          title: Text(
            f['name'] ?? f['username'] ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          subtitle: Text(
            f['handle'] ?? f['email'] ?? '',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          onTap: () => onFriendTap(f),
        );
      },
      separatorBuilder: (_, __) => const Divider(
        thickness: 1,
        indent: 24,
        endIndent: 24,
      ),
    );
  }
}
