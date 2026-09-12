import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileCirclesCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileCirclesCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final memberships = profile.circleMemberships;
    final hasActiveCircle = profile.activeCircle != null;

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
              const Icon(Icons.hub_outlined, size: 18, color: AppColor.primaryBlue),
              const SizedBox(width: 6),
              Text(
                'Joined Circles',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              const Spacer(),
              if (memberships.isNotEmpty)
                Text(
                  '${memberships.length} Circle${memberships.length > 1 ? "s" : ""}',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColor.lightTextTertiary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (memberships.isNotEmpty)
            ...memberships.map((m) => _buildMembershipRow(m))
          else if (hasActiveCircle)
            _buildActiveCircleFallback()
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                color: AppColor.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'No circle assigned yet',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 11.5,
                  color: AppColor.lightTextTertiary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMembershipRow(CircleMembershipEntity m) {
    final dateRange = AppDateFormatter.formatRange(m.joinedAt, m.expiresAt, defaultValue: 'Active');
    final isRoleLeader = m.memberRole?.toLowerCase() == 'leader' || m.memberRole?.toLowerCase() == 'admin';

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  m.circleName,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppColor.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (m.memberRole != null && m.memberRole!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: (isRoleLeader ? AppColor.accentGreen : AppColor.primaryBlue).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    m.memberRole!,
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                      color: isRoleLeader ? AppColor.accentGreen : AppColor.primaryBlue,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              const Icon(Icons.schedule_outlined, size: 11.5, color: AppColor.lightTextTertiary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  dateRange,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10.5,
                    color: AppColor.lightTextTertiary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCircleFallback() {
    final active = profile.activeCircle!;
    final dateRange = AppDateFormatter.formatRange(
      profile.circleJoinedAt,
      profile.circleExpiresAt,
      defaultValue: 'Active',
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  active.name,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppColor.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dateRange,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10.5,
                    color: AppColor.lightTextTertiary,
                  ),
                ),
              ],
            ),
          ),
          if (active.city?.name != null)
            Text(
              active.city!.name,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 10.5,
                color: AppColor.lightTextTertiary,
              ),
            ),
        ],
      ),
    );
  }
}
