import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../peers/presentation/bloc/peers_bloc.dart';
import '../../../peers/presentation/bloc/peers_event.dart';
import '../../../peers/presentation/widgets/peer_card.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/network_member_entity.dart';

class NetworkMemberTile extends StatelessWidget {
  final NetworkMemberEntity member;
  const NetworkMemberTile({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUserId = context.watch<ProfileBloc>().state.profile?.id ?? context.watch<AuthBloc>().state.user?.id;
    final isCurrentUser = currentUserId != null && currentUserId == member.id;
    final peerEntity = member.toPeerEntity();
    final hasReferralMeta = member.referralType.isNotEmpty || member.referralTitle.isNotEmpty || member.coinsEarned > 0;

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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.primaryBlue.withValues(alpha: 0.06),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 12, color: AppColor.primaryBlue),
                      const SizedBox(width: 4),
                      Text(
                        member.referralTitle.isNotEmpty ? member.referralTitle : (member.referralType.isNotEmpty ? member.referralType.replaceAll('_', ' ').toUpperCase() : 'REFERRAL'),
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 10.5,
                          color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: AppColor.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      member.coinsEarned > 0 ? '+${member.coinsEarned} Coins' : member.status,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColor.success,
                        fontWeight: FontWeight.w500,
                        fontSize: 9.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          PeerCard(
            key: ValueKey(member.id),
            peer: peerEntity,
            isCurrentUser: isCurrentUser,
            margin: EdgeInsets.zero,
            showBorder: false,
            onConnect: isCurrentUser ? null : () {
              context.read<PeersBloc>().add(PeerConnectRequested(member.id));
              AppSnackBar.showSuccess(context, 'Connection request sent to ${member.name}');
            },
            onFollow: isCurrentUser ? null : () => context.read<PeersBloc>().add(
              PeerFollowToggled(peerId: member.id, isCurrentlyFollowing: member.isFollowing),
            ),
            onScheduleP2P: (!isCurrentUser && peerEntity.isConnected)
                ? () => AppSnackBar.showInfo(context, 'Scheduling P2P with ${member.name}')
                : null,
            onMessage: isCurrentUser ? () {} : () => AppSnackBar.showInfo(context, 'Messaging ${member.name}'),
            onTap: () => Navigator.pushNamed(
              context,
              isCurrentUser ? AppRoutes.profile : AppRoutes.peerProfile,
              arguments: member.id,
            ),
            onBookmark: isCurrentUser ? () {} : () => context.read<PeersBloc>().add(
              PeerBookmarkToggled(peerId: member.id, isCurrentlyBookmarked: member.isBookmarked),
            ),
          ),
        ],
      ),
    );
  }
}

