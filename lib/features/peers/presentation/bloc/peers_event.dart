import 'package:equatable/equatable.dart';

abstract class PeersEvent extends Equatable {
  const PeersEvent();

  @override
  List<Object?> get props => [];
}

class PeersFetchRequested extends PeersEvent {
  const PeersFetchRequested();
}

class PeersRefreshRequested extends PeersEvent {
  const PeersRefreshRequested();
}

class PeersLoadMoreRequested extends PeersEvent {
  const PeersLoadMoreRequested();
}

class PeersSearchChanged extends PeersEvent {
  final String query;
  const PeersSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class PeersSortChanged extends PeersEvent {
  final String sort;
  const PeersSortChanged(this.sort);

  @override
  List<Object?> get props => [sort];
}

class PeerConnectRequested extends PeersEvent {
  final String peerId;
  const PeerConnectRequested(this.peerId);

  @override
  List<Object?> get props => [peerId];
}

class PeerBookmarkToggled extends PeersEvent {
  final String peerId;
  final bool isCurrentlyBookmarked;

  const PeerBookmarkToggled({
    required this.peerId,
    required this.isCurrentlyBookmarked,
  });

  @override
  List<Object?> get props => [peerId, isCurrentlyBookmarked];
}

class PeerFollowToggled extends PeersEvent {
  final String peerId;
  final bool isCurrentlyFollowing;

  const PeerFollowToggled({
    required this.peerId,
    required this.isCurrentlyFollowing,
  });

  @override
  List<Object?> get props => [peerId, isCurrentlyFollowing];
}

class PeerStatusUpdated extends PeersEvent {
  final String peerId;
  final String status;

  const PeerStatusUpdated({required this.peerId, required this.status});

  @override
  List<Object?> get props => [peerId, status];
}

class PeerFollowStatusSynced extends PeersEvent {
  final String peerId;
  final bool isFollowing;

  const PeerFollowStatusSynced({required this.peerId, required this.isFollowing});

  @override
  List<Object?> get props => [peerId, isFollowing];
}

class PeerBookmarkStatusSynced extends PeersEvent {
  final String peerId;
  final bool isBookmarked;

  const PeerBookmarkStatusSynced({required this.peerId, required this.isBookmarked});

  @override
  List<Object?> get props => [peerId, isBookmarked];
}
