import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_join_request_entity.dart';

class JoinRequestCancelButton extends StatelessWidget {
  final CircleJoinRequestEntity? request;
  final bool isCancelling;
  final VoidCallback onCancel;

  const JoinRequestCancelButton({
    super.key,
    required this.request,
    required this.isCancelling,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    if (request == null ||
        request!.isApproved ||
        request!.isRejected ||
        request!.isPaid ||
        request!.isPaymentRequired ||
        request!.canPay ||
        (request!.paymentUrl != null && request!.paymentUrl!.isNotEmpty) ||
        request!.status.toLowerCase().contains('fee') ||
        request!.displayStatus.toLowerCase().contains('fee') ||
        request!.statusLabel.toLowerCase().contains('fee')) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: OutlinedButton(
          onPressed: isCancelling ? null : () => _showConfirmSheet(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColor.error,
            side: BorderSide(color: AppColor.error.withValues(alpha: 0.4)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: isCancelling
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.error),
                )
              : Text(
                  'Cancel Join Request',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.error,
                  ),
                ),
        ),
      ),
    );
  }

  void _showConfirmSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + MediaQuery.of(sheetContext).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline_rounded, color: AppColor.primaryBlue, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cancel Join Request?',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w500,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Are you sure you want to cancel your application?',
                        style: AppTypography.bodySmall.copyWith(color: secondaryText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.of(sheetContext).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: AppColor.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: const Text('Keep Request', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  onCancel();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.error,
                  side: BorderSide(color: AppColor.error.withValues(alpha: 0.35)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Yes, Cancel Request', style: TextStyle(fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
