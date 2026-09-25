import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/life_impact_entity.dart';

class LifeImpactDetailSheet extends StatelessWidget {
  final LifeImpactEntity item;

  const LifeImpactDetailSheet({super.key, required this.item});

  String _formatDate(String raw) => AppDateFormatter.formatDateTime(raw);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final primaryColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;

    // Collect detail rows
    final details = <_DetailRow>[];
    if (item.performedBy != null) {
      details.add(_DetailRow(label: 'Performed By', value: item.performedBy!.fullName, icon: Icons.person_outline_rounded));
    }
    if (item.affectedUser != null) {
      details.add(_DetailRow(label: 'Affected Peer', value: item.affectedUser!.fullName, icon: Icons.people_outline_rounded));
    }
    if (item.activityDetails['meeting_place'] != null) {
      details.add(_DetailRow(label: 'Meeting Place', value: item.activityDetails['meeting_place'].toString(), icon: Icons.place_outlined));
    }
    if (item.activityDetails['deal_amount'] != null) {
      details.add(_DetailRow(label: 'Deal Amount', value: '₹${item.activityDetails['deal_amount']}', icon: Icons.currency_rupee_rounded));
    }
    if (item.activityDetails['referral_of'] != null) {
      details.add(_DetailRow(label: 'Referral For', value: item.activityDetails['referral_of'].toString(), icon: Icons.person_add_outlined));
    }

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Header row: activity type chip + score badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColor.primaryBlue.withValues(alpha: 0.2), width: 0.5),
                  ),
                  child: Text(
                    item.actionLabel.isNotEmpty ? item.actionLabel : 'Life Impact',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.primaryBlue,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded, color: Colors.white, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        '+${item.impactValue} Lives',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              item.title,
              style: AppTypography.titleLarge.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (item.createdAt.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 12, color: secondaryColor),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(item.createdAt),
                    style: AppTypography.bodySmall.copyWith(color: secondaryColor, fontSize: 11),
                  ),
                ],
              ),
            ],
            if (details.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 0.5),
                ),
                child: Column(
                  children: details.asMap().entries.map((e) {
                    final isLast = e.key == details.length - 1;
                    final row = e.value;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Icon(row.icon, size: 14, color: secondaryColor),
                              const SizedBox(width: 8),
                              Text(
                                row.label,
                                style: AppTypography.bodySmall.copyWith(
                                  color: secondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              Flexible(
                                child: Text(
                                  row.value,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          Divider(height: 1, thickness: 0.5, color: borderColor, indent: 12, endIndent: 12),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
            if (item.description.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                'Story / Remarks',
                style: AppTypography.labelMedium.copyWith(color: secondaryColor, fontSize: 11),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 0.5),
                ),
                child: Text(
                  item.description,
                  style: AppTypography.bodyMedium.copyWith(color: primaryColor, fontSize: 13),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow {
  final String label;
  final String value;
  final IconData icon;
  const _DetailRow({required this.label, required this.value, required this.icon});
}

