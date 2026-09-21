import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/leadership_certification_result_entity.dart';
import 'leadership_submission_item_card.dart';

class LeadershipSubmissionsHistoryTab extends StatelessWidget {
  final List<LeadershipCertificationResultEntity> submissions;
  final bool isLoading;
  final int currentPage;
  final int lastPage;
  final Future<void> Function() onRefresh;
  final ValueChanged<int> onLoadMore;
  final ValueChanged<LeadershipCertificationResultEntity> onViewCertificate;
  final VoidCallback onRetake;

  const LeadershipSubmissionsHistoryTab({
    super.key,
    required this.submissions,
    required this.isLoading,
    required this.currentPage,
    required this.lastPage,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onViewCertificate,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && submissions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (submissions.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 60),
            Icon(
              Icons.history_toggle_off_rounded,
              size: 56,
              color: AppColor.lightTextSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No submissions found',
              textAlign: TextAlign.center,
              style: AppTypography.titleSmall.copyWith(
                color: AppColor.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    final hasApprovedAny = submissions.any((s) {
      final status = s.status.toLowerCase();
      return status == 'approved' || status == 'passed' || status == 'success';
    });

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 100 &&
              !isLoading &&
              currentPage < lastPage) {
            onLoadMore(currentPage + 1);
          }
          return false;
        },
        child: ListView.separated(
          padding: const EdgeInsets.all(14),
          itemCount: submissions.length + (currentPage < lastPage ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            if (index == submissions.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            return LeadershipSubmissionItemCard(
              item: submissions[index],
              canRetake: !hasApprovedAny,
              onViewCertificate: onViewCertificate,
              onRetake: onRetake,
            );
          },
        ),
      ),
    );
  }
}
