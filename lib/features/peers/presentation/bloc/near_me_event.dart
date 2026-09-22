import 'package:equatable/equatable.dart';

abstract class NearMeEvent extends Equatable {
  const NearMeEvent();

  @override
  List<Object?> get props => [];
}

class NearMeFetchRequested extends NearMeEvent {
  final bool refresh;
  const NearMeFetchRequested({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class NearMeLoadMoreRequested extends NearMeEvent {
  const NearMeLoadMoreRequested();
}

class NearMeRadiusChanged extends NearMeEvent {
  final double? radiusKm;
  const NearMeRadiusChanged(this.radiusKm);

  @override
  List<Object?> get props => [radiusKm];
}

class NearMeLocationUpdated extends NearMeEvent {
  final double latitude;
  final double longitude;
  const NearMeLocationUpdated({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}

class NearMeFollowToggled extends NearMeEvent {
  final String peerId;
  final bool isCurrentlyFollowing;

  const NearMeFollowToggled({
    required this.peerId,
    required this.isCurrentlyFollowing,
  });

  @override
  List<Object?> get props => [peerId, isCurrentlyFollowing];
}

class NearMeConnectRequested extends NearMeEvent {
  final String peerId;

  const NearMeConnectRequested(this.peerId);

  @override
  List<Object?> get props => [peerId];
}

class NearMeBookmarkToggled extends NearMeEvent {
  final String peerId;
  final bool isCurrentlyBookmarked;

  const NearMeBookmarkToggled({
    required this.peerId,
    required this.isCurrentlyBookmarked,
  });

  @override
  List<Object?> get props => [peerId, isCurrentlyBookmarked];
}

class NearMeStatusUpdated extends NearMeEvent {
  final String peerId;
  final String status;

  const NearMeStatusUpdated({required this.peerId, required this.status});

  @override
  List<Object?> get props => [peerId, status];
}

class NearMePeerFollowUpdated extends NearMeEvent {
  final String peerId;
  final bool isFollowing;

  const NearMePeerFollowUpdated({required this.peerId, required this.isFollowing});

  @override
  List<Object?> get props => [peerId, isFollowing];
}

class NearMePeerBookmarkUpdated extends NearMeEvent {
  final String peerId;
  final bool isBookmarked;

  const NearMePeerBookmarkUpdated({required this.peerId, required this.isBookmarked});

  @override
  List<Object?> get props => [peerId, isBookmarked];
}

