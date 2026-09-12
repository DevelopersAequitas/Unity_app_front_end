import 'package:flutter/material.dart';
import '../../domain/entities/peer_entity.dart';
import 'peer_card.dart';

class ConnectedPeerCard extends StatelessWidget {
  final PeerEntity peer;
  final VoidCallback onScheduleP2P;
  final VoidCallback onMessage;
  final VoidCallback onBookmark;
  final VoidCallback? onTap;

  const ConnectedPeerCard({
    super.key,
    required this.peer,
    required this.onScheduleP2P,
    required this.onMessage,
    required this.onBookmark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PeerCard(
      peer: peer.copyWith(connectionStatus: 'connected'),
      onScheduleP2P: onScheduleP2P,
      onMessage: onMessage,
      onBookmark: onBookmark,
      onTap: onTap,
    );
  }
}
