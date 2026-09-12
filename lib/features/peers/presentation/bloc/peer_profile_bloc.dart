import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../domain/usecases/cancel_sent_connection_request_usecase.dart';
import '../../domain/usecases/follow_user_usecase.dart';
import '../../domain/usecases/get_member_posts_usecase.dart';
import '../../domain/usecases/get_member_profile_usecase.dart';
import '../../domain/usecases/remove_connection_usecase.dart';
import '../../domain/usecases/send_connection_request_usecase.dart';
import '../../domain/usecases/toggle_peer_bookmark_usecase.dart';
import '../../domain/usecases/unfollow_user_usecase.dart';
import 'peer_profile_event.dart';
import 'peer_profile_state.dart';

class PeerProfileBloc extends Bloc<PeerProfileEvent, PeerProfileState> {
  final GetMemberProfileUseCase getMemberProfileUseCase;
  final GetMemberPostsUseCase getMemberPostsUseCase;
  final FollowUserUseCase followUserUseCase;
  final UnfollowUserUseCase unfollowUserUseCase;
  final SendConnectionRequestUseCase sendConnectionRequestUseCase;
  final RemoveConnectionUseCase removeConnectionUseCase;
  final CancelSentConnectionRequestUseCase cancelSentConnectionRequestUseCase;
  final TogglePeerBookmarkUseCase togglePeerBookmarkUseCase;

  PeerProfileBloc({
    required this.getMemberProfileUseCase,
    required this.getMemberPostsUseCase,
    required this.followUserUseCase,
    required this.unfollowUserUseCase,
    required this.sendConnectionRequestUseCase,
    required this.removeConnectionUseCase,
    required this.cancelSentConnectionRequestUseCase,
    required this.togglePeerBookmarkUseCase,
  }) : super(const PeerProfileState()) {
    on<PeerProfileFetchRequested>(_onFetch);
    on<PeerProfileFollowToggled>(_onFollowToggle);
    on<PeerProfileConnectRequested>(_onConnect);
    on<PeerProfileCancelRequestRequested>(_onCancelRequest);
    on<PeerProfileRemoveConnectionRequested>(_onRemoveConnection);
    on<PeerProfileBookmarkToggled>(_onBookmarkToggle);
    on<PeerProfilePostsLoadMoreRequested>(_onLoadMorePosts);
    on<PeerProfilePostLikeToggled>(_onPostLikeToggled);
    on<PeerProfilePostSaveToggled>(_onPostSaveToggled);
  }

  Future<void> _onFetch(
    PeerProfileFetchRequested event,
    Emitter<PeerProfileState> emit,
  ) async {
    emit(state.copyWith(status: PeerProfileStatus.loading));
    try {
      final profile = await getMemberProfileUseCase(event.peerId);
      emit(state.copyWith(
        status: PeerProfileStatus.success,
        profile: profile,
        isPostsLoading: true,
      ));

      try {
        final targetId = (profile.userId != null && profile.userId!.isNotEmpty)
            ? profile.userId!
            : (profile.id.isNotEmpty ? profile.id : event.peerId);

        var posts = await getMemberPostsUseCase(targetId);
        if (posts.isEmpty && profile.id.isNotEmpty && profile.id != targetId) {
          posts = await getMemberPostsUseCase(profile.id);
        }
        if (posts.isEmpty && event.peerId.isNotEmpty && event.peerId != targetId && event.peerId != profile.id) {
          posts = await getMemberPostsUseCase(event.peerId);
        }

        emit(state.copyWith(
          posts: posts,
          postsPage: 1,
          hasMorePosts: posts.length >= 10,
          isPostsLoading: false,
        ));
      } catch (_) {
        emit(state.copyWith(isPostsLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        status: PeerProfileStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMorePosts(
    PeerProfilePostsLoadMoreRequested event,
    Emitter<PeerProfileState> emit,
  ) async {
    final profile = state.profile;
    if (profile == null || state.isLoadingMorePosts || !state.hasMorePosts) return;

    emit(state.copyWith(isLoadingMorePosts: true));
    try {
      final targetId = (profile.userId != null && profile.userId!.isNotEmpty)
          ? profile.userId!
          : profile.id;
      final nextPage = state.postsPage + 1;
      final newPosts = await getMemberPostsUseCase(targetId, page: nextPage);
      emit(state.copyWith(
        posts: [...state.posts, ...newPosts],
        postsPage: nextPage,
        hasMorePosts: newPosts.length >= 10,
        isLoadingMorePosts: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMorePosts: false));
    }
  }

  void _onPostLikeToggled(
    PeerProfilePostLikeToggled event,
    Emitter<PeerProfileState> emit,
  ) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        final newIsLiked = !post.isLikedByMe;
        final newCount = newIsLiked
            ? post.likesCount + 1
            : (post.likesCount > 0 ? post.likesCount - 1 : 0);
        return post.copyWith(isLikedByMe: newIsLiked, likesCount: newCount);
      }
      return post;
    }).toList();
    emit(state.copyWith(posts: updatedPosts));
  }

  void _onPostSaveToggled(
    PeerProfilePostSaveToggled event,
    Emitter<PeerProfileState> emit,
  ) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        final newIsSaved = !post.isSaved;
        final newCount = newIsSaved
            ? post.savesCount + 1
            : (post.savesCount > 0 ? post.savesCount - 1 : 0);
        return post.copyWith(isSaved: newIsSaved, savesCount: newCount);
      }
      return post;
    }).toList();
    emit(state.copyWith(posts: updatedPosts));
  }

  Future<void> _onFollowToggle(
    PeerProfileFollowToggled event,
    Emitter<PeerProfileState> emit,
  ) async {
    final profile = state.profile;
    if (profile == null) return;

    final currentlyFollowing = profile.isFollowing;
    final nextFollowing = !currentlyFollowing;
    final nextCount = nextFollowing
        ? profile.followersCount + 1
        : (profile.followersCount > 0 ? profile.followersCount - 1 : 0);

    final updated = profile.copyWith(
      isFollowing: nextFollowing,
      followersCount: nextCount,
    );
    emit(state.copyWith(profile: updated));

    try {
      final targetUserId = (profile.userId != null && profile.userId!.isNotEmpty)
          ? profile.userId!
          : profile.id;
      if (currentlyFollowing) {
        await unfollowUserUseCase(targetUserId);
      } else {
        await followUserUseCase(targetUserId);
      }
    } catch (_) {
      emit(state.copyWith(profile: profile));
    }
  }

  Future<void> _onConnect(
    PeerProfileConnectRequested event,
    Emitter<PeerProfileState> emit,
  ) async {
    final profile = state.profile;
    if (profile == null) return;

    final updated = profile.copyWith(
      isConnected: false,
      isRequested: true,
      connectionStatus: 'pending',
    );
    emit(state.copyWith(profile: updated));
    PeersEventBus.instance.emit(
      PeerConnectionRequestedEvent(peerId: profile.id),
    );

    try {
      await sendConnectionRequestUseCase(profile.id);
    } catch (_) {
      emit(state.copyWith(profile: profile));
    }
  }

  Future<void> _onCancelRequest(
    PeerProfileCancelRequestRequested event,
    Emitter<PeerProfileState> emit,
  ) async {
    final profile = state.profile;
    if (profile == null) return;

    final updated = profile.copyWith(
      isConnected: false,
      isRequested: false,
      connectionStatus: 'none',
    );
    emit(state.copyWith(profile: updated));
    PeersEventBus.instance.emit(
      PeerConnectionCancelledEvent(peerId: profile.id),
    );

    try {
      await cancelSentConnectionRequestUseCase(profile.id);
    } catch (_) {
      emit(state.copyWith(profile: profile));
    }
  }

  Future<void> _onRemoveConnection(
    PeerProfileRemoveConnectionRequested event,
    Emitter<PeerProfileState> emit,
  ) async {
    final profile = state.profile;
    if (profile == null) return;

    final updated = profile.copyWith(
      isConnected: false,
      isRequested: false,
      connectionStatus: 'none',
      connectionCount: profile.connectionCount > 0 ? profile.connectionCount - 1 : 0,
    );
    emit(state.copyWith(profile: updated));
    PeersEventBus.instance.emit(
      PeerConnectionCancelledEvent(peerId: profile.id),
    );

    try {
      await removeConnectionUseCase(profile.id);
    } catch (_) {
      emit(state.copyWith(profile: profile));
    }
  }

  Future<void> _onBookmarkToggle(
    PeerProfileBookmarkToggled event,
    Emitter<PeerProfileState> emit,
  ) async {
    final profile = state.profile;
    if (profile == null) return;

    final currentlyBookmarked = profile.isBookmark;
    final updated = profile.copyWith(isBookmark: !currentlyBookmarked);
    emit(state.copyWith(profile: updated));

    try {
      await togglePeerBookmarkUseCase(profile.id, currentlyBookmarked);
    } catch (_) {
      emit(state.copyWith(profile: profile));
    }
  }
}
