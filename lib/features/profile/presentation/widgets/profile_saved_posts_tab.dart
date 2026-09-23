import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_event.dart';
import '../../../home/presentation/widgets/post_comments_bottom_sheet.dart';
import '../../../home/presentation/widgets/timeline_card.dart';
import '../bloc/profile_posts_bloc.dart';
import '../bloc/profile_posts_event.dart';
import '../bloc/profile_saved_posts_bloc.dart';
import '../bloc/profile_saved_posts_event.dart';
import '../bloc/profile_saved_posts_state.dart';

class ProfileSavedPostsTab extends StatelessWidget {
  final ScrollController? scrollController;

  const ProfileSavedPostsTab({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSavedPostsBloc, ProfileSavedPostsState>(
      builder: (context, state) {
        if (state.status == ProfileSavedPostsStatus.loading && state.posts.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (state.status == ProfileSavedPostsStatus.failure && state.posts.isEmpty) {
          return AppErrorView(
            title: 'Unable to Load Saved Posts',
            message: state.errorMessage,
            onRetry: () => context
                .read<ProfileSavedPostsBloc>()
                .add(const ProfileSavedPostsFetchRequested()),
            screenName: 'Saved Posts',
            isCompact: true,
          );
        }

        if (state.posts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              children: [
                const Icon(Icons.bookmark_border_rounded, size: 36, color: AppColor.lightTextTertiary),
                const SizedBox(height: 8),
                Text(
                  'No saved posts yet',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColor.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Posts you bookmark will appear here for easy access.',
                  style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextTertiary, fontSize: 11.5),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.posts.length + (state.hasMore ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index == state.posts.length) {
              return Center(
                child: TextButton(
                  onPressed: () => context
                      .read<ProfileSavedPostsBloc>()
                      .add(const ProfileSavedPostsLoadMoreRequested()),
                  child: const Text('Load More'),
                ),
              );
            }
            final post = state.posts[index];
            return TimelineCard(
              item: post,
              autoPlay: false,
              onLikeTap: () {
                final currentLiked = post.isLikedByMe;
                final newLiked = !currentLiked;
                final newCount = (post.likesCount + (newLiked ? 1 : -1)).clamp(0, 9999999);
                context.read<ProfileSavedPostsBloc>().add(ProfileSavedPostLikeToggled(post.id));
                try {
                  context.read<HomeBloc>().add(
                        HomePostLikeSyncRequested(
                          postId: post.id,
                          isLiked: newLiked,
                          likesCount: newCount,
                        ),
                      );
                } catch (_) {}
                try {
                  context.read<ProfilePostsBloc>().add(
                        ProfilePostLikeSyncRequested(
                          postId: post.id,
                          isLiked: newLiked,
                          likesCount: newCount,
                        ),
                      );
                } catch (_) {}
              },
              onSaveTap: () {
                context.read<ProfileSavedPostsBloc>().add(ProfileSavedPostSaveToggled(post.id));
                try {
                  context.read<HomeBloc>().add(
                        HomePostSaveSyncRequested(
                          postId: post.id,
                          isSaved: false,
                        ),
                      );
                } catch (_) {}
                try {
                  context.read<ProfilePostsBloc>().add(
                        ProfilePostSaveSyncRequested(
                          postId: post.id,
                          isSaved: false,
                        ),
                      );
                } catch (_) {}
              },
              onCommentTap: () {
                PostCommentsBottomSheet.show(
                  context,
                  postId: post.id,
                  totalComments: post.commentsCount,
                  onCommentAdded: () {
                    context
                        .read<ProfileSavedPostsBloc>()
                        .add(ProfileSavedPostCommentCountIncremented(post.id));
                    try {
                      context
                          .read<ProfilePostsBloc>()
                          .add(ProfilePostCommentCountIncremented(post.id));
                    } catch (_) {}
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
