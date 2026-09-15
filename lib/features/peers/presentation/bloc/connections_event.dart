import 'package:equatable/equatable.dart';
import '../../domain/entities/peer_entity.dart';

abstract class ConnectionsEvent extends Equatable {
  const ConnectionsEvent();

  @override
  List<Object?> get props => [];
}

class ConnectionsFetchRequested extends ConnectionsEvent {
  const ConnectionsFetchRequested();
}

class ConnectionsRefreshRequested extends ConnectionsEvent {
  const ConnectionsRefreshRequested();
}

class ConnectionsLoadMoreRequested extends ConnectionsEvent {
  const ConnectionsLoadMoreRequested();
}

class ConnectionsSearchChanged extends ConnectionsEvent {
  final String query;
  const ConnectionsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class ConnectionBookmarkToggled extends ConnectionsEvent {
  final String peerId;
  final bool isCurrentlyBookmarked;

  const ConnectionBookmarkToggled({
    required this.peerId,
    required this.isCurrentlyBookmarked,
  });

  @override
  List<Object?> get props => [peerId, isCurrentlyBookmarked];
}

class ConnectionFollowToggled extends ConnectionsEvent {
  final String peerId;
  final bool isCurrentlyFollowing;

  const ConnectionFollowToggled({
    required this.peerId,
    required this.isCurrentlyFollowing,
  });

  @override
  List<Object?> get props => [peerId, isCurrentlyFollowing];
}

class ConnectionAdded extends ConnectionsEvent {
  final PeerEntity peer;
  const ConnectionAdded(this.peer);

  @override
  List<Object?> get props => [peer];
}

class ConnectionPeerFollowUpdated extends ConnectionsEvent {
  final String peerId;
  final bool isFollowing;

  const ConnectionPeerFollowUpdated({
    required this.peerId,
    required this.isFollowing,
  });

  @override
  List<Object?> get props => [peerId, isFollowing];
}

class ConnectionPeerBookmarkUpdated extends ConnectionsEvent {
  final String peerId;
  final bool isBookmarked;

  const ConnectionPeerBookmarkUpdated({
    required this.peerId,
    required this.isBookmarked,
  });

  @override
  List<Object?> get props => [peerId, isBookmarked];
}

