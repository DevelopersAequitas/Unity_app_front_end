import 'package:equatable/equatable.dart';

abstract class ProfilePostsEvent extends Equatable {
  const ProfilePostsEvent();

  @override
  List<Object?> get props => [];
}

class ProfilePostsFetchRequested extends ProfilePostsEvent {
  const ProfilePostsFetchRequested();
}

class ProfilePostsRefreshRequested extends ProfilePostsEvent {
  const ProfilePostsRefreshRequested();
}

class ProfilePostsLoadMoreRequested extends ProfilePostsEvent {
  const ProfilePostsLoadMoreRequested();
}

class ProfilePostLikeToggled extends ProfilePostsEvent {
  final String postId;

  const ProfilePostLikeToggled(this.postId);

  @override
  List<Object?> get props => [postId];
}

class ProfilePostSaveToggled extends ProfilePostsEvent {
  final String postId;

  const ProfilePostSaveToggled(this.postId);

  @override
  List<Object?> get props => [postId];
}

class ProfilePostCommentCountIncremented extends ProfilePostsEvent {
  final String postId;

  const ProfilePostCommentCountIncremented(this.postId);

  @override
  List<Object?> get props => [postId];
}

class ProfilePostDeleted extends ProfilePostsEvent {
  final String postId;
  const ProfilePostDeleted(this.postId);

  @override
  List<Object?> get props => [postId];
}

class ProfilePostEdited extends ProfilePostsEvent {
  final String postId;
  final String contentText;
  const ProfilePostEdited({required this.postId, required this.contentText});

  @override
  List<Object?> get props => [postId, contentText];
}

class ProfilePostLikeSyncRequested extends ProfilePostsEvent {
  final String postId;
  final bool isLiked;
  final int likesCount;

  const ProfilePostLikeSyncRequested({
    required this.postId,
    required this.isLiked,
    required this.likesCount,
  });

  @override
  List<Object?> get props => [postId, isLiked, likesCount];
}

class ProfilePostSaveSyncRequested extends ProfilePostsEvent {
  final String postId;
  final bool isSaved;

  const ProfilePostSaveSyncRequested({
    required this.postId,
    required this.isSaved,
  });

  @override
  List<Object?> get props => [postId, isSaved];
}
