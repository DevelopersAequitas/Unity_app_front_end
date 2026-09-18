import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

class LeaderboardHeader extends StatelessWidget {
  const LeaderboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Recognition Trophy Icon ──
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFBFDBFE),
                width: 1.0,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.emoji_events_outlined,
                color: Color(0xFF2563EB),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // ── Title & Subtitle ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leaderboard',
                  style: AppTypography.titleLarge.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Recognizing peers making an impact.',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 12.5,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // ── Right World Motto ──
          Container(
            padding: const EdgeInsets.only(left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.public_outlined,
                  size: 20,
                  color: const Color(0xFF93C5FD).withValues(alpha: 0.8),
                ),
                const SizedBox(height: 2),
                Text(
                  'Building\na stronger\nbusiness world\ntogether.',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 8.5,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B).withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
