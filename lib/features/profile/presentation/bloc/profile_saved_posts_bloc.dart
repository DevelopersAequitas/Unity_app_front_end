import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/usecases/toggle_post_like_usecase.dart';
import '../../../home/domain/usecases/toggle_post_save_usecase.dart';
import '../../domain/usecases/get_saved_posts_usecase.dart';
import 'profile_saved_posts_event.dart';
import 'profile_saved_posts_state.dart';

class ProfileSavedPostsBloc extends Bloc<ProfileSavedPostsEvent, ProfileSavedPostsState> {
  final GetSavedPostsUseCase getSavedPostsUseCase;
  final TogglePostLikeUseCase togglePostLikeUseCase;
  final TogglePostSaveUseCase togglePostSaveUseCase;

  ProfileSavedPostsBloc({
    required this.getSavedPostsUseCase,
    required this.togglePostLikeUseCase,
    required this.togglePostSaveUseCase,
  }) : super(const ProfileSavedPostsState()) {
    on<ProfileSavedPostsFetchRequested>(_onFetchRequested);
    on<ProfileSavedPostsRefreshRequested>(_onRefreshRequested);
    on<ProfileSavedPostsLoadMoreRequested>(_onLoadMoreRequested);
    on<ProfileSavedPostLikeToggled>(_onLikeToggled);
    on<ProfileSavedPostSaveToggled>(_onSaveToggled);
    on<ProfileSavedPostCommentCountIncremented>(_onCommentCountIncremented);
    on<ProfileSavedPostLikeSyncRequested>(_onPostLikeSyncRequested);
    on<ProfileSavedPostSaveSyncRequested>(_onPostSaveSyncRequested);
  }

  void _onCommentCountIncremented(
    ProfileSavedPostCommentCountIncremented event,
    Emitter<ProfileSavedPostsState> emit,
  ) {
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        return post.copyWith(commentsCount: post.commentsCount + 1);
      }
      return post;
    }).toList();
    emit(state.copyWith(posts: updatedPosts));
  }

  Future<void> _onFetchRequested(
    ProfileSavedPostsFetchRequested event,
    Emitter<ProfileSavedPostsState> emit,
  ) async {
    if (state.posts.isEmpty) {
      emit(state.copyWith(status: ProfileSavedPostsStatus.loading));
    }
    try {
      final posts = await getSavedPostsUseCase(page: 1);
      emit(state.copyWith(
        status: ProfileSavedPostsStatus.success,
        posts: posts,
        page: 1,
        hasMore: posts.length >= 10,
        errorMessage: null,
      ));
    } catch (e) {
      if (state.posts.isEmpty) {
        emit(state.copyWith(
          status: ProfileSavedPostsStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    }
  }

  Future<void> _onRefreshRequested(
    ProfileSavedPostsRefreshRequested event,
    Emitter<ProfileSavedPostsState> emit,
  ) async {
    try {
      final posts = await getSavedPostsUseCase(page: 1);
      emit(state.copyWith(
        status: ProfileSavedPostsStatus.success,
        posts: posts,
        page: 1,
        hasMore: posts.length >= 10,
        errorMessage: null,
      ));
    } catch (_) {}
  }

  Future<void> _onLoadMoreRequested(
    ProfileSavedPostsLoadMoreRequested event,
    Emitter<ProfileSavedPostsState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.page + 1;
      final newPosts = await getSavedPostsUseCase(page: nextPage);
      emit(state.copyWith(
        posts: [...state.posts, ...newPosts],
        page: nextPage,
        hasMore: newPosts.length >= 10,
        isLoadingMore: false,
      ));
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onLikeToggled(
    ProfileSavedPostLikeToggled event,
    Emitter<ProfileSavedPostsState> emit,
  ) async {
    bool wasLiked = false;
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        wasLiked = post.isLikedByMe;
        final newIsLiked = !post.isLikedByMe;
        final newCount =
            newIsLiked ? post.likesCount + 1 : (post.likesCount > 0 ? post.likesCount - 1 : 0);
        return post.copyWith(isLikedByMe: newIsLiked, likesCount: newCount);
      }
      return post;
    }).toList();
    emit(state.copyWith(posts: updatedPosts));

    try {
      await togglePostLikeUseCase(event.postId, isCurrentlyLiked: wasLiked);
    } catch (_) {}
  }

  Future<void> _onSaveToggled(
    ProfileSavedPostSaveToggled event,
    Emitter<ProfileSavedPostsState> emit,
  ) async {
    bool wasSaved = true;
    final updatedPosts = state.posts.where((p) => p.id != event.postId).toList();
    emit(state.copyWith(posts: updatedPosts));

    try {
      await togglePostSaveUseCase(event.postId, isCurrentlySaved: wasSaved);
    } catch (_) {}
  }

  void _onPostLikeSyncRequested(
    ProfileSavedPostLikeSyncRequested event,
    Emitter<ProfileSavedPostsState> emit,
  ) {
    final updatedPosts = state.posts.map((p) {
      if (p.id != event.postId) return p;
      return p.copyWith(
        isLikedByMe: event.isLiked,
        likesCount: event.likesCount,
      );
    }).toList();
    emit(state.copyWith(posts: updatedPosts));
  }

  void _onPostSaveSyncRequested(
    ProfileSavedPostSaveSyncRequested event,
    Emitter<ProfileSavedPostsState> emit,
  ) {
    if (!event.isSaved) {
      final updatedPosts = state.posts.where((p) => p.id != event.postId).toList();
      emit(state.copyWith(posts: updatedPosts));
    }
  }
}
