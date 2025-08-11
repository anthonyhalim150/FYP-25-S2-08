import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/challenge_service.dart';

class ChallengeLeaderboardWidget extends StatefulWidget {
  const ChallengeLeaderboardWidget({super.key});
  @override
  State<ChallengeLeaderboardWidget> createState() => _ChallengeLeaderboardWidgetState();
}

class _ChallengeLeaderboardWidgetState extends State<ChallengeLeaderboardWidget> {
  final ChallengeService _service = ChallengeService();
  late Future<List<_ChallengeGroup>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<_ChallengeGroup>> _load() async {
    final rows = await _service.getLeaderboard();
    final byInvite = <int, List<_LeaderRow>>{};
    for (final m in rows) {
      final r = _LeaderRow.fromMap(m);
      byInvite.putIfAbsent(r.inviteId, () => []).add(r);
    }
    final groups = <_ChallengeGroup>[];
    byInvite.forEach((inviteId, list) {
      if (list.isEmpty) return;
      final first = list.first;
      groups.add(_ChallengeGroup(
        inviteId: inviteId,
        title: first.type,
        target: '${first.value} ${first.unit}',
        daysLeft: first.daysLeft,
        totalDays: first.totalDays,
        participants: list.map((e) => e.username).toList(),
        values: list.map((e) => e.progress).toList(),
      ));
    });
    groups.sort((a, b) => a.inviteId.compareTo(b.inviteId));
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_ChallengeGroup>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError || snap.data == null) {
          return Center(
              child: Text(
                  'Failed to load leaderboard',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.red)));
        }
        final groups = snap.data!;
        if (groups.isEmpty) {
          return Center(
              child: Text(
                  'No active challenges',
                  style: Theme.of(context).textTheme.bodyMedium));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: groups.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final g = groups[i];
            final durationText = g.daysLeft == 0
                ? 'Expired'
                : '${g.daysLeft} day${g.daysLeft == 1 ? '' : 's'} left';
            return _buildChallengeCard(
              context: context,
              title: g.title,
              target: g.target,
              duration: durationText,
              participants: g.participants,
              values: g.values,
            );
          },
        );
      },
    );
  }

  Widget _buildChallengeCard({
    required BuildContext context,
    required String title,
    required String target,
    required String duration,
    required List<String> participants,
    required List<int> values,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final barMaxHeight = 120.0;
    final maxVal = values.isEmpty
        ? 0.0
        : values.fold<double>(0, (p, n) => n > p ? n.toDouble() : p);
    final safeMax = maxVal.isFinite && maxVal > 0 ? maxVal : 1.0;
    return Container(
      decoration: BoxDecoration(
          color: theme.cardColor, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Text('• on progress',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.green, fontWeight: FontWeight.w500)),
        ]),
        const SizedBox(height: 6),
        Text('Target: $target', style: theme.textTheme.bodySmall),
        Text('Duration: $duration', style: theme.textTheme.bodySmall),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(participants.length, (index) {
              final name = participants[index];
              final raw = index < values.length ? values[index] : 0;
              final v = raw.toDouble();
              final ratio = (v / safeMax);
              final safeRatio =
                  ratio.isFinite && !ratio.isNaN ? ratio.clamp(0.0, 1.0) : 0.0;
              final fillHeight = barMaxHeight * safeRatio;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: barMaxHeight + 24,
                    child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                              width: 36,
                              height: barMaxHeight,
                              decoration: BoxDecoration(
                                  color: _getColor(index).withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20))),
                          Container(
                            width: 36,
                            height: fillHeight,
                            decoration: BoxDecoration(
                                color: _getColor(index),
                                borderRadius: BorderRadius.circular(20)),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('$raw',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    '/${maxVal.isFinite ? maxVal.toInt() : 0}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                      width: 60,
                      child: Text(name,
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis)),
                ],
              );
            }),
          ),
        ),
      ]),
    );
  }

  Color _getColor(int index) {
    const colors = [
      Color(0xFFD32F2F),
      Color(0xFFFFC107),
      Color(0xFFEC407A),
      Color(0xFF7E57C2),
      Color(0xFF26C6DA)
    ];
    return colors[index % colors.length];
  }
}

class _LeaderRow {
  final int inviteId;
  final String type;
  final int value;
  final String unit;
  final int totalDays;
  final int daysLeft;
  final String username;
  final int progress;
  _LeaderRow({
    required this.inviteId,
    required this.type,
    required this.value,
    required this.unit,
    required this.totalDays,
    required this.daysLeft,
    required this.username,
    required this.progress,
  });
  factory _LeaderRow.fromMap(Map<String, dynamic> m) {
    final inviteId = (m['invite_id'] as num?)?.toInt() ?? 0;
    final type = (m['type'] ?? '').toString();
    final value = (m['value'] as num?)?.toInt() ?? 0;
    final unit = (m['unit'] ?? '').toString();
    final totalDays = (m['total_days'] as num?)?.toInt() ?? 0;
    final daysLeft = (m['days_left'] as num?)?.toInt() ?? 0;
    final username = (m['username'] ?? '').toString();
    final progress = (m['progress'] as num?)?.toInt() ?? 0;
    return _LeaderRow(
      inviteId: inviteId,
      type: type,
      value: value,
      unit: unit,
      totalDays: totalDays,
      daysLeft: daysLeft,
      username: username,
      progress: progress,
    );
  }
}

class _ChallengeGroup {
  final int inviteId;
  final String title;
  final String target;
  final int daysLeft;
  final int totalDays;
  final List<String> participants;
  final List<int> values;
  _ChallengeGroup({
    required this.inviteId,
    required this.title,
    required this.target,
    required this.daysLeft,
    required this.totalDays,
    required this.participants,
    required this.values,
  });
}
