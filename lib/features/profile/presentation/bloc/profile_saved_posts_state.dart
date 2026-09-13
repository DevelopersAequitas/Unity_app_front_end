import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/timeline_item_entity.dart';

enum ProfileSavedPostsStatus { initial, loading, success, failure }

class ProfileSavedPostsState extends Equatable {
  final ProfileSavedPostsStatus status;
  final List<TimelineItemEntity> posts;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const ProfileSavedPostsState({
    this.status = ProfileSavedPostsStatus.initial,
    this.posts = const [],
    this.page = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  ProfileSavedPostsState copyWith({
    ProfileSavedPostsStatus? status,
    List<TimelineItemEntity>? posts,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return ProfileSavedPostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        posts,
        page,
        hasMore,
        isLoadingMore,
        errorMessage,
      ];
}
