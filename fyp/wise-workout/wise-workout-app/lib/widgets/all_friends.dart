import 'package:flutter/material.dart';

class AllFriendsTab extends StatelessWidget {
  final List<Map<String, dynamic>> friends;
  final Function(Map<String, dynamic> friend) onFriendTap;

  const AllFriendsTab({
    Key? key,
    required this.friends,
    required this.onFriendTap,
  }) : super(key: key);

  String safeAvatar(String? path) {
    return (path == null || path.isEmpty) ? 'assets/background/black.jpg' : path;
  }

  String safeBackground(String? path) {
    return (path == null || path.isEmpty) ? 'assets/background/black.jpg' : path;
  }

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return const Center(child: Text('No friends found.'));
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: friends.length,
      itemBuilder: (context, i) {
        final f = friends[i];
        final unread = f['unread_count'] ?? 0;

        return ListTile(
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(
                  safeBackground(f['background_url']),
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: CircleAvatar(
                backgroundImage: AssetImage(safeAvatar(f['avatar_url'])),
                radius: 22,
                backgroundColor: Colors.transparent,
              ),
            ),
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
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          trailing: unread > 0
              ? Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unread.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
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