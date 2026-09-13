import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/usecases/delete_post_usecase.dart';
import '../../../home/domain/usecases/toggle_post_like_usecase.dart';
import '../../../home/domain/usecases/toggle_post_save_usecase.dart';
import '../../../home/domain/usecases/update_post_usecase.dart';
import '../../domain/usecases/get_user_posts_usecase.dart';
import 'profile_posts_event.dart';
import 'profile_posts_state.dart';

class ProfilePostsBloc extends Bloc<ProfilePostsEvent, ProfilePostsState> {
  final GetUserPostsUseCase getUserPostsUseCase;
  final TogglePostLikeUseCase togglePostLikeUseCase;
  final TogglePostSaveUseCase togglePostSaveUseCase;
  final DeletePostUseCase? deletePostUseCase;
  final UpdatePostUseCase? updatePostUseCase;

  ProfilePostsBloc({
    required this.getUserPostsUseCase,
    required this.togglePostLikeUseCase,
    required this.togglePostSaveUseCase,
    this.deletePostUseCase,
    this.updatePostUseCase,
  }) : super(const ProfilePostsState()) {
    on<ProfilePostsFetchRequested>(_onFetchRequested);
    on<ProfilePostsRefreshRequested>(_onRefreshRequested);
    on<ProfilePostsLoadMoreRequested>(_onLoadMoreRequested);
    on<ProfilePostLikeToggled>(_onLikeToggled);
    on<ProfilePostSaveToggled>(_onSaveToggled);
    on<ProfilePostCommentCountIncremented>(_onCommentCountIncremented);
    on<ProfilePostDeleted>(_onPostDeleted);
    on<ProfilePostEdited>(_onPostEdited);
    on<ProfilePostLikeSyncRequested>(_onPostLikeSyncRequested);
    on<ProfilePostSaveSyncRequested>(_onPostSaveSyncRequested);
  }

  void _onCommentCountIncremented(
    ProfilePostCommentCountIncremented event,
    Emitter<ProfilePostsState> emit,
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
    ProfilePostsFetchRequested event,
    Emitter<ProfilePostsState> emit,
  ) async {
    if (state.posts.isEmpty) {
      emit(state.copyWith(status: ProfilePostsStatus.loading));
    }
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
      if (state.posts.isEmpty) {
        emit(state.copyWith(
          status: ProfilePostsStatus.failure,
          errorMessage: e.toString(),
        ));
      }
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

  Future<void> _onPostDeleted(
    ProfilePostDeleted event,
    Emitter<ProfilePostsState> emit,
  ) async {
    final updatedPosts = state.posts.where((p) => p.id != event.postId).toList();
    emit(state.copyWith(posts: updatedPosts));
    try {
      if (deletePostUseCase != null) {
        await deletePostUseCase!(event.postId);
      }
    } catch (_) {}
  }

  Future<void> _onPostEdited(
    ProfilePostEdited event,
    Emitter<ProfilePostsState> emit,
  ) async {
    final updatedPosts = state.posts.map((p) {
      if (p.id != event.postId) return p;
      return p.copyWith(contentText: event.contentText);
    }).toList();
    emit(state.copyWith(posts: updatedPosts));
    try {
      if (updatePostUseCase != null) {
        await updatePostUseCase!(event.postId, contentText: event.contentText);
      }
    } catch (_) {}
  }

  void _onPostLikeSyncRequested(
    ProfilePostLikeSyncRequested event,
    Emitter<ProfilePostsState> emit,
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
    ProfilePostSaveSyncRequested event,
    Emitter<ProfilePostsState> emit,
  ) {
    final updatedPosts = state.posts.map((p) {
      if (p.id != event.postId) return p;
      final isSaved = event.isSaved;
      return p.copyWith(
        isSaved: isSaved,
        savesCount: (p.savesCount + (isSaved ? 1 : -1)).clamp(0, 9999999),
      );
    }).toList();
    emit(state.copyWith(posts: updatedPosts));
  }
}
