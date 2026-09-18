import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/last_month_activity_entity.dart';

class ActivityBreakdownCard extends StatelessWidget {
  final LastMonthActivityEntity activity;

  const ActivityBreakdownCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      if (activity.p2pDisplayText.isNotEmpty)
        {'title': 'P2P Meetings', 'content': activity.p2pDisplayText, 'icon': Icons.people_outline_rounded, 'color': AppColor.primaryBlue},
      if (activity.dealsReceivedDisplayText.isNotEmpty)
        {'title': 'Deals Received', 'content': activity.dealsReceivedDisplayText, 'icon': Icons.arrow_downward_rounded, 'color': AppColor.success},
      if (activity.dealsGivenDisplayText.isNotEmpty)
        {'title': 'Deals Given', 'content': activity.dealsGivenDisplayText, 'icon': Icons.arrow_upward_rounded, 'color': const Color(0xFFF59E0B)},
      if (activity.referralsGivenDisplayText.isNotEmpty)
        {'title': 'Referrals Given', 'content': activity.referralsGivenDisplayText, 'icon': Icons.share_outlined, 'color': const Color(0xFF8B5CF6)},
      if (activity.testimonialsDisplayText.isNotEmpty)
        {'title': 'Testimonials Given', 'content': activity.testimonialsDisplayText, 'icon': Icons.verified_outlined, 'color': const Color(0xFFEC4899)},
    ];

    if (items.isEmpty) return const SizedBox.shrink();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.list_alt_rounded, size: 16, color: AppColor.primaryBlue),
              const SizedBox(width: 6),
              Text(
                'Recent Activity Details',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map((it) {
            final color = it['color'] as Color;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(it['icon'] as IconData, size: 14, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            it['title'] as String,
                            style: AppTypography.labelSmall.copyWith(
                              color: color,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            it['content'] as String,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                              fontSize: 11,
                              height: 1.35,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
