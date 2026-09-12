import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileMembershipCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileMembershipCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final statusLabel = profile.membershipStatusLabel ??
        (profile.membershipStatus != null
            ? profile.membershipStatus!.replaceAll('_', ' ').toUpperCase()
            : 'Member');

    final dateRange = AppDateFormatter.formatRange(
      profile.membershipStartsAt,
      profile.membershipEndsAt,
      defaultValue: 'Active',
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.workspace_premium_outlined, size: 18, color: AppColor.primaryBlue),
              const SizedBox(width: 6),
              Text(
                'Membership',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusLabel,
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.primaryBlue,
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColor.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 13, color: AppColor.lightTextTertiary),
                const SizedBox(width: 6),
                Text(
                  'Validity:',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColor.lightTextTertiary,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    dateRange,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColor.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
