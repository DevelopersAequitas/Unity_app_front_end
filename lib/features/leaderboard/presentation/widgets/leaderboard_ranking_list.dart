import 'package:flutter/material.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';
import 'leaderboard_ranking_row.dart';

class LeaderboardRankingList extends StatelessWidget {
  final List<LeaderboardEntryEntity> rankings;
  final bool isImpact;

  const LeaderboardRankingList({
    super.key,
    required this.rankings,
    this.isImpact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (rankings.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section Header ──
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: isImpact
                      ? const LinearGradient(
                          colors: [Color(0xFF9333EA), Color(0xFFC026D3)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isImpact ? Icons.person_rounded : Icons.emoji_events_outlined,
                      size: 13,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isImpact ? 'IMPACT RANKINGS' : 'TOP PEERS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),

        // ── Ranking Peer Cards ──
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rankings.length,
          itemBuilder: (context, index) {
            final entry = rankings[index];
            return LeaderboardRankingRow(
              entry: entry,
              isLast: index == rankings.length - 1,
              isImpact: isImpact,
            );
          },
        ),
      ],
    );
  }
}
