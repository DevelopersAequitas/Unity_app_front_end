import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/timeline_item_entity.dart';
import '../../../profile/domain/entities/profile_entity.dart';

enum PeerProfileStatus { initial, loading, success, failure }

class PeerProfileState extends Equatable {
  final PeerProfileStatus status;
  final ProfileEntity? profile;
  final List<TimelineItemEntity> posts;
  final bool isPostsLoading;
  final bool isActionLoading;
  final String? errorMessage;
  final int postsPage;
  final bool hasMorePosts;
  final bool isLoadingMorePosts;

  const PeerProfileState({
    this.status = PeerProfileStatus.initial,
    this.profile,
    this.posts = const [],
    this.isPostsLoading = false,
    this.isActionLoading = false,
    this.errorMessage,
    this.postsPage = 1,
    this.hasMorePosts = false,
    this.isLoadingMorePosts = false,
  });

  PeerProfileState copyWith({
    PeerProfileStatus? status,
    ProfileEntity? profile,
    List<TimelineItemEntity>? posts,
    bool? isPostsLoading,
    bool? isActionLoading,
    String? errorMessage,
    int? postsPage,
    bool? hasMorePosts,
    bool? isLoadingMorePosts,
  }) {
    return PeerProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      posts: posts ?? this.posts,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      postsPage: postsPage ?? this.postsPage,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
      isLoadingMorePosts: isLoadingMorePosts ?? this.isLoadingMorePosts,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        posts,
        isPostsLoading,
        isActionLoading,
        errorMessage,
        postsPage,
        hasMorePosts,
        isLoadingMorePosts,
      ];
}
