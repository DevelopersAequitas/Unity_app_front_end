import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/last_month_activity_entity.dart';

class ActivityMetricGrid extends StatelessWidget {
  final LastMonthActivityEntity activity;

  const ActivityMetricGrid({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final metrics = [
      {'title': 'P2P Meetings', 'val': '${activity.p2pMeetings}', 'icon': Icons.people_outline_rounded, 'color': AppColor.primaryBlue},
      {'title': 'Deals Received', 'val': '${activity.dealsReceived}', 'icon': Icons.arrow_downward_rounded, 'color': AppColor.success},
      {'title': 'Deals Given', 'val': '${activity.dealsGiven}', 'icon': Icons.arrow_upward_rounded, 'color': const Color(0xFFF59E0B)},
      {'title': 'Referrals Given', 'val': '${activity.referralsGiven}', 'icon': Icons.share_outlined, 'color': const Color(0xFF8B5CF6)},
      {'title': 'Testimonials Given', 'val': '${activity.testimonials}', 'icon': Icons.verified_outlined, 'color': const Color(0xFFEC4899)},
      {'title': 'Registered Visitors', 'val': '${activity.visitors}', 'icon': Icons.how_to_reg_outlined, 'color': const Color(0xFF06B6D4)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final m = metrics[index];
        final iconColor = m['color'] as Color;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(m['icon'] as IconData, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      m['val'] as String,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      m['title'] as String,
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

