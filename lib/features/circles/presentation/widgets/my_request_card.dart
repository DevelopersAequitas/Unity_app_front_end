import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/circle_join_request_entity.dart';
import 'circle_icon_helper.dart';

class MyRequestCard extends StatelessWidget {
  final CircleJoinRequestEntity request;
  final VoidCallback onTap;

  const MyRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = CircleIconHelper.getCategoryConfig(request.categoryName, request.categoryId);
    final cardBg = isDark ? AppColor.darkSurface : Color.lerp(AppColor.white, config.tintColor, 0.04)!;
    final borderColor = isDark ? AppColor.darkBorder : config.tintColor.withValues(alpha: 0.2);
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final hasPaymentUrl = request.paymentUrl != null && request.paymentUrl!.isNotEmpty && !request.isPaid;
    final statusLabel = hasPaymentUrl
        ? 'Pay Circle Fee'
        : (request.statusLabel.isNotEmpty ? request.statusLabel : request.displayStatus);
    final hasL4 = request.level4CategoryName != null && request.level4CategoryName!.trim().isNotEmpty;
    final title = request.categoryName.isNotEmpty ? request.categoryName : request.circleName;
    final isApproved = request.isApproved;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.9),
      ),
      child: Material(
        color: AppColor.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: config.tintColor,
                        boxShadow: [
                          BoxShadow(
                            color: config.tintColor.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(config.icon, color: AppColor.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: FontWeight.w500,
                              color: primaryText,
                              height: 1.25,
                            ),
                          ),
                          if (hasL4) ...[
                            const SizedBox(height: 3),
                            Text(
                              request.level4CategoryName!,
                              style: AppTypography.bodySmall.copyWith(
                                color: config.tintColor,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: isApproved
                            ? const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)])
                            : (hasPaymentUrl
                                ? const LinearGradient(colors: [Color(0xFFEA580C), Color(0xFFF97316)])
                                : AppColor.brandGradient),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: (hasPaymentUrl ? const Color(0xFFEA580C) : AppColor.primaryPink).withValues(alpha: 0.18),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasPaymentUrl) ...[
                            const Icon(Icons.payment_rounded, size: 12, color: AppColor.white),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            statusLabel,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColor.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.schedule_outlined, size: 13, color: secondaryText),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(request.requestedAt),
                      style: AppTypography.bodySmall.copyWith(color: secondaryText, fontSize: 11),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right_rounded, size: 16, color: AppColor.primaryBlue),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
