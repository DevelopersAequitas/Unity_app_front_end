import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/last_month_activity_entity.dart';

class ActivityHeaderCard extends StatelessWidget {
  final LastMonthActivityEntity activity;

  const ActivityHeaderCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalActions = activity.p2pMeetings +
        activity.dealsGiven +
        activity.dealsReceived +
        activity.referralsGiven +
        activity.testimonials;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          AppAvatar(
            imageUrl: activity.profilePhotoUrl,
            name: activity.userName,
            size: 38,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.userName,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  activity.businessName.isNotEmpty ? activity.businessName : activity.periodName,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColor.primaryBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$totalActions Actions',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColor.primaryBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (activity.totalDays > 0)
                  Text(
                    'Last ${activity.totalDays} Days',
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
