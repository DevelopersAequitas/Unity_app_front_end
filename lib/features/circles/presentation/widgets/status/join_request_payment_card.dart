import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_join_request_entity.dart';

class JoinRequestPaymentCard extends StatelessWidget {
  final CircleJoinRequestEntity request;
  final ValueChanged<String> onPayTap;

  const JoinRequestPaymentCard({
    super.key,
    required this.request,
    required this.onPayTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    if (request.paymentUrl == null || request.paymentUrl!.isEmpty || request.isPaid) {
      return const SizedBox.shrink();
    }

    final isPro = request.isPro;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isPro
                      ? AppColor.success.withValues(alpha: 0.12)
                      : AppColor.primaryBlue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPro ? Icons.check_circle_outline_rounded : Icons.workspace_premium_outlined,
                  color: isPro ? AppColor.success : AppColor.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isPro
                      ? 'Application Approved — Pay Circle Fee'
                      : 'Application Approved — Pro Membership Required',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: primaryText,
                  ),
                ),
              ),
            ],
          ),
          if (!isPro) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                  width: 0.8,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, size: 15, color: AppColor.primaryBlue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please ensure Pro Membership is active before or during circle fee checkout.',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        color: secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
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
                onPressed: () => onPayTap(request.paymentUrl!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.transparent,
                  shadowColor: AppColor.transparent,
                  foregroundColor: AppColor.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                icon: const Icon(Icons.lock_outline_rounded, size: 18),
                label: Text(
                  isPro ? 'Pay Circle Fee Now' : 'Proceed to Checkout',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          if (!isPro) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/membership-paywall'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.primaryBlue,
                  side: const BorderSide(color: AppColor.primaryBlue, width: 0.8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                icon: const Icon(Icons.workspace_premium_outlined, size: 16),
                label: const Text('View Pro Membership Plans', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

