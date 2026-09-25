import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileStatsRow extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileStatsRow({super.key, required this.profile});

  String _formatCount(int number) {
    if (number >= 1000000000000000) {
      final val = (number / 1000000000000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}Q';
    }
    if (number >= 1000000000000) {
      final val = (number / 1000000000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}T';
    }
    if (number >= 1000000000) {
      final val = (number / 1000000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}B';
    }
    if (number >= 1000000) {
      final val = (number / 1000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}M';
    }
    if (number >= 10000) {
      final val = (number / 1000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}K';
    }
    if (number >= 1000) {
      final str = number.toString();
      final chars = str.split('');
      final buffer = StringBuffer();
      for (int i = 0; i < chars.length; i++) {
        if (i > 0 && (chars.length - i) % 3 == 0) {
          buffer.write(',');
        }
        buffer.write(chars[i]);
      }
      return buffer.toString();
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatsCard([
          _buildCell(
            context,
            _formatCount(profile.lifeImpactedCount),
            'Lives Impacted',
            onTap: () => Navigator.pushNamed(context, AppRoutes.lifeImpact),
          ),
          _buildDivider(),
          _buildCell(
            context,
            _formatCount(profile.connectionCount),
            'Connections',
            onTap: () => Navigator.pushNamed(context, AppRoutes.connections),
          ),
          _buildDivider(),
          _buildCell(
            context,
            _formatCount(profile.followersCount),
            'Followers',
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.followers,
              arguments: {
                'userId': profile.id,
                'userName': profile.displayName,
              },
            ),
          ),
          _buildDivider(),
           _buildCell(
            context,
            _formatCount(profile.bookmarkCount),
            'Bookmarks',
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.bookmarkedPeers,
              arguments: {
                'userId': profile.id,
                'userName': profile.displayName,
              },
            ),
          ),
          _buildDivider(),
          _buildCell(
            context,
            _formatCount(profile.coinsBalance),
            'Coins',
            onTap: () => Navigator.pushNamed(context, AppRoutes.coins),
          ),
        ]),
        const SizedBox(height: 8),
        _buildStatsCard([
          _buildCell(
            context,
            _formatCount(profile.badgesCount),
            'Badges',
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.badges,
              arguments: profile.id,
            ),
          ),
          _buildDivider(),
          _buildCell(
            context,
            _formatCount(profile.p2pMeetingsCount),
            'P2P',
            onTap: () => Navigator.pushNamed(context, AppRoutes.p2pMeetings),
          ),
          _buildDivider(),
          _buildCell(
            context,
            _formatCount(profile.referralsCount),
            'Referrals',
            onTap: () => Navigator.pushNamed(context, AppRoutes.referrals),
          ),
          _buildDivider(),
          _buildCell(
            context,
            _formatCount(profile.businessDealsCount),
            'Deals',
            onTap: () => Navigator.pushNamed(context, AppRoutes.businessDeals),
          ),
          _buildDivider(),
          _buildCell(
            context,
            _formatCount(profile.testimonialsCount),
            'Testimonials',
            onTap: () => Navigator.pushNamed(context, AppRoutes.testimonials),
          ),
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

  Widget _buildCell(
    BuildContext context,
    String count,
    String label, {
    VoidCallback? onTap,
  }) {
    final cellContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            count,
            maxLines: 1,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: AppColor.lightTextPrimary,
            ),
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
    );

    return Expanded(
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: cellContent,
              ),
            )
          : cellContent,
    );
  }

  Widget _buildDivider() {
    return Container(height: 18, width: 1, color: AppColor.lightBorder);
  }
}
