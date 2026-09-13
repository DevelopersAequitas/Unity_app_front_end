import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/circle_entity.dart';
import 'my_circle_card.dart';

class MyCirclesView extends StatelessWidget {
  final List<CircleEntity> circles;
  final String searchQuery;
  final ValueChanged<CircleEntity> onCircleTap;
  final VoidCallback onExploreTap;

  const MyCirclesView({
    super.key,
    required this.circles,
    required this.searchQuery,
    required this.onCircleTap,
    required this.onExploreTap,
  });

  @override
  Widget build(BuildContext context) {
    if (circles.isEmpty) {
      return _buildEmptyState(context);
    }

    return SliverList.builder(
      itemCount: circles.length,
      itemBuilder: (context, index) {
        final circle = circles[index];
        return MyCircleCard(
          circle: circle,
          onTap: () => onCircleTap(circle),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSearching = searchQuery.trim().isNotEmpty;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSearching ? Icons.search_off_rounded : Icons.bubble_chart_outlined,
                size: 44,
                color: isDark ? AppColor.darkTextDisabled : AppColor.lightTextDisabled,
              ),
              const SizedBox(height: 12),
              Text(
                isSearching
                    ? 'No circles matching "$searchQuery"'
                    : 'You have not joined any circles yet',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                isSearching
                    ? 'Try searching with another keyword or explore categories'
                    : 'Discover and join industry & interest-specific circles to connect with peers.',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onExploreTap,
                icon: const Icon(Icons.explore_outlined, size: 16),
                label: const Text('Explore Circles'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.primaryBlue,
                  side: const BorderSide(color: AppColor.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
