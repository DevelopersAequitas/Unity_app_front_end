import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/circle_join_request_entity.dart';
import 'my_request_card.dart';

class MyRequestsView extends StatelessWidget {
  final List<CircleJoinRequestEntity> requests;
  final String searchQuery;
  final ValueChanged<CircleJoinRequestEntity> onRequestTap;
  final VoidCallback onExploreTap;

  const MyRequestsView({
    super.key,
    required this.requests,
    required this.searchQuery,
    required this.onRequestTap,
    required this.onExploreTap,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return _buildEmptyState(context);
    }

    return SliverList.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return MyRequestCard(
          request: request,
          onTap: () => onRequestTap(request),
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
                isSearching ? Icons.search_off_rounded : Icons.pending_actions_outlined,
                size: 44,
                color: isDark ? AppColor.darkTextDisabled : AppColor.lightTextDisabled,
              ),
              const SizedBox(height: 12),
              Text(
                isSearching
                    ? 'No requests matching "$searchQuery"'
                    : 'No join requests yet',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                isSearching
                    ? 'Try searching with another circle name or status keyword'
                    : 'Explore circle categories and submit a request to connect with peers in your field.',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onExploreTap,
                icon: const Icon(Icons.explore_outlined, size: 16),
                label: const Text('Join a Circle'),
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
