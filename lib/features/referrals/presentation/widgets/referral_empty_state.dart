import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/referrals_event.dart';

class ReferralEmptyState extends StatelessWidget {
  final ReferralTab tab;
  final VoidCallback? onActionTap;
  final String searchQuery;
  final String? statusFilter;

  const ReferralEmptyState({
    super.key,
    required this.tab,
    this.onActionTap,
    this.searchQuery = '',
    this.statusFilter,
  });

  @override
  Widget build(BuildContext context) {
    if (searchQuery.trim().isNotEmpty || (statusFilter != null && statusFilter!.isNotEmpty)) {
      final filterMsg = statusFilter != null && statusFilter!.isNotEmpty
          ? ' with status "$statusFilter"'
          : '';
      final queryMsg = searchQuery.trim().isNotEmpty
          ? ' matching "$searchQuery"'
          : '';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 34,
                  color: AppColor.primaryBlue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No matching referrals',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColor.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'No referrals found$queryMsg$filterMsg.\nTry clearing filters or search with another keyword.',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                  color: AppColor.lightTextTertiary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final isReceived = tab == ReferralTab.received;
    final subtitle = isReceived
        ? 'When peers share business referrals with you,\nthey will show up here.'
        : "You haven't given any referrals yet.\nShare business leads with your peers to collaborate.";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColor.primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_alt_outlined,
                size: 38,
                color: AppColor.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No referrals yet',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColor.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                color: AppColor.lightTextTertiary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (onActionTap != null) ...[
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: onActionTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.primaryBlue,
                  side: const BorderSide(color: AppColor.primaryBlue, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  isReceived ? 'Give a Referral' : 'Add Referral',
                  style: AppTypography.labelMedium.copyWith(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: AppColor.primaryBlue,
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
