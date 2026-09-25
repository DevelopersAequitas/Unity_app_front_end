import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/features/profile/domain/entities/profile_entity.dart';
import '../../../../core/events/peers_event_bus.dart';
import '../../../home/domain/usecases/toggle_post_like_usecase.dart';
import '../../../home/domain/usecases/toggle_post_save_usecase.dart';
import '../../domain/usecases/block_peer_usecase.dart';
import '../../domain/usecases/cancel_sent_connection_request_usecase.dart';
import '../../domain/usecases/follow_user_usecase.dart';
import '../../domain/usecases/get_member_introduced_peers_usecase.dart';
import '../../domain/usecases/get_member_posts_usecase.dart';
import '../../domain/usecases/get_member_profile_usecase.dart';
import '../../domain/usecases/get_peer_block_status_usecase.dart';
import '../../domain/usecases/remove_connection_usecase.dart';
import '../../domain/usecases/send_connection_request_usecase.dart';
import '../../domain/usecases/toggle_peer_bookmark_usecase.dart';
import '../../domain/usecases/unblock_peer_usecase.dart';
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
  final GetMemberIntroducedPeersUseCase? getMemberIntroducedPeersUseCase;
  final TogglePostLikeUseCase? togglePostLikeUseCase;
  final TogglePostSaveUseCase? togglePostSaveUseCase;
  final BlockPeerUseCase? blockPeerUseCase;
  final UnblockPeerUseCase? unblockPeerUseCase;
  final GetPeerBlockStatusUseCase? getPeerBlockStatusUseCase;
  StreamSubscription<PeerBusEvent>? _busSubscription;

  PeerProfileBloc({
    required this.getMemberProfileUseCase,
    required this.getMemberPostsUseCase,
    this.getMemberIntroducedPeersUseCase,
    required this.followUserUseCase,
    required this.unfollowUserUseCase,
    required this.sendConnectionRequestUseCase,
    required this.removeConnectionUseCase,
    required this.cancelSentConnectionRequestUseCase,
    required this.togglePeerBookmarkUseCase,
    this.togglePostLikeUseCase,
    this.togglePostSaveUseCase,
    this.blockPeerUseCase,
    this.unblockPeerUseCase,
    this.getPeerBlockStatusUseCase,
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
    on<PeerProfileBlockRequested>(_onBlockPeer);
    on<PeerProfileUnblockRequested>(_onUnblockPeer);

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
      } else if (event is PeerBlockedEvent) {
        add(PeerProfileEventBusUpdateReceived(
          peerId: event.peerId,
          isBlocked: true,
          connectionStatus: 'none',
          isConnected: false,
          isRequested: false,
        ));
      } else if (event is PeerUnblockedEvent) {
        add(PeerProfileEventBusUpdateReceived(
          peerId: event.peerId,
          isBlocked: false,
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
    if (event.isFollowing != null && profile.isFollowing != event.isFollowing) {
      final nextCount = event.isFollowing!
          ? profile.followersCount + 1
          : (profile.followersCount > 0 ? profile.followersCount - 1 : 0);
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
    if (event.isBlocked != null) {
      updated = updated.copyWith(
        isBlocked: event.isBlocked,
        isBlockedByMe: event.isBlockedByMe ?? (event.isBlocked == true),
        isBlockedByPeer: event.isBlockedByPeer ?? false,
        isConnected: event.isBlocked == true ? false : updated.isConnected,
        isRequested: event.isBlocked == true ? false : updated.isRequested,
        connectionStatus: event.isBlocked == true ? 'none' : updated.connectionStatus,
      );
    }
    emit(state.copyWith(
      profile: updated,
      isBlocked: event.isBlocked ?? state.isBlocked,
      isBlockedByMe: event.isBlockedByMe ?? (event.isBlocked == true ? true : state.isBlockedByMe),
      isBlockedByPeer: event.isBlockedByPeer ?? state.isBlockedByPeer,
      isBlockLoading: false,
    ));
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
    emit(state.copyWith(
      status: PeerProfileStatus.loading,
      isBlockLoading: false,
    ));
    try {
      bool isBlocked = false;
      if (getPeerBlockStatusUseCase != null) {
        try {
          isBlocked = await getPeerBlockStatusUseCase!(event.peerId);
        } catch (_) {}
      }

      if (isBlocked) {
        ProfileEntity? profile;
        try {
          profile = await getMemberProfileUseCase(event.peerId);
        } catch (_) {}

        final isBlockedByPeer = profile?.isBlockedByPeer ?? false;
        final isBlockedByMe = profile?.isBlockedByMe ?? !isBlockedByPeer;

        emit(state.copyWith(
          status: PeerProfileStatus.success,
          profile: (profile ?? state.profile)?.copyWith(
            isBlocked: true,
            isBlockedByMe: isBlockedByMe,
            isBlockedByPeer: isBlockedByPeer,
          ),
          isBlocked: true,
          isBlockedByMe: isBlockedByMe,
          isBlockedByPeer: isBlockedByPeer,
          isBlockLoading: false,
          errorMessage: null,
          isPostsLoading: false,
          isIntroducedPeersLoading: false,
        ));
        return;
      }

      final profile = await getMemberProfileUseCase(event.peerId);
      final effectiveBlocked = profile.isBlocked;
      final effectiveBlockedByMe = profile.isBlockedByMe;
      final effectiveBlockedByPeer = profile.isBlockedByPeer;

      emit(state.copyWith(
        status: PeerProfileStatus.success,
        profile: profile,
        isBlocked: effectiveBlocked,
        isBlockedByMe: effectiveBlockedByMe,
        isBlockedByPeer: effectiveBlockedByPeer,
        isBlockLoading: false,
        errorMessage: null,
        isPostsLoading: !effectiveBlocked,
        isIntroducedPeersLoading: !effectiveBlocked,
      ));

      if (!effectiveBlocked) {
        if (getMemberIntroducedPeersUseCase != null) {
          try {
            final targetMemberId =
                (profile.id.isNotEmpty) ? profile.id : event.peerId;
            final introduced =
                await getMemberIntroducedPeersUseCase!(targetMemberId);
            emit(state.copyWith(
              introducedPeers: introduced,
              isIntroducedPeersLoading: false,
            ));
          } catch (_) {
            emit(state.copyWith(isIntroducedPeersLoading: false));
          }
        } else {
          emit(state.copyWith(isIntroducedPeersLoading: false));
        }

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
      } else {
        emit(state.copyWith(
          isPostsLoading: false,
          isIntroducedPeersLoading: false,
        ));
      }
    } catch (e) {
      bool isBlocked = false;
      if (getPeerBlockStatusUseCase != null) {
        try {
          isBlocked = await getPeerBlockStatusUseCase!(event.peerId);
        } catch (_) {}
      }
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('block') || errStr.contains('403') || isBlocked) {
        final isByPeer = errStr.contains('403') || errStr.contains('peer');
        emit(state.copyWith(
          status: PeerProfileStatus.success,
          isBlocked: true,
          isBlockedByMe: !isByPeer,
          isBlockedByPeer: isByPeer,
          isBlockLoading: false,
          errorMessage: null,
        ));
      } else {
        emit(state.copyWith(
          status: PeerProfileStatus.failure,
          isBlockLoading: false,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> _onBlockPeer(
    PeerProfileBlockRequested event,
    Emitter<PeerProfileState> emit,
  ) async {
    if (state.isBlockLoading) return;
    final profile = state.profile;
    final targetId = (event.peerId != null && event.peerId!.isNotEmpty)
        ? event.peerId!
        : (profile?.id.isNotEmpty == true ? profile!.id : (profile?.userId ?? ''));
    if (targetId.isEmpty) {
      emit(state.copyWith(isBlockLoading: false));
      return;
    }

    final updatedProfile = profile?.copyWith(
      isBlocked: true,
      isConnected: false,
      isRequested: false,
      connectionStatus: 'none',
    );
    emit(state.copyWith(
      isBlocked: true,
      isBlockLoading: true,
      profile: updatedProfile,
      errorMessage: null,
    ));

    try {
      if (blockPeerUseCase != null) {
        await blockPeerUseCase!(targetId, reason: event.reason ?? 'Spam messages');
      }
      emit(state.copyWith(
        isBlocked: true,
        isBlockLoading: false,
        profile: updatedProfile,
        errorMessage: null,
      ));
      PeersEventBus.instance.emit(PeerBlockedEvent(peerId: targetId));
      PeersEventBus.instance.emit(const PeersSyncNeededEvent());
    } catch (_) {
      emit(state.copyWith(
        isBlocked: false,
        isBlockLoading: false,
        profile: profile,
        errorMessage: 'Failed to block peer. Please try again.',
      ));
    }
  }

  Future<void> _onUnblockPeer(
    PeerProfileUnblockRequested event,
    Emitter<PeerProfileState> emit,
  ) async {
    if (state.isBlockLoading) return;
    final profile = state.profile;
    final targetId = (event.peerId != null && event.peerId!.isNotEmpty)
        ? event.peerId!
        : (profile?.id.isNotEmpty == true ? profile!.id : (profile?.userId ?? ''));
    if (targetId.isEmpty) {
      emit(state.copyWith(isBlockLoading: false));
      return;
    }

    emit(state.copyWith(isBlockLoading: true));
    try {
      if (unblockPeerUseCase != null) {
        await unblockPeerUseCase!(targetId);
      }
      final updatedProfile = profile?.copyWith(isBlocked: false);
      emit(state.copyWith(
        isBlocked: false,
        isBlockLoading: false,
        profile: updatedProfile,
        errorMessage: null,
      ));
      PeersEventBus.instance.emit(PeerUnblockedEvent(peerId: targetId));
      PeersEventBus.instance.emit(const PeersSyncNeededEvent());
      add(PeerProfileFetchRequested(targetId));
    } catch (_) {
      emit(state.copyWith(
        isBlockLoading: false,
        errorMessage: 'Failed to unblock peer. Please try again.',
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

    final targetId = profile.id.isNotEmpty ? profile.id : (profile.userId ?? '');
    try {
      if (currentlyFollowing) {
        await unfollowUserUseCase(targetId);
      } else {
        await followUserUseCase(targetId);
      }
    } catch (_) {
      if (profile.userId != null &&
          profile.userId!.isNotEmpty &&
          profile.userId != targetId) {
        try {
          if (currentlyFollowing) {
            await unfollowUserUseCase(profile.userId!);
          } else {
            await followUserUseCase(profile.userId!);
          }
          return;
        } catch (_) {}
      }
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
