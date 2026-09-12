import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileStatsRow extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileStatsRow({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatsCard([
          _buildCell('${profile.lifeImpactedCount}', 'Lives Impacted'),
          _buildDivider(),
          _buildCell('${profile.connectionCount}', 'Connections'),
          _buildDivider(),
          _buildCell('${profile.followersCount}', 'Followers'),
          _buildDivider(),
          _buildCell('${profile.followingCount}', 'Following'),
          _buildDivider(),
          _buildCell('${profile.postsCount}', 'Posts'),
        ]),
        const SizedBox(height: 8),
        _buildStatsCard([
          _buildCell('${profile.coinsBalance}', 'Coins'),
          _buildDivider(),
          _buildCell('${profile.badgesCount}', 'Badges'),
          _buildDivider(),
          _buildCell('${profile.p2pMeetingsCount}', 'P2P'),
          _buildDivider(),
          _buildCell('${profile.referralsCount}', 'Referrals'),
          _buildDivider(),
          _buildCell('${profile.businessDealsCount}', 'Deals'),
        ]),
      ],
    );
  }

  Widget _buildStatsCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Row(children: children),
    );
  }

  Widget _buildCell(String count, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: AppColor.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColor.lightTextTertiary,
              fontSize: 9,
              height: 1.1,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 18, width: 1, color: AppColor.lightBorder);
  }
}
