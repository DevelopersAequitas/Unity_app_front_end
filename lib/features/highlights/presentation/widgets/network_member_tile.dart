import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../peers/presentation/bloc/peers_bloc.dart';
import '../../../peers/presentation/bloc/peers_event.dart';
import '../../../peers/presentation/widgets/peer_card.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/network_member_entity.dart';

class NetworkMemberTile extends StatelessWidget {
  final NetworkMemberEntity member;
  const NetworkMemberTile({super.key, required this.member});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  String _formatJoinDate(String rawDate) {
    if (rawDate.isEmpty) return '';
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      final day = dt.day.toString().padLeft(2, '0');
      final month = _months[dt.month - 1];
      final year = dt.year;
      return 'Joined $day $month $year';
    } catch (_) {
      return 'Joined $rawDate';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUserId = context.watch<ProfileBloc>().state.profile?.id ?? context.watch<AuthBloc>().state.user?.id;
    final isCurrentUser = currentUserId != null && currentUserId == member.id;
    final peerEntity = member.toPeerEntity();
    final joinDateText = _formatJoinDate(member.joinedDate);
    final hasReferralMeta = joinDateText.isNotEmpty || member.referralType.isNotEmpty || member.referralTitle.isNotEmpty || member.coinsEarned > 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 3.5),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasReferralMeta)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColor.primaryBlue.withValues(alpha: 0.06),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 13, color: AppColor.primaryBlue),
                      const SizedBox(width: 5),
                      Text(
                        joinDateText.isNotEmpty
                            ? joinDateText
                            : (member.referralTitle.isNotEmpty
                                ? member.referralTitle
                                : (member.referralType.isNotEmpty
                                    ? member.referralType.replaceAll('_', ' ').toUpperCase()
                                    : 'REFERRAL')),
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                          color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: member.coinsEarned > 0
                          ? const Color(0xFFF59E0B).withValues(alpha: 0.14)
                          : AppColor.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (member.coinsEarned > 0) ...[
                          Image.asset('assets/images/coin.png', width: 11, height: 11),
                          const SizedBox(width: 3),
                        ],
                        Text(
                          member.coinsEarned > 0
                              ? '+${member.coinsEarned} Coins'
                              : member.status.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: member.coinsEarned > 0
                                ? const Color(0xFFD97706)
                                : AppColor.success,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          PeerCard(
            key: ValueKey('${member.id}_${member.isFollowing}_${member.isBookmarked}_${member.connectionStatus}'),
            peer: peerEntity,
            isCurrentUser: isCurrentUser,
            margin: EdgeInsets.zero,
            showBorder: false,
            onConnect: isCurrentUser
                ? null
                : () {
                    context.read<PeersBloc>().add(PeerConnectRequested(member.id));
                  },
            onFollow: isCurrentUser
                ? null
                : () => context.read<PeersBloc>().add(
                      PeerFollowToggled(
                        peerId: member.id,
                        isCurrentlyFollowing: member.isFollowing,
                      ),
                    ),
            onScheduleP2P: null,
            onMessage: isCurrentUser ? () {} : null,
            onTap: () => Navigator.pushNamed(
              context,
              isCurrentUser ? AppRoutes.profile : AppRoutes.peerProfile,
              arguments: member.id,
            ),
            onBookmark: isCurrentUser
                ? () {}
                : () => context.read<PeersBloc>().add(
                      PeerBookmarkToggled(
                        peerId: member.id,
                        isCurrentlyBookmarked: member.isBookmarked,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}

