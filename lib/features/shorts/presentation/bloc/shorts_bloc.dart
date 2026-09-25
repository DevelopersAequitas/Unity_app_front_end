import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/intro_video_entity.dart';
import '../../domain/repositories/shorts_repository.dart';
import '../../domain/usecases/get_intro_videos_usecase.dart';
import 'shorts_event.dart';
import 'shorts_state.dart';

class ShortsBloc extends Bloc<ShortsEvent, ShortsState> {
  final GetIntroVideosUseCase getIntroVideosUseCase;
  final ShortsRepository repository;

  Timer? _bgSyncTimer;

  ShortsBloc({
    required this.getIntroVideosUseCase,
    required this.repository,
  }) : super(const ShortsState()) {
    on<FetchIntroVideosEvent>(_onFetchIntroVideos);
    on<ShortsPageChangedEvent>(_onPageChanged);
    on<ToggleShortLikeEvent>(_onToggleLike);
    on<ToggleShortBookmarkEvent>(_onToggleBookmark);
    on<ToggleShortFollowEvent>(_onToggleFollow);
    on<_ShortsBackgroundSyncEvent>(_onBackgroundSync);

    // Periodic background sync every 90 seconds to pick up new videos
    _bgSyncTimer = Timer.periodic(const Duration(seconds: 90), (_) {
      if (!isClosed) {
        add(const _ShortsBackgroundSyncEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _bgSyncTimer?.cancel();
    return super.close();
  }

  Future<void> _onFetchIntroVideos(
    FetchIntroVideosEvent event,
    Emitter<ShortsState> emit,
  ) async {
    // 1. Stale-while-revalidate: load cached videos immediately on initial launch
    if (state.status == ShortsStatus.initial && state.videos.isEmpty) {
      final cached = await getIntroVideosUseCase.getCached();
      if (cached.isNotEmpty) {
        emit(state.copyWith(
          status: ShortsStatus.loaded,
          videos: cached,
          currentPage: 2,
          hasReachedMax: false,
        ));
      } else {
        emit(state.copyWith(status: ShortsStatus.loading));
      }
    } else if (event.isRefresh) {
      if (state.videos.isEmpty) {
        emit(state.copyWith(status: ShortsStatus.loading, currentPage: 1));
      }
    }

    try {
      final page = event.isRefresh ? 1 : state.currentPage;
      final result = await getIntroVideosUseCase(page: page, perPage: 10);
      final newVideos = result.videos;

      final updatedList =
          event.isRefresh ? newVideos : _mergeVideos(state.videos, newVideos);

      // hasReachedMax: if we got fewer than per_page OR total is known and list covers it
      final total = result.total;
      final hasReachedMax = total != null
          ? updatedList.length >= total
          : newVideos.length < 10;

      emit(state.copyWith(
        status: ShortsStatus.loaded,
        videos: updatedList,
        hasReachedMax: hasReachedMax,
        currentPage: event.isRefresh ? 2 : page + 1,
        errorMessage: null,
      ));
    } catch (e) {
      if (state.videos.isEmpty) {
        emit(state.copyWith(
          status: ShortsStatus.error,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  /// Merges newly fetched page into the existing list, deduplicating by id.
  List<IntroVideoEntity> _mergeVideos(
    List<IntroVideoEntity> existing,
    List<IntroVideoEntity> incoming,
  ) {
    final ids = existing.map((v) => v.id).toSet();
    final fresh = incoming.where((v) => !ids.contains(v.id)).toList();
    return [...existing, ...fresh];
  }

  /// Background sync: silently refresh page 1 and prepend any new videos.
  Future<void> _onBackgroundSync(
    _ShortsBackgroundSyncEvent event,
    Emitter<ShortsState> emit,
  ) async {
    if (state.status != ShortsStatus.loaded) return;
    try {
      final result = await getIntroVideosUseCase(page: 1, perPage: 10);
      final incoming = result.videos;
      if (incoming.isEmpty) return;

      final existingIds = state.videos.map((v) => v.id).toSet();
      final brandNew = incoming.where((v) => !existingIds.contains(v.id)).toList();

      if (brandNew.isNotEmpty) {
        // Prepend new videos to the front (newest first)
        final merged = [...brandNew, ...state.videos];
        emit(state.copyWith(videos: merged));
      }
    } catch (_) {
      // Silently ignore background sync errors
    }
  }

  void _onPageChanged(
    ShortsPageChangedEvent event,
    Emitter<ShortsState> emit,
  ) {
    emit(state.copyWith(currentIndex: event.index));
    if (event.index >= state.videos.length - 2 && !state.hasReachedMax) {
      add(const FetchIntroVideosEvent());
    }
  }

  Future<void> _onToggleLike(
    ToggleShortLikeEvent event,
    Emitter<ShortsState> emit,
  ) async {
    final index = state.videos.indexWhere(
        (v) => v.id == event.videoId || v.introVideoId == event.videoId);
    if (index == -1) return;

    final current = state.videos[index];
    final newStatus = !current.isLiked;
    final newCount = newStatus
        ? current.likesCount + 1
        : (current.likesCount > 0 ? current.likesCount - 1 : 0);

    final updated = List.of(state.videos);
    updated[index] = current.copyWith(isLiked: newStatus, likesCount: newCount);
    emit(state.copyWith(videos: updated));

    try {
      final targetId = current.introVideoId ?? current.id;
      await repository.toggleLike(targetId, current.isLiked);
    } catch (_) {
      updated[index] = current;
      emit(state.copyWith(videos: updated));
    }
  }

  Future<void> _onToggleBookmark(
    ToggleShortBookmarkEvent event,
    Emitter<ShortsState> emit,
  ) async {
    final index = state.videos
        .indexWhere((v) => v.userId == event.memberId || v.id == event.memberId);
    if (index == -1) return;

    final current = state.videos[index];
    final newStatus = !current.isBookmarked;

    final updated = List.of(state.videos);
    updated[index] = current.copyWith(isBookmarked: newStatus);
    emit(state.copyWith(videos: updated));

    try {
      await repository.toggleBookmark(event.memberId, current.isBookmarked);
    } catch (_) {
      updated[index] = current;
      emit(state.copyWith(videos: updated));
    }
  }

  Future<void> _onToggleFollow(
    ToggleShortFollowEvent event,
    Emitter<ShortsState> emit,
  ) async {
    final index = state.videos
        .indexWhere((v) => v.userId == event.memberId || v.id == event.memberId);
    if (index == -1) return;

    final current = state.videos[index];
    final newStatus = !current.isFollowing;

    final updated = List.of(state.videos);
    updated[index] = current.copyWith(isFollowing: newStatus);
    emit(state.copyWith(videos: updated));

    try {
      await repository.toggleFollow(event.memberId, current.isFollowing);
    } catch (_) {
      updated[index] = current;
      emit(state.copyWith(videos: updated));
    }
  }
}

/// Internal event for background sync — not user-initiated.
class _ShortsBackgroundSyncEvent extends ShortsEvent {
  const _ShortsBackgroundSyncEvent();
}
