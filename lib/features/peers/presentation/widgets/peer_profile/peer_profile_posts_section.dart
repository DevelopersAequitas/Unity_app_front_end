import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/features/home/domain/entities/timeline_item_entity.dart';
import 'package:unity_app/features/home/presentation/widgets/timeline_card.dart';
import 'package:unity_app/features/profile/domain/entities/profile_entity.dart';

class PeerProfilePostsSection extends StatelessWidget {
  final ProfileEntity profile;
  final List<TimelineItemEntity> posts;
  final bool isLoading;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final ValueChanged<String>? onLikeTap;
  final ValueChanged<String>? onSaveTap;

  const PeerProfilePostsSection({
    super.key,
    required this.profile,
    required this.posts,
    this.isLoading = false,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.onLoadMore,
    this.onLikeTap,
    this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    final count = posts.isNotEmpty ? posts.length : profile.postsCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.article_outlined, size: 18, color: AppColor.primaryBlue),
              const SizedBox(width: 8),
              Text('Posts ($count)', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColor.lightTextPrimary)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (isLoading && posts.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColor.lightSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColor.lightBorder),
            ),
            child: const Center(
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue)),
            ),
          )
        else if (posts.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColor.lightSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColor.lightBorder),
            ),
            child: const Center(
              child: Text('No posts published yet', style: TextStyle(fontSize: 12, color: AppColor.lightTextSecondary)),
            ),
          )
        else ...[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: posts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final post = posts[index];
              return TimelineCard(
                item: post,
                autoPlay: false,
                onLikeTap: () => onLikeTap?.call(post.id),
                onSaveTap: () => onSaveTap?.call(post.id),
              );
            },
          ),
          if (hasMore) ...[
            const SizedBox(height: 12),
            Center(
              child: isLoadingMore
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue))
                  : TextButton(
                      onPressed: onLoadMore,
                      child: const Text('Load More Posts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColor.primaryBlue)),
                    ),
            ),
          ],
        ],
      ],
    );
  }
}
