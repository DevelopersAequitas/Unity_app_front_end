import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/claim_coin_entity.dart';

class ClaimRequestStatusTile extends StatelessWidget {
  final ClaimCoinEntity claim;

  const ClaimRequestStatusTile({super.key, required this.claim});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusConfig = _getStatusConfig(claim.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  claim.activityLabel,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusConfig.backgroundColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusConfig.icon, size: 12, color: statusConfig.textColor),
                    const SizedBox(width: 4),
                    Text(
                      statusConfig.label,
                      style: AppTypography.labelSmall.copyWith(
                        color: statusConfig.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Image.asset('assets/images/coin.png', width: 14, height: 14),
              const SizedBox(width: 4),
              Text(
                '+${claim.coinsAwarded > 0 ? claim.coinsAwarded : '—'} Coins',
                style: AppTypography.bodySmall.copyWith(
                  color: const Color(0xFFD97706),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (claim.subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              claim.subtitle,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (claim.reviewNote != null && claim.reviewNote!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Remarks: ${claim.reviewNote}',
              style: AppTypography.labelSmall.copyWith(
                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (claim.createdAt.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              AppDateFormatter.formatDateTime(claim.createdAt),
              style: AppTypography.labelSmall.copyWith(
                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _ClaimStatusConfig _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const _ClaimStatusConfig(
          label: 'Approved',
          backgroundColor: Color(0x1F10B981),
          textColor: Color(0xFF059669),
          icon: Icons.check_circle_rounded,
        );
      case 'rejected':
        return const _ClaimStatusConfig(
          label: 'Rejected',
          backgroundColor: Color(0x1FEF4444),
          textColor: Color(0xFFDC2626),
          icon: Icons.cancel_rounded,
        );
      case 'pending':
      default:
        return const _ClaimStatusConfig(
          label: 'Pending Review',
          backgroundColor: Color(0x1FF59E0B),
          textColor: Color(0xFFD97706),
          icon: Icons.hourglass_top_rounded,
        );
    }
  }
}

class _ClaimStatusConfig {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;

  const _ClaimStatusConfig({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });
}
