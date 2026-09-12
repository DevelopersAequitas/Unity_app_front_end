import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileStatsRow extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileStatsRow({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary stats container
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColor.borderSubtle),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildStatCell(
                context,
                count: '${profile.connectionCount}',
                label: 'Connections',
              ),
              _buildDivider(),
              _buildStatCell(
                context,
                count: '${profile.followersCount}',
                label: 'Followers',
              ),
              _buildDivider(),
              _buildStatCell(
                context,
                count: '${profile.followingCount}',
                label: 'Following',
              ),
              _buildDivider(),
              _buildStatCell(
                context,
                count: '${profile.postsCount}',
                label: 'Posts',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Secondary Impact / Coins Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: _buildMetricBadge(
                  icon: Icons.favorite_rounded,
                  iconColor: const Color(0xFFEF4444),
                  count: '${profile.lifeImpactedCount}',
                  label: 'Lives Impacted',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildMetricBadge(
                  icon: Icons.monetization_on_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  count: '${profile.coinsBalance}',
                  label: 'Coins Balance',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCell(
    BuildContext context, {
    required String count,
    required String label,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColor.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColor.textTertiary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: AppColor.borderSubtle,
    );
  }

  Widget _buildMetricBadge({
    required IconData icon,
    required Color iconColor,
    required String count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs + 2),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 14,
              color: iconColor,
            ),
          ),
          SizedBox(width: AppSpacing.xs + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  count,
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColor.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColor.textTertiary,
                    fontSize: 10,
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
  }
}
