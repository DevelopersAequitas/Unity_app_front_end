import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeFeedFetchRequested extends HomeEvent {
  final String? filter;
  const HomeFeedFetchRequested({this.filter});

  @override
  List<Object?> get props => [filter];
}

class HomeFeedRefreshRequested extends HomeEvent {
  const HomeFeedRefreshRequested();
}

class HomeFeedLoadMoreRequested extends HomeEvent {
  const HomeFeedLoadMoreRequested();
}

class HomeBrandPartnersFetchRequested extends HomeEvent {
  const HomeBrandPartnersFetchRequested();
}

class HomePostLikeToggled extends HomeEvent {
  final String postId;
  final bool isCurrentlyLiked;

  const HomePostLikeToggled({
    required this.postId,
    required this.isCurrentlyLiked,
  });

  @override
  List<Object?> get props => [postId, isCurrentlyLiked];
}

class HomePostSaveToggled extends HomeEvent {
  final String postId;
  final bool isCurrentlySaved;

  const HomePostSaveToggled({
    required this.postId,
    required this.isCurrentlySaved,
  });

  @override
  List<Object?> get props => [postId, isCurrentlySaved];
}

class HomeFilterChanged extends HomeEvent {
  final String filter;
  const HomeFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class HomeSearchChanged extends HomeEvent {
  final String query;
  const HomeSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class HomePostCommentCountIncremented extends HomeEvent {
  final String postId;
  const HomePostCommentCountIncremented(this.postId);

  @override
  List<Object?> get props => [postId];
}

class HomePostDeleted extends HomeEvent {
  final String postId;
  const HomePostDeleted(this.postId);

  @override
  List<Object?> get props => [postId];
}

class HomePostEdited extends HomeEvent {
  final String postId;
  final String contentText;
  const HomePostEdited({required this.postId, required this.contentText});

  @override
  List<Object?> get props => [postId, contentText];
}

class HomePostLikeSyncRequested extends HomeEvent {
  final String postId;
  final bool isLiked;
  final int likesCount;

  const HomePostLikeSyncRequested({
    required this.postId,
    required this.isLiked,
    required this.likesCount,
  });

  @override
  List<Object?> get props => [postId, isLiked, likesCount];
}

class HomePostSaveSyncRequested extends HomeEvent {
  final String postId;
  final bool isSaved;

  const HomePostSaveSyncRequested({
    required this.postId,
    required this.isSaved,
  });

  @override
  List<Object?> get props => [postId, isSaved];
}
