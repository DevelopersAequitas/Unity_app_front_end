import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../peers/presentation/bloc/peers_bloc.dart';
import '../../../peers/presentation/bloc/peers_event.dart';
import '../../../peers/presentation/widgets/peer_card.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/introduced_peer_entity.dart';

class IntroducedPeerTile extends StatelessWidget {
  final IntroducedPeerEntity peer;
  const IntroducedPeerTile({super.key, required this.peer});

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.watch<ProfileBloc>().state.profile?.id ?? context.watch<AuthBloc>().state.user?.id;
    final isCurrentUser = currentUserId != null && currentUserId == peer.id;
    final peerEntity = peer.toPeerEntity();

    return PeerCard(
      key: ValueKey(peer.id),
      peer: peerEntity,
      isCurrentUser: isCurrentUser,
      onConnect: isCurrentUser
          ? null
          : () {
              context.read<PeersBloc>().add(PeerConnectRequested(peer.id));
              AppSnackBar.showSuccess(context, 'Connection request sent to ${peer.name}');
            },
      onFollow: isCurrentUser
          ? null
          : () => context.read<PeersBloc>().add(
                PeerFollowToggled(peerId: peer.id, isCurrentlyFollowing: peer.isFollowing),
              ),
      onScheduleP2P: (!isCurrentUser && peerEntity.isConnected)
          ? () => AppSnackBar.showInfo(context, 'Scheduling P2P with ${peer.name}')
          : null,
      onMessage: isCurrentUser ? () {} : () => AppSnackBar.showInfo(context, 'Messaging ${peer.name}'),
      onTap: () => Navigator.pushNamed(
        context,
        isCurrentUser ? AppRoutes.profile : AppRoutes.peerProfile,
        arguments: peer.id,
      ),
      onBookmark: isCurrentUser
          ? () {}
          : () => context.read<PeersBloc>().add(
                PeerBookmarkToggled(peerId: peer.id, isCurrentlyBookmarked: peer.isBookmarked),
              ),
    );
  }
}
