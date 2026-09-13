import 'package:equatable/equatable.dart';

abstract class ProfileSavedPostsEvent extends Equatable {
  const ProfileSavedPostsEvent();

  @override
  List<Object?> get props => [];
}

class ProfileSavedPostsFetchRequested extends ProfileSavedPostsEvent {
  const ProfileSavedPostsFetchRequested();
}

class ProfileSavedPostsRefreshRequested extends ProfileSavedPostsEvent {
  const ProfileSavedPostsRefreshRequested();
}

class ProfileSavedPostsLoadMoreRequested extends ProfileSavedPostsEvent {
  const ProfileSavedPostsLoadMoreRequested();
}

class ProfileSavedPostLikeToggled extends ProfileSavedPostsEvent {
  final String postId;

  const ProfileSavedPostLikeToggled(this.postId);

  @override
  List<Object?> get props => [postId];
}

class ProfileSavedPostSaveToggled extends ProfileSavedPostsEvent {
  final String postId;

  const ProfileSavedPostSaveToggled(this.postId);

  @override
  List<Object?> get props => [postId];
}

class ProfileSavedPostCommentCountIncremented extends ProfileSavedPostsEvent {
  final String postId;

  const ProfileSavedPostCommentCountIncremented(this.postId);

  @override
  List<Object?> get props => [postId];
}

class ProfileSavedPostLikeSyncRequested extends ProfileSavedPostsEvent {
  final String postId;
  final bool isLiked;
  final int likesCount;

  const ProfileSavedPostLikeSyncRequested({
    required this.postId,
    required this.isLiked,
    required this.likesCount,
  });

  @override
  List<Object?> get props => [postId, isLiked, likesCount];
}

class ProfileSavedPostSaveSyncRequested extends ProfileSavedPostsEvent {
  final String postId;
  final bool isSaved;

  const ProfileSavedPostSaveSyncRequested({
    required this.postId,
    required this.isSaved,
  });

  @override
  List<Object?> get props => [postId, isSaved];
}
