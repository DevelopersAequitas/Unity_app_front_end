import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../peers/presentation/bloc/peers_bloc.dart';
import '../../../peers/presentation/bloc/peers_event.dart';
import '../../../peers/presentation/widgets/peer_card.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/introduced_peer_entity.dart';

class IntroducedPeerTile extends StatelessWidget {
  final IntroducedPeerEntity peer;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const IntroducedPeerTile({
    super.key,
    required this.peer,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.watch<ProfileBloc>().state.profile?.id ?? context.watch<AuthBloc>().state.user?.id;
    final isCurrentUser = currentUserId != null && currentUserId == peer.id;
    final peerEntity = peer.toPeerEntity();

    return PeerCard(
      key: ValueKey('${peer.id}_${peer.isFollowing}_${peer.isBookmarked}_${peer.connectionStatus}'),
      peer: peerEntity,
      margin: margin,
      padding: padding,
      isCurrentUser: isCurrentUser,
      onConnect: isCurrentUser
          ? null
          : () {
              context.read<PeersBloc>().add(PeerConnectRequested(peer.id));
            },
      onFollow: isCurrentUser
          ? null
          : () => context.read<PeersBloc>().add(
                PeerFollowToggled(
                  peerId: peer.id,
                  isCurrentlyFollowing: peer.isFollowing,
                ),
              ),
      onScheduleP2P: null,
      onMessage: isCurrentUser ? () {} : null,
      onTap: () => Navigator.pushNamed(
        context,
        isCurrentUser ? AppRoutes.profile : AppRoutes.peerProfile,
        arguments: peer.id,
      ),
      onBookmark: isCurrentUser
          ? () {}
          : () => context.read<PeersBloc>().add(
                PeerBookmarkToggled(
                  peerId: peer.id,
                  isCurrentlyBookmarked: peer.isBookmarked,
                ),
              ),
    );
  }
}
