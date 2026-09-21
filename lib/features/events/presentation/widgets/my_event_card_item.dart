import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/event_registration_entity.dart';

class MyEventCardItem extends StatelessWidget {
  final EventRegistrationEntity item;
  final VoidCallback onTap;
  final VoidCallback onViewQr;

  const MyEventCardItem({
    super.key,
    required this.item,
    required this.onTap,
    required this.onViewQr,
  });

  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColor.primaryBlue : AppColor.primaryBlue;
    final dt = item.startAt;

    final dayStr = dt != null ? dt.day.toString().padLeft(2, '0') : '—';
    final monthStr = dt != null ? _months[dt.month - 1] : 'EVENT';

    final isConfirmed = item.isConfirmed;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar Badge
                  Column(
                    children: [
                      Text(
                        dayStr,
                        style: AppTypography.displayLarge.copyWith(
                          color: primary,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        monthStr,
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Title & Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.eventTitle ?? 'Event Pass',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.titleMedium.copyWith(
                            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (item.startAt != null)
                          Text(
                            AppDateFormatter.formatDateTime(item.startAt),
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                            ),
                          ),
                        if (item.location != null && item.location!.isNotEmpty)
                          Text(
                            item.location!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Status Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isConfirmed ? AppColor.success : AppColor.warning)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.status.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: isConfirmed ? AppColor.success : AppColor.warning,
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Action Button
              SizedBox(
                width: double.infinity,
                height: 34,
                child: isConfirmed
                    ? OutlinedButton.icon(
                        onPressed: onViewQr,
                        icon: const Icon(Icons.qr_code_rounded, size: 15),
                        label: const Text(
                          'View Pass & QR',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primary,
                          side: BorderSide(color: primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: onViewQr,
                        icon: const Icon(Icons.payment_rounded, size: 15),
                        label: const Text(
                          'Pay Fees',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2563EB),
                          side: const BorderSide(color: Color(0xFF2563EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
