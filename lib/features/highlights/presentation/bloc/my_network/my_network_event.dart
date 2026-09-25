import 'package:equatable/equatable.dart';

abstract class MyNetworkEvent extends Equatable {
  const MyNetworkEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyNetworkDataEvent extends MyNetworkEvent {
  final bool isRefresh;
  const FetchMyNetworkDataEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class GenerateInviteCodeEvent extends MyNetworkEvent {
  const GenerateInviteCodeEvent();
}

class MyNetworkFollowStatusSynced extends MyNetworkEvent {
  final String peerId;
  final bool isFollowing;

  const MyNetworkFollowStatusSynced({
    required this.peerId,
    required this.isFollowing,
  });

  @override
  List<Object?> get props => [peerId, isFollowing];
}

class MyNetworkBookmarkStatusSynced extends MyNetworkEvent {
  final String peerId;
  final bool isBookmarked;

  const MyNetworkBookmarkStatusSynced({
    required this.peerId,
    required this.isBookmarked,
  });

  @override
  List<Object?> get props => [peerId, isBookmarked];
}

class MyNetworkConnectionStatusSynced extends MyNetworkEvent {
  final String peerId;
  final String connectionStatus;
  final bool isConnected;

  const MyNetworkConnectionStatusSynced({
    required this.peerId,
    required this.connectionStatus,
    required this.isConnected,
  });

  @override
  List<Object?> get props => [peerId, connectionStatus, isConnected];
}
