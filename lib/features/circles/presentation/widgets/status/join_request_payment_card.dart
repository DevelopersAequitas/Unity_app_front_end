import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_join_request_entity.dart';

class JoinRequestPaymentCard extends StatelessWidget {
  final CircleJoinRequestEntity request;
  final VoidCallback onPayTap;
  final VoidCallback? onCheckStatusTap;
  final bool isPaying;
  final bool isCheckingStatus;

  const JoinRequestPaymentCard({
    super.key,
    required this.request,
    required this.onPayTap,
    this.onCheckStatusTap,
    this.isPaying = false,
    this.isCheckingStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryText = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final secondaryText = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    // 1. Paid / Circle Member Badge
    if (request.isMember || request.isPaid) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColor.success.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColor.success,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Circle Member',
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColor.success,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Payment complete. You have full access to this circle.',
                    style: AppTypography.bodySmall.copyWith(
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // 2. Rejection Notice
    if (request.isRejected) {
      final reason = request.effectiveRejectionReason;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColor.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.cancel_outlined,
                  color: AppColor.error,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  request.isRejectedByCd
                      ? 'Rejected by Circle Director'
                      : (request.isRejectedById
                            ? 'Rejected by Industry Director'
                            : 'Application Not Approved'),
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColor.error,
                  ),
                ),
              ],
            ),
            if (reason.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Reason: $reason',
                style: AppTypography.bodySmall.copyWith(color: primaryText),
              ),
            ],
          ],
        ),
      );
    }

    // 3. Pending Fee / Can Pay Flow
    if (request.isPaymentRequired) {
      // final amountText = request.amount != null
      //     ? '${request.currency ?? 'INR'} ${request.amount!.toInt()}'
      //     : null;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColor.primaryBlue.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryBlue.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.payments_outlined,
                    color: AppColor.primaryBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Application Approved — Fee Required',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: primaryText,
                        ),
                      ),
                      // if (amountText != null) ...[
                      //   const SizedBox(height: 2),
                      //   Text(
                      //     'Membership Fee: $amountText',
                      //     style: AppTypography.bodySmall.copyWith(
                      //       color: AppColor.primaryBlue,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      // ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColor.brandGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primaryPink.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: isPaying ? null : onPayTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.transparent,
                    shadowColor: AppColor.transparent,
                    foregroundColor: AppColor.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: isPaying
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.white,
                          ),
                        )
                      : const Icon(Icons.lock_outline_rounded, size: 18),
                  label: Text(
                    isPaying ? 'Generating Checkout...' : 'Pay Circle Fee Now',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            if (onCheckStatusTap != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: TextButton.icon(
                  onPressed: isCheckingStatus ? null : onCheckStatusTap,
                  icon: isCheckingStatus
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: AppColor.primaryBlue,
                          ),
                        )
                      : const Icon(Icons.sync_rounded, size: 16),
                  label: Text(
                    isCheckingStatus
                        ? 'Verifying payment...'
                        : 'Already Paid? Check Status',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
