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
import '../../domain/entities/top_builder_entity.dart';

class TopBuilderTile extends StatelessWidget {
  final TopBuilderEntity builder;
  const TopBuilderTile({super.key, required this.builder});

  Color _getRankColor(int rank) {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return AppColor.primaryBlue;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUserId = context.watch<ProfileBloc>().state.profile?.id ?? context.watch<AuthBloc>().state.user?.id;
    final isCurrentUser = currentUserId != null && currentUserId == builder.id;
    final peerEntity = builder.toPeerEntity();
    final rankColor = _getRankColor(builder.rank);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder, width: 0.8),
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
                      builder.rank <= 3 ? Icons.emoji_events_rounded : Icons.workspace_premium_rounded,
                      size: 15,
                      color: rankColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Rank #${builder.rank}',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${builder.introducedCount} ${builder.introducedCount == 1 ? 'Peer' : 'Peers'} Introduced',
                  style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w500, color: AppColor.primaryBlue),
                ),
              ],
            ),
          ),
          PeerCard(
            key: ValueKey(builder.id),
            peer: peerEntity,
            isCurrentUser: isCurrentUser,
            margin: EdgeInsets.zero,
            showBorder: false,
            onConnect: isCurrentUser ? null : () {
              context.read<PeersBloc>().add(PeerConnectRequested(builder.id));
              AppSnackBar.showSuccess(context, 'Connection request sent to ${builder.name}');
            },
            onFollow: isCurrentUser ? null : () => context.read<PeersBloc>().add(
              PeerFollowToggled(peerId: builder.id, isCurrentlyFollowing: builder.isFollowing),
            ),
            onScheduleP2P: (!isCurrentUser && peerEntity.isConnected)
                ? () => AppSnackBar.showInfo(context, 'Scheduling P2P with ${builder.name}')
                : null,
            onMessage: isCurrentUser ? () {} : () => AppSnackBar.showInfo(context, 'Messaging ${builder.name}'),
            onTap: () => Navigator.pushNamed(
              context,
              isCurrentUser ? AppRoutes.profile : AppRoutes.peerProfile,
              arguments: builder.id,
            ),
            onBookmark: isCurrentUser ? () {} : () => context.read<PeersBloc>().add(
              PeerBookmarkToggled(peerId: builder.id, isCurrentlyBookmarked: builder.isBookmarked),
            ),
          ),
        ],
      ),
    );
  }
}
