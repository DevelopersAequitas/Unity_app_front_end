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
