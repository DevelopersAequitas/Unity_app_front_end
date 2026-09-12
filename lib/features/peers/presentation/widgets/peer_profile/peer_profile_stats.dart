import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/features/profile/domain/entities/profile_entity.dart';

class PeerProfileStats extends StatelessWidget {
  final ProfileEntity profile;

  const PeerProfileStats({super.key, required this.profile});

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildStatsCard([
            _buildCell(_formatCount(profile.lifeImpactedCount), 'Lives Impacted'),
            _buildDivider(),
            _buildCell(_formatCount(profile.connectionCount), 'Connections'),
            _buildDivider(),
            _buildCell(_formatCount(profile.followersCount), 'Followers'),
            _buildDivider(),
            _buildCell(_formatCount(profile.followingCount), 'Following'),
            _buildDivider(),
            _buildCell(_formatCount(profile.postsCount), 'Posts'),
          ]),
          const SizedBox(height: 8),
          _buildStatsCard([
            _buildCell(_formatCount(profile.coinsBalance), 'Coins'),
            _buildDivider(),
            _buildCell(_formatCount(profile.badgesCount), 'Badges'),
            _buildDivider(),
            _buildCell(_formatCount(profile.p2pMeetingsCount), 'P2P'),
            _buildDivider(),
            _buildCell(_formatCount(profile.referralsCount), 'Referrals'),
            _buildDivider(),
            _buildCell(_formatCount(profile.businessDealsCount), 'Deals'),
          ]),
        ],
      ),
    );
  }

  Widget _buildStatsCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
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
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: AppColor.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColor.lightTextTertiary,
              fontSize: 9,
              fontWeight: FontWeight.w400,
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
