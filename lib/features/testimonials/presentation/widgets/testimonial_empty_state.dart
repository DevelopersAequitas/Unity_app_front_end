import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/testimonials_event.dart';

class TestimonialEmptyState extends StatelessWidget {
  final TestimonialTab tab;
  final VoidCallback? onActionTap;
  final String searchQuery;

  const TestimonialEmptyState({
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
                'No matching testimonials',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColor.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'No testimonials match "$searchQuery".\nTry searching with a different name, city or company.',
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

    final isReceived = tab == TestimonialTab.received;
    final subtitle = isReceived
        ? 'When peers appreciate your work,\nit shows up here.'
        : "You haven't given any testimonials yet.\nRecognize a peer to get started.";

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
                Icons.format_quote_rounded,
                size: 38,
                color: AppColor.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No testimonials yet',
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                child: Text(
                  isReceived ? 'Be the change' : 'Give Testimonial',
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
