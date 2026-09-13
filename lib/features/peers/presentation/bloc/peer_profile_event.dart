import 'package:equatable/equatable.dart';

abstract class PeerProfileEvent extends Equatable {
  const PeerProfileEvent();

  @override
  List<Object?> get props => [];
}

class PeerProfileFetchRequested extends PeerProfileEvent {
  final String peerId;

  const PeerProfileFetchRequested(this.peerId);

  @override
  List<Object?> get props => [peerId];
}

class PeerProfileFollowToggled extends PeerProfileEvent {
  const PeerProfileFollowToggled();
}

class PeerProfileConnectRequested extends PeerProfileEvent {
  const PeerProfileConnectRequested();
}

class PeerProfileCancelRequestRequested extends PeerProfileEvent {
  const PeerProfileCancelRequestRequested();
}

class PeerProfileRemoveConnectionRequested extends PeerProfileEvent {
  const PeerProfileRemoveConnectionRequested();
}

class PeerProfileBookmarkToggled extends PeerProfileEvent {
  const PeerProfileBookmarkToggled();
}

class PeerProfilePostsLoadMoreRequested extends PeerProfileEvent {
  const PeerProfilePostsLoadMoreRequested();
}

class PeerProfilePostLikeToggled extends PeerProfileEvent {
  final String postId;
  const PeerProfilePostLikeToggled(this.postId);

  @override
  List<Object?> get props => [postId];
}

class PeerProfilePostSaveToggled extends PeerProfileEvent {
  final String postId;
  const PeerProfilePostSaveToggled(this.postId);

  @override
  List<Object?> get props => [postId];
}

class PeerProfilePostCommentCountIncremented extends PeerProfileEvent {
  final String postId;
  const PeerProfilePostCommentCountIncremented(this.postId);

  @override
  List<Object?> get props => [postId];
}
