import 'package:flutter/material.dart';

class AllFriendsTab extends StatelessWidget {
  final List<Map<String, String>> friends;
  final Function(Map<String, String> friend) onFriendTap;

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