import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_join_request_entity.dart';
import '../circle_icon_helper.dart';

class JoinRequestStatusHeader extends StatelessWidget {
  final CircleJoinRequestEntity? request;
  final String circleName;

  const JoinRequestStatusHeader({
    super.key,
    required this.request,
    required this.circleName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName = request?.categoryName.isNotEmpty == true
        ? request!.categoryName
        : circleName;
    final config = CircleIconHelper.getCategoryConfig(displayName, request?.categoryId);

    final cardBg = isDark ? AppColor.darkSurface : Color.lerp(AppColor.white, config.tintColor, 0.04)!;
    final borderColor = isDark ? AppColor.darkBorder : config.tintColor.withValues(alpha: 0.2);
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final isApproved = request?.isApproved ?? false;
    final isRejected = request?.isRejected ?? false;
    final l4Name = request?.level4CategoryName;

    final title = isApproved
        ? 'Membership Approved'
        : isRejected
            ? (request?.statusLabel ?? 'Request Rejected')
            : (request?.statusLabel ?? 'Pending Approval');
    
    final subtitle = isApproved
        ? 'Welcome to $displayName!'
        : isRejected
            ? (request?.effectiveRejectionReason.isNotEmpty == true
                ? 'Reason: ${request!.effectiveRejectionReason}'
                : 'Your request did not meet circle criteria.')
            : 'Your request is currently under review.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
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
                  child: Icon(config.icon, color: AppColor.white, size: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: primaryText,
                        height: 1.25,
                      ),
                    ),
                    if (l4Name != null && l4Name.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        l4Name,
                        style: AppTypography.bodySmall.copyWith(
                          color: config.tintColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        gradient: isApproved
                            ? const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)])
                            : (isRejected
                                ? const LinearGradient(colors: [Color(0xFFDC2626), Color(0xFFEF4444)])
                                : AppColor.brandGradient),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        title,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColor.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 10.5,
                        ),
                      ),
                    ),
                    if (isRejected && request?.cdRejectedBy != null) ...[
                      const Spacer(),
                      Text(
                        'By ${request!.cdRejectedBy}',
                        style: AppTypography.labelSmall.copyWith(color: secondaryText, fontSize: 10.5),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(color: secondaryText, fontSize: 11.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
