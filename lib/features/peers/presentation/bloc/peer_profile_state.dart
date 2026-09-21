import 'package:equatable/equatable.dart';
import '../../../highlights/domain/entities/introduced_peer_entity.dart';
import '../../../home/domain/entities/timeline_item_entity.dart';
import '../../../profile/domain/entities/profile_entity.dart';

enum PeerProfileStatus { initial, loading, success, failure }

class PeerProfileState extends Equatable {
  final PeerProfileStatus status;
  final ProfileEntity? profile;
  final List<TimelineItemEntity> posts;
  final List<IntroducedPeerEntity> introducedPeers;
  final bool isPostsLoading;
  final bool isIntroducedPeersLoading;
  final bool isActionLoading;
  final String? errorMessage;
  final int postsPage;
  final bool hasMorePosts;
  final bool isLoadingMorePosts;
  final bool isBlocked;
  final bool isBlockLoading;

  const PeerProfileState({
    this.status = PeerProfileStatus.initial,
    this.profile,
    this.posts = const [],
    this.introducedPeers = const [],
    this.isPostsLoading = false,
    this.isIntroducedPeersLoading = false,
    this.isActionLoading = false,
    this.errorMessage,
    this.postsPage = 1,
    this.hasMorePosts = false,
    this.isLoadingMorePosts = false,
    this.isBlocked = false,
    this.isBlockLoading = false,
  });

  PeerProfileState copyWith({
    PeerProfileStatus? status,
    ProfileEntity? profile,
    List<TimelineItemEntity>? posts,
    List<IntroducedPeerEntity>? introducedPeers,
    bool? isPostsLoading,
    bool? isIntroducedPeersLoading,
    bool? isActionLoading,
    String? errorMessage,
    int? postsPage,
    bool? hasMorePosts,
    bool? isLoadingMorePosts,
    bool? isBlocked,
    bool? isBlockLoading,
  }) {
    return PeerProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      posts: posts ?? this.posts,
      introducedPeers: introducedPeers ?? this.introducedPeers,
      isPostsLoading: isPostsLoading ?? this.isPostsLoading,
      isIntroducedPeersLoading:
          isIntroducedPeersLoading ?? this.isIntroducedPeersLoading,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      postsPage: postsPage ?? this.postsPage,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
      isLoadingMorePosts: isLoadingMorePosts ?? this.isLoadingMorePosts,
      isBlocked: isBlocked ?? this.isBlocked,
      isBlockLoading: isBlockLoading ?? this.isBlockLoading,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        posts,
        introducedPeers,
        isPostsLoading,
        isIntroducedPeersLoading,
        isActionLoading,
        errorMessage,
        postsPage,
        hasMorePosts,
        isLoadingMorePosts,
        isBlocked,
        isBlockLoading,
      ];
}
