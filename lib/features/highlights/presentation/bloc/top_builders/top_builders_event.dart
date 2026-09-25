import 'package:equatable/equatable.dart';

abstract class TopBuildersEvent extends Equatable {
  const TopBuildersEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopBuildersDataEvent extends TopBuildersEvent {
  final bool isRefresh;
  const FetchTopBuildersDataEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class SearchIntroducedPeersEvent extends TopBuildersEvent {
  final String query;
  const SearchIntroducedPeersEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

class TopBuildersFollowStatusSynced extends TopBuildersEvent {
  final String peerId;
  final bool isFollowing;

  const TopBuildersFollowStatusSynced({
    required this.peerId,
    required this.isFollowing,
  });

  @override
  List<Object?> get props => [peerId, isFollowing];
}

class TopBuildersBookmarkStatusSynced extends TopBuildersEvent {
  final String peerId;
  final bool isBookmarked;

  const TopBuildersBookmarkStatusSynced({
    required this.peerId,
    required this.isBookmarked,
  });

  @override
  List<Object?> get props => [peerId, isBookmarked];
}

class TopBuildersConnectionStatusSynced extends TopBuildersEvent {
  final String peerId;
  final String connectionStatus;
  final bool isConnected;

  const TopBuildersConnectionStatusSynced({
    required this.peerId,
    required this.connectionStatus,
    required this.isConnected,
  });

  @override
  List<Object?> get props => [peerId, connectionStatus, isConnected];
}
