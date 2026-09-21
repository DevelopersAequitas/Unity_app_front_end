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
import '../../domain/entities/business_deal_leaderboard_entity.dart';

class BusinessDealLeaderboardTile extends StatelessWidget {
  final BusinessDealLeaderboardEntity item;
  const BusinessDealLeaderboardTile({super.key, required this.item});

  Color _getRankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return AppColor.primaryBlue;
  }

  String _formatAmount(num amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    }
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))'),
          (m) => '${m[1]},',
        );
    return '₹$formatted';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUserId = context.watch<ProfileBloc>().state.profile?.id ??
        context.watch<AuthBloc>().state.user?.id;
    final isCurrentUser = currentUserId != null && currentUserId == item.id;
    final peerEntity = item.toPeerEntity();
    final rankColor = _getRankColor(item.rank);

    final dealsLabel = '${item.dealsCount} ${item.dealsCount == 1 ? 'Deal' : 'Deals'}';
    final amountLabel = item.totalAmount > 0 ? ' • ${_formatAmount(item.totalAmount)}' : '';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      item.rank <= 3 ? Icons.emoji_events_rounded : Icons.workspace_premium_rounded,
                      size: 15,
                      color: rankColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Rank #${item.rank}',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$dealsLabel$amountLabel',
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.primaryBlue,
                  ),
                ),
              ],
            ),
          ),
          PeerCard(
            key: ValueKey(item.id),
            peer: peerEntity,
            isCurrentUser: isCurrentUser,
            margin: EdgeInsets.zero,
            showBorder: false,
            onConnect: isCurrentUser ? null : () {
              context.read<PeersBloc>().add(PeerConnectRequested(item.id));
              AppSnackBar.showSuccess(context, 'Connection request sent to ${item.displayName}');
            },
            onFollow: isCurrentUser ? null : () => context.read<PeersBloc>().add(
              PeerFollowToggled(peerId: item.id, isCurrentlyFollowing: item.isFollowing),
            ),
            onScheduleP2P: (!isCurrentUser && peerEntity.isConnected)
                ? () => AppSnackBar.showInfo(context, 'Scheduling P2P with ${item.displayName}')
                : null,
            onMessage: isCurrentUser ? () {} : () => AppSnackBar.showInfo(context, 'Messaging ${item.displayName}'),
            onTap: () => Navigator.pushNamed(
              context,
              isCurrentUser ? AppRoutes.profile : AppRoutes.peerProfile,
              arguments: item.id,
            ),
            onBookmark: isCurrentUser ? () {} : () => context.read<PeersBloc>().add(
              PeerBookmarkToggled(peerId: item.id, isCurrentlyBookmarked: item.isBookmark),
            ),
          ),
        ],
      ),
    );
  }
}
