import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class LeaderboardEmptyState extends StatelessWidget {
  final VoidCallback? onRefresh;

  const LeaderboardEmptyState({
    super.key,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColor.primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.primaryBlue.withValues(alpha: 0.15),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.emoji_events_outlined,
                  size: 28,
                  color: AppColor.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No rankings available yet',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Leaderboard rankings will appear here as peers earn coins and create impact.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColor.lightTextSecondary,
              ),
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Refresh'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.primaryBlue,
                  side: const BorderSide(color: AppColor.primaryBlue, width: 0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
