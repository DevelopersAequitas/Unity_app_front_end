import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class CertificationResultDialog extends StatelessWidget {
  final String title;
  final String? tier;
  final int? score;
  final num? percentage;
  final String? certificateUrl;
  final VoidCallback onDismiss;

  const CertificationResultDialog({
    super.key,
    required this.title,
    this.tier,
    this.score,
    this.percentage,
    this.certificateUrl,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColor.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified_rounded, size: 48, color: AppColor.success),
            ),
            const SizedBox(height: 16),
            Text('Congratulations!', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(
              'You have successfully completed the $title assessment.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
            ),
            if (tier != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Tier: $tier',
                  style: AppTypography.titleMedium.copyWith(color: AppColor.primaryBlue, fontWeight: FontWeight.w500),
                ),
              ),
            ],
            if (score != null || percentage != null) ...[
              const SizedBox(height: 12),
              Text(
                'Score: ${score ?? '-'} (${percentage?.toStringAsFixed(1) ?? '-'}%)',
                style: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextSecondary),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onDismiss,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
