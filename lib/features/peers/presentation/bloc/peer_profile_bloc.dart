import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../../home/domain/usecases/toggle_post_like_usecase.dart';
import '../../../home/domain/usecases/toggle_post_save_usecase.dart';
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
  final TogglePostLikeUseCase? togglePostLikeUseCase;
  final TogglePostSaveUseCase? togglePostSaveUseCase;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  PeerProfileBloc({
    required this.getMemberProfileUseCase,
    required this.getMemberPostsUseCase,
    required this.followUserUseCase,
    required this.unfollowUserUseCase,
    required this.sendConnectionRequestUseCase,
    required this.removeConnectionUseCase,
    required this.cancelSentConnectionRequestUseCase,
    required this.togglePeerBookmarkUseCase,
    this.togglePostLikeUseCase,
    this.togglePostSaveUseCase,
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
    on<PeerProfilePostCommentCountIncremented>(_onPostCommentCountIncremented);
    on<PeerProfileEventBusUpdateReceived>(_onEventBusUpdateReceived);

    _busSubscription = PeersEventBus.instance.stream.listen((event) {
      if (event is PeerConnectionAcceptedEvent) {
        add(PeerProfileEventBusUpdateReceived(
          peerId: event.peerId,
          connectionStatus: 'connected',
          isConnected: true,
          isRequested: false,
        ));
      } else if (event is PeerConnectionRequestedEvent) {
        add(PeerProfileEventBusUpdateReceived(
          peerId: event.peerId,
          connectionStatus: 'pending',
          isConnected: false,
          isRequested: true,
        ));
      } else if (event is PeerConnectionDeclinedEvent ||
          event is PeerConnectionCancelledEvent) {
        final peerId = event is PeerConnectionDeclinedEvent
            ? event.peerId
            : (event as PeerConnectionCancelledEvent).peerId;
        add(PeerProfileEventBusUpdateReceived(
          peerId: peerId,
          connectionStatus: 'none',
          isConnected: false,
          isRequested: false,
        ));
      } else if (event is PeerFollowToggledEvent) {
        add(PeerProfileEventBusUpdateReceived(
          peerId: event.peerId,
          isFollowing: event.isFollowing,
        ));
      } else if (event is PeerBookmarkToggledEvent) {
        add(PeerProfileEventBusUpdateReceived(
          peerId: event.peerId,
          isBookmarked: event.isBookmarked,
        ));
      }
    });
  }

  void _onEventBusUpdateReceived(
    PeerProfileEventBusUpdateReceived event,
    Emitter<PeerProfileState> emit,
  ) {
    final profile = state.profile;
    if (profile == null) return;
    final matches = profile.id == event.peerId ||
        profile.userId == event.peerId ||
        profile.peerId == event.peerId;
    if (!matches) return;

    var updated = profile;
    if (event.isFollowing != null) {
      final nextCount = event.isFollowing!
          ? (profile.isFollowing ? profile.followersCount : profile.followersCount + 1)
          : (profile.isFollowing ? (profile.followersCount > 0 ? profile.followersCount - 1 : 0) : profile.followersCount);
      updated = updated.copyWith(
        isFollowing: event.isFollowing,
        followersCount: nextCount,
      );
    }
    if (event.isBookmarked != null) {
      updated = updated.copyWith(isBookmark: event.isBookmarked);
    }
    if (event.connectionStatus != null) {
      updated = updated.copyWith(connectionStatus: event.connectionStatus);
    }
    if (event.isConnected != null) {
      updated = updated.copyWith(isConnected: event.isConnected);
    }
    if (event.isRequested != null) {
      updated = updated.copyWith(isRequested: event.isRequested);
    }
    emit(state.copyWith(profile: updated));
  }

  @override
  Future<void> close() {
    _busSubscription?.cancel();
    return super.close();
  }


  void _onPostCommentCountIncremented(
    PeerProfilePostCommentCountIncremented event,
    Emitter<PeerProfileState> emit,
  ) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        return post.copyWith(commentsCount: post.commentsCount + 1);
      }
      return post;
    }).toList();
    emit(state.copyWith(posts: updatedPosts));
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

        final posts = await getMemberPostsUseCase(targetId);

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

  Future<void> _onPostLikeToggled(
    PeerProfilePostLikeToggled event,
    Emitter<PeerProfileState> emit,
  ) async {
    bool wasLiked = false;
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        wasLiked = post.isLikedByMe;
        final newIsLiked = !post.isLikedByMe;
        final newCount = newIsLiked
            ? post.likesCount + 1
            : (post.likesCount > 0 ? post.likesCount - 1 : 0);
        return post.copyWith(isLikedByMe: newIsLiked, likesCount: newCount);
      }
      return post;
    }).toList();
    emit(state.copyWith(posts: updatedPosts));

    if (togglePostLikeUseCase != null) {
      try {
        await togglePostLikeUseCase!(event.postId, isCurrentlyLiked: wasLiked);
      } catch (_) {
        // Revert on error
        final reverted = state.posts.map((post) {
          if (post.id == event.postId) {
            final prevCount = wasLiked
                ? post.likesCount + 1
                : (post.likesCount > 0 ? post.likesCount - 1 : 0);
            return post.copyWith(isLikedByMe: wasLiked, likesCount: prevCount);
          }
          return post;
        }).toList();
        emit(state.copyWith(posts: reverted));
      }
    }
  }

  Future<void> _onPostSaveToggled(
    PeerProfilePostSaveToggled event,
    Emitter<PeerProfileState> emit,
  ) async {
    bool wasSaved = false;
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        wasSaved = post.isSaved;
        final newIsSaved = !post.isSaved;
        final newCount = newIsSaved
            ? post.savesCount + 1
            : (post.savesCount > 0 ? post.savesCount - 1 : 0);
        return post.copyWith(isSaved: newIsSaved, savesCount: newCount);
      }
      return post;
    }).toList();
    emit(state.copyWith(posts: updatedPosts));

    if (togglePostSaveUseCase != null) {
      try {
        await togglePostSaveUseCase!(event.postId, isCurrentlySaved: wasSaved);
      } catch (_) {
        // Revert on error
        final reverted = state.posts.map((post) {
          if (post.id == event.postId) {
            final prevCount = wasSaved
                ? post.savesCount + 1
                : (post.savesCount > 0 ? post.savesCount - 1 : 0);
            return post.copyWith(isSaved: wasSaved, savesCount: prevCount);
          }
          return post;
        }).toList();
        emit(state.copyWith(posts: reverted));
      }
    }
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
    PeersEventBus.instance.emit(
      PeerFollowToggledEvent(peerId: profile.id, isFollowing: nextFollowing),
    );

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
      PeersEventBus.instance.emit(
        PeerFollowToggledEvent(peerId: profile.id, isFollowing: currentlyFollowing),
      );
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
    PeersEventBus.instance.emit(
      PeerBookmarkToggledEvent(peerId: profile.id, isBookmarked: !currentlyBookmarked),
    );

    try {
      await togglePeerBookmarkUseCase(profile.id, currentlyBookmarked);
    } catch (_) {
      emit(state.copyWith(profile: profile));
      PeersEventBus.instance.emit(
        PeerBookmarkToggledEvent(peerId: profile.id, isBookmarked: currentlyBookmarked),
      );
    }
  }
}
