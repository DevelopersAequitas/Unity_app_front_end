import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/shorts_repository.dart';
import '../../domain/usecases/get_intro_videos_usecase.dart';
import 'shorts_event.dart';
import 'shorts_state.dart';

class ShortsBloc extends Bloc<ShortsEvent, ShortsState> {
  final GetIntroVideosUseCase getIntroVideosUseCase;
  final ShortsRepository repository;

  ShortsBloc({
    required this.getIntroVideosUseCase,
    required this.repository,
  }) : super(const ShortsState()) {
    on<FetchIntroVideosEvent>(_onFetchIntroVideos);
    on<ShortsPageChangedEvent>(_onPageChanged);
    on<ToggleShortLikeEvent>(_onToggleLike);
    on<ToggleShortBookmarkEvent>(_onToggleBookmark);
    on<ToggleShortFollowEvent>(_onToggleFollow);
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
          hasReachedMax: cached.length < 15,
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
      final videos = await getIntroVideosUseCase(page: page, perPage: 15);
      final updatedList = event.isRefresh ? videos : [...state.videos, ...videos];

      emit(state.copyWith(
        status: ShortsStatus.loaded,
        videos: updatedList,
        hasReachedMax: videos.length < 15,
        currentPage: page + 1,
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
    final index = state.videos.indexWhere((v) => v.id == event.videoId || v.introVideoId == event.videoId);
    if (index == -1) return;

    final current = state.videos[index];
    final newStatus = !current.isLiked;
    final newCount = newStatus ? current.likesCount + 1 : (current.likesCount > 0 ? current.likesCount - 1 : 0);

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
    final index = state.videos.indexWhere((v) => v.userId == event.memberId || v.id == event.memberId);
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
    final index = state.videos.indexWhere((v) => v.userId == event.memberId || v.id == event.memberId);
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
