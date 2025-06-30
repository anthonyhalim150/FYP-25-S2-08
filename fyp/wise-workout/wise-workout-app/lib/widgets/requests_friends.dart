import 'package:flutter/material.dart';

class RequestsTab extends StatelessWidget {
  final List<Map<String, String>> requests;
  final Function(int) acceptRequest;
  final Function(int) ignoreRequest;

  const RequestsTab({
    Key? key,
    required this.requests,
    required this.acceptRequest,
    required this.ignoreRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return Center(child: Text('No requests.'));
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: requests.length,
      itemBuilder: (context, i) {
        final f = requests[i];
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () => acceptRequest(i),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2176FF),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  minimumSize: const Size(0, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                ),
                child: const Text('Accept'),
              ),
              const SizedBox(width: 6),
              ElevatedButton(
                onPressed: () => ignoreRequest(i),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
                  minimumSize: const Size(0, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                ),
                child: const Text('Ignore'),
              ),
            ],
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