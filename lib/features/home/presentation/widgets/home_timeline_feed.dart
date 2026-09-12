import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/timeline_item_entity.dart';
import 'timeline_card.dart';

class HomeTimelineFeed extends StatelessWidget {
  final List<TimelineItemEntity> items;
  final bool isLoadingMore;
  final bool autoPlay;
  final void Function(String postId, bool isLiked)? onLikeTap;
  final void Function(String postId, bool isSaved)? onSaveTap;

  const HomeTimelineFeed({
    super.key,
    required this.items,
    required this.isLoadingMore,
    this.autoPlay = true,
    this.onLikeTap,
    this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.dynamic_feed_outlined,
                size: 36,
                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
              ),
              const SizedBox(height: 8),
              Text(
                'No activity yet',
                style: AppTypography.titleMedium.copyWith(
                  color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final item = items[index];
        return TimelineCard(
          item: item,
          autoPlay: autoPlay,
          onLikeTap: () => onLikeTap?.call(item.id, item.isLikedByMe),
          onSaveTap: () => onSaveTap?.call(item.id, item.isSaved),
        );
      },
    );
  }
}
