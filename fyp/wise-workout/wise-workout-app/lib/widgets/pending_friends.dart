import 'package:flutter/material.dart';

class PendingTab extends StatelessWidget {
  final List<Map<String, String>> pending;

  const PendingTab({
    Key? key,
    required this.pending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pending.isEmpty) {
      return Center(child: Text('No pending requests.'));
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: pending.length,
      itemBuilder: (context, i) {
        final f = pending[i];
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