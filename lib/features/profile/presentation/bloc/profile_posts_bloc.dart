import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/usecases/toggle_post_like_usecase.dart';
import '../../../home/domain/usecases/toggle_post_save_usecase.dart';
import '../../domain/usecases/get_user_posts_usecase.dart';
import 'profile_posts_event.dart';
import 'profile_posts_state.dart';

class ProfilePostsBloc extends Bloc<ProfilePostsEvent, ProfilePostsState> {
  final GetUserPostsUseCase getUserPostsUseCase;
  final TogglePostLikeUseCase togglePostLikeUseCase;
  final TogglePostSaveUseCase togglePostSaveUseCase;

  ProfilePostsBloc({
    required this.getUserPostsUseCase,
    required this.togglePostLikeUseCase,
    required this.togglePostSaveUseCase,
  }) : super(const ProfilePostsState()) {
    on<ProfilePostsFetchRequested>(_onFetchRequested);
    on<ProfilePostsRefreshRequested>(_onRefreshRequested);
    on<ProfilePostsLoadMoreRequested>(_onLoadMoreRequested);
    on<ProfilePostLikeToggled>(_onLikeToggled);
    on<ProfilePostSaveToggled>(_onSaveToggled);
  }

  Future<void> _onFetchRequested(
    ProfilePostsFetchRequested event,
    Emitter<ProfilePostsState> emit,
  ) async {
    emit(state.copyWith(status: ProfilePostsStatus.loading));
    try {
      final posts = await getUserPostsUseCase(page: 1);
      emit(state.copyWith(
        status: ProfilePostsStatus.success,
        posts: posts,
        page: 1,
        hasMore: posts.length >= 10,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfilePostsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshRequested(
    ProfilePostsRefreshRequested event,
    Emitter<ProfilePostsState> emit,
  ) async {
    try {
      final posts = await getUserPostsUseCase(page: 1);
      emit(state.copyWith(
        status: ProfilePostsStatus.success,
        posts: posts,
        page: 1,
        hasMore: posts.length >= 10,
        errorMessage: null,
      ));
    } catch (_) {}
  }

  Future<void> _onLoadMoreRequested(
    ProfilePostsLoadMoreRequested event,
    Emitter<ProfilePostsState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.page + 1;
      final newPosts = await getUserPostsUseCase(page: nextPage);
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
    ProfilePostLikeToggled event,
    Emitter<ProfilePostsState> emit,
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
    ProfilePostSaveToggled event,
    Emitter<ProfilePostsState> emit,
  ) async {
    bool wasSaved = false;
    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        wasSaved = post.isSaved;
        return post.copyWith(isSaved: !post.isSaved);
      }
      return post;
    }).toList();
    emit(state.copyWith(posts: updatedPosts));

    try {
      await togglePostSaveUseCase(event.postId, isCurrentlySaved: wasSaved);
    } catch (_) {}
  }
}
