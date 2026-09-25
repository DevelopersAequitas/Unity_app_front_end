import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/life_impact_entity.dart';
import 'life_impact_detail_sheet.dart';

class LifeImpactTile extends StatelessWidget {
  final LifeImpactEntity item;

  const LifeImpactTile({super.key, required this.item});

  void _showDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => LifeImpactDetailSheet(item: item),
    );
  }

  String _getDisplayTitle() {
    switch (item.activityType) {
      case 'p2p_meeting':
        return 'P2P Meeting';
      case 'business_deal':
        return 'Business Deal';
      case 'referral':
        return 'Referral';
      case 'testimonial':
        return 'Testimonial';
      case 'admin_adjustment':
        return 'Admin Adjustment';
      default:
        return item.actionLabel.isNotEmpty ? item.actionLabel : item.activityType;
    }
  }

  IconData _getActivityIcon() {
    switch (item.activityType) {
      case 'p2p_meeting':
        return Icons.people_outline_rounded;
      case 'business_deal':
        return Icons.trending_up_rounded;
      case 'referral':
        return Icons.person_add_outlined;
      case 'testimonial':
        return Icons.format_quote_rounded;
      case 'admin_adjustment':
        return Icons.tune_rounded;
      default:
        return Icons.bolt_rounded;
    }
  }

  String _formatDate(String raw) => AppDateFormatter.format(raw);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final primaryColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;

    return InkWell(
      onTap: () => _showDetailSheet(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon badge
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.primaryBlue.withValues(alpha: 0.15),
                    AppColor.primaryBlue.withValues(alpha: 0.07),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColor.primaryBlue.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Icon(_getActivityIcon(), size: 18, color: AppColor.primaryBlue),
            ),
            const SizedBox(width: 10),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row + score badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          _getDisplayTitle(),
                          style: AppTypography.bodyMedium.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '+${item.impactValue}',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // Sub-description from server
                  Text(
                    item.title,
                    style: AppTypography.bodySmall.copyWith(
                      color: secondaryColor,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Bottom info row
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 10, color: secondaryColor),
                      const SizedBox(width: 3),
                      Text(
                        _formatDate(item.createdAt),
                        style: AppTypography.bodySmall.copyWith(
                          color: secondaryColor,
                          fontSize: 10,
                        ),
                      ),
                      if (item.performedBy != null) ...[ 
                        Container(
                          width: 3,
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: secondaryColor.withValues(alpha: 0.5),
                          ),
                        ),
                        Icon(Icons.person_outline_rounded, size: 10, color: secondaryColor),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            item.performedBy!.fullName,
                            style: AppTypography.bodySmall.copyWith(
                              color: secondaryColor,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Arrow indicator
            const SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: secondaryColor.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
