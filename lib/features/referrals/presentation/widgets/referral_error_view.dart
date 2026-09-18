import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class ReferralErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const ReferralErrorView({
    super.key,
    this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColor.lightTextTertiary,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? 'Unable to load referrals',
              style: AppTypography.bodySmall.copyWith(
                color: AppColor.lightTextSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.primaryBlue,
                side: const BorderSide(color: AppColor.primaryBlue, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
