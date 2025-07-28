import 'package:flutter/material.dart';

class ViewCTWidget extends StatelessWidget {
  final String title;
  final String target;
  final String duration;
  final VoidCallback onInvite;

  const ViewCTWidget({
    super.key,
    required this.title,
    required this.target,
    required this.duration,
    required this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final shadowColor = Theme.of(context).shadowColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size(60, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Edit",
                  style: textTheme.labelLarge?.copyWith(fontSize: 13, color: colorScheme.onPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Target: $target",
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface, fontSize: 14),
          ),
          Text(
            "Duration: $duration",
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface, fontSize: 14),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onInvite,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                "+ Challenge Friend",
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------ TOURNAMENT CARD ------------------
class TournamentCard extends StatelessWidget {
  final Map<String, dynamic> tournament;
  final VoidCallback onJoin;

  const TournamentCard({
    super.key,
    required this.tournament,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tournament['title'],
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            tournament['description'],
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ),
          const SizedBox(height: 6),
          Text(
            tournament['endDate'],
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          ...List<Widget>.from(
            (tournament['features'] as List<dynamic>).map(
                  (feature) => Row(
                children: [
                  Icon(Icons.check, size: 16, color: colorScheme.secondary),
                  const SizedBox(width: 6),
                  Text(
                    feature,
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: Text('Join', style: textTheme.labelLarge?.copyWith(color: colorScheme.onPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------ JOIN TOURNAMENT POPUP ------------------
void showTournamentJoinPopup(
    BuildContext context, Map<String, dynamic> tournament) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext ctx) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(ctx).pop(),
        child: GestureDetector(
          onTap: () {}, // Prevent auto-close on tap
          child: DraggableScrollableSheet(
            initialChildSize: 0.75,
            maxChildSize: 0.9,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                ),
                padding: const EdgeInsets.all(24),
                child: ListView(
                  controller: controller,
                  children: [
                    Text(
                      tournament['title'],
                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withOpacity(.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(tournament['description'],
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
                    const SizedBox(height: 16),
                    Text(
                      "What's Included:",
                      style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...List<Widget>.from(
                      (tournament['features'] as List<dynamic>).map(
                            (feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("• ",
                                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.secondary)),
                              Expanded(
                                child: Text(feature,
                                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Joined tournament successfully!',
                                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onInverseSurface)),
                            backgroundColor: colorScheme.inverseSurface,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text('Join', style: textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

/// ------------------ INVITE FRIEND POPUP ------------------
void showInviteFriendPopup(
    BuildContext context, String title, String target, String duration) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  final friends = [
    {'name': 'Anthony Halim', 'username': '@pitbull101'},
    {'name': 'Matilda Yeo', 'username': '@matyeo'},
    {'name': 'Jackson Wang', 'username': '@jackson'},
  ];
  final Set<int> selectedIndices = {};
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext ctx) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(ctx).pop(),
        child: GestureDetector(
          onTap: () {},
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            builder: (_, controller) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Target: $target",
                                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
                              Text("Duration: $duration",
                                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: friends.length,
                            itemBuilder: (context, index) {
                              final friend = friends[index];
                              final isSelected = selectedIndices.contains(index);
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CircleAvatar(
                                  backgroundColor: colorScheme.secondary,
                                  child: Icon(Icons.person, color: colorScheme.onSecondary),
                                ),
                                title: Text(friend['name']!,
                                    style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface)),
                                subtitle: Text(friend['username']!,
                                    style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                trailing: IconButton(
                                  icon: Icon(
                                    isSelected
                                        ? Icons.check_circle
                                        : Icons.add_circle_outline,
                                    color: isSelected
                                        ? colorScheme.primary
                                        : colorScheme.secondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedIndices.remove(index);
                                      } else {
                                        selectedIndices.add(index);
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.secondary,
                            foregroundColor: colorScheme.onSecondary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: Text("Done",
                              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSecondary)),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    },
  );
}