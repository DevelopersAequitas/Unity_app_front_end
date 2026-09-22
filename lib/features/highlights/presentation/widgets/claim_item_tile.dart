import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/claim_coin_entity.dart';

class ClaimItemTile extends StatelessWidget {
  final ClaimCoinEntity claim;

  const ClaimItemTile({super.key, required this.claim});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusConfig = _getStatusConfig(claim.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
                child: Text(
                  statusConfig.label,
                  style: AppTypography.labelSmall.copyWith(
                    color: statusConfig.textColor,
                    fontWeight: FontWeight.w500,
                  ),
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (claim.createdAt.isNotEmpty)
                Text(
                  AppDateFormatter.formatDateTime(claim.createdAt),
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                    fontSize: 11,
                  ),
                )
              else
                const SizedBox.shrink(),
              if (claim.isApproved && claim.coinsAwarded > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/coin.png', width: 14, height: 14),
                    const SizedBox(width: 4),
                    Text(
                      '+${claim.coinsAwarded} Coins',
                      style: AppTypography.labelSmall.copyWith(
                        color: const Color(0xFF059669),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return const _StatusConfig(
          label: 'Approved',
          backgroundColor: Color(0x1F10B981),
          textColor: Color(0xFF059669),
        );
      case 'rejected':
        return const _StatusConfig(
          label: 'Rejected',
          backgroundColor: Color(0x1FEF4444),
          textColor: Color(0xFFDC2626),
        );
      case 'pending':
      default:
        return const _StatusConfig(
          label: 'Pending Review',
          backgroundColor: Color(0x1FF59E0B),
          textColor: Color(0xFFD97706),
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _StatusConfig({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });
}
