import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/business_deals_event.dart';

class BusinessDealEmptyState extends StatelessWidget {
  final BusinessDealTab tab;
  final VoidCallback? onActionTap;
  final String searchQuery;

  const BusinessDealEmptyState({
    super.key,
    required this.tab,
    this.onActionTap,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    if (searchQuery.trim().isNotEmpty) {
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
                'No matching business deals',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColor.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'No business deals match "$searchQuery".\nTry searching with a different name, city, amount, or company.',
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

    final isReceived = tab == BusinessDealTab.received;
    final subtitle = isReceived
        ? 'When peers give you business deals,\nthey will show up here.'
        : "You haven't recorded any given deals yet.\nRecord business done with a peer to get started.";

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
                Icons.handshake_outlined,
                size: 38,
                color: AppColor.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No business deals yet',
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
                  isReceived ? 'Record a Deal' : 'Add Business Deal',
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
