import 'package:equatable/equatable.dart';

abstract class ShortsEvent extends Equatable {
  const ShortsEvent();

  @override
  List<Object?> get props => [];
}

class FetchIntroVideosEvent extends ShortsEvent {
  final bool isRefresh;

  const FetchIntroVideosEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class ShortsPageChangedEvent extends ShortsEvent {
  final int index;

  const ShortsPageChangedEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class ToggleShortLikeEvent extends ShortsEvent {
  final String videoId;

  const ToggleShortLikeEvent(this.videoId);

  @override
  List<Object?> get props => [videoId];
}

class ToggleShortBookmarkEvent extends ShortsEvent {
  final String memberId;

  const ToggleShortBookmarkEvent(this.memberId);

  @override
  List<Object?> get props => [memberId];
}

class ToggleShortFollowEvent extends ShortsEvent {
  final String memberId;

  const ToggleShortFollowEvent(this.memberId);

  @override
  List<Object?> get props => [memberId];
}
