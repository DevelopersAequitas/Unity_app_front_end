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
