import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../home/presentation/widgets/timeline_card.dart';
import '../bloc/profile_posts_bloc.dart';
import '../bloc/profile_posts_event.dart';
import '../bloc/profile_posts_state.dart';

class ProfilePostsTab extends StatelessWidget {
  final ScrollController? scrollController;

  const ProfilePostsTab({
    super.key,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePostsBloc, ProfilePostsState>(
      builder: (context, state) {
        if (state.status == ProfilePostsStatus.loading && state.posts.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (state.status == ProfilePostsStatus.failure && state.posts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl, horizontal: AppSpacing.lg),
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 40,
                  color: AppColor.textTertiary,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  state.errorMessage ?? 'Failed to load posts',
                  style: AppTypography.bodySmall.copyWith(color: AppColor.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton(
                  onPressed: () {
                    context.read<ProfilePostsBloc>().add(const ProfilePostsFetchRequested());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.posts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl, horizontal: AppSpacing.lg),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColor.backgroundSubtle,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.post_add_rounded,
                    size: 36,
                    color: AppColor.textTertiary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'No posts yet',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColor.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Share your thoughts, business updates and insights with the community.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColor.textTertiary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          itemCount: state.posts.length + (state.hasMore ? 1 : 0),
          separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            if (index == state.posts.length) {
              if (state.isLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              }
              return Center(
                child: TextButton(
                  onPressed: () {
                    context.read<ProfilePostsBloc>().add(const ProfilePostsLoadMoreRequested());
                  },
                  child: const Text('Load More'),
                ),
              );
            }

            final post = state.posts[index];
            return TimelineCard(
              item: post,
              autoPlay: false,
              onLikeTap: () {
                context.read<ProfilePostsBloc>().add(ProfilePostLikeToggled(post.id));
              },
              onSaveTap: () {
                context.read<ProfilePostsBloc>().add(ProfilePostSaveToggled(post.id));
              },
            );
          },
        );
      },
    );
  }
}
