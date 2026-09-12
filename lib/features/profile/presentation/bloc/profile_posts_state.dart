import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/timeline_item_entity.dart';

enum ProfilePostsStatus { initial, loading, success, failure }

class ProfilePostsState extends Equatable {
  final ProfilePostsStatus status;
  final List<TimelineItemEntity> posts;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const ProfilePostsState({
    this.status = ProfilePostsStatus.initial,
    this.posts = const [],
    this.page = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  ProfilePostsState copyWith({
    ProfilePostsStatus? status,
    List<TimelineItemEntity>? posts,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return ProfilePostsState(
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
