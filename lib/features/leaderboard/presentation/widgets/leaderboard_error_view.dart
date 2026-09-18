import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class LeaderboardErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const LeaderboardErrorView({
    super.key,
    required this.onRetry,
    this.message,
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
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColor.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 26,
                  color: AppColor.error,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Unable to load leaderboard',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message ?? 'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColor.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Try Again'),
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
        ),
      ),
    );
  }
}
