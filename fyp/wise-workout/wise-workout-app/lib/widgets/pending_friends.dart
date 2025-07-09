import 'package:flutter/material.dart';

class PendingTab extends StatelessWidget {
  final List<Map<String, dynamic>> pending;

  const PendingTab({
    Key? key,
    required this.pending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pending.isEmpty) {
      return const Center(child: Text('No pending requests.'));
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: pending.length,
      itemBuilder: (context, i) {
        final f = pending[i];
        return ListTile(
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(f['background_url'] ?? 'assets/background/black.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: CircleAvatar(
                backgroundImage: AssetImage(f['avatar_url'] ?? ''),
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
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          trailing: const Text(
            "Requested",
            style: TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
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
