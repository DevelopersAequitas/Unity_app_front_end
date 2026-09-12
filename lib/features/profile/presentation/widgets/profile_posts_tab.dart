import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/presentation/widgets/timeline_card.dart';
import '../bloc/profile_posts_bloc.dart';
import '../bloc/profile_posts_event.dart';
import '../bloc/profile_posts_state.dart';

class ProfilePostsTab extends StatelessWidget {
  final ScrollController? scrollController;

  const ProfilePostsTab({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePostsBloc, ProfilePostsState>(
      builder: (context, state) {
        if (state.status == ProfilePostsStatus.loading && state.posts.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (state.status == ProfilePostsStatus.failure && state.posts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              children: [
                const Icon(Icons.error_outline_rounded, size: 36, color: AppColor.lightTextTertiary),
                const SizedBox(height: 8),
                Text(
                  state.errorMessage ?? 'Failed to load posts',
                  style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.read<ProfilePostsBloc>().add(const ProfilePostsFetchRequested()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state.posts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              children: [
                const Icon(Icons.post_add_outlined, size: 36, color: AppColor.lightTextTertiary),
                const SizedBox(height: 8),
                Text(
                  'No posts yet',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColor.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Share your business updates and insights with the community.',
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
                  onPressed: () => context.read<ProfilePostsBloc>().add(const ProfilePostsLoadMoreRequested()),
                  child: const Text('Load More'),
                ),
              );
            }
            final post = state.posts[index];
            return TimelineCard(
              item: post,
              autoPlay: false,
              onLikeTap: () => context.read<ProfilePostsBloc>().add(ProfilePostLikeToggled(post.id)),
              onSaveTap: () => context.read<ProfilePostsBloc>().add(ProfilePostSaveToggled(post.id)),
            );
          },
        );
      },
    );
  }
}
