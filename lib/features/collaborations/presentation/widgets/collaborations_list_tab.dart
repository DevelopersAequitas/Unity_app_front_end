import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../bloc/collaborations_bloc.dart';
import '../bloc/collaborations_event.dart';
import '../bloc/collaborations_state.dart';
import '../screens/collaboration_detail_screen.dart';
import 'collaboration_card.dart';

class CollaborationsListTab extends StatelessWidget {
  final bool isHistoryOnly;
  final String statusFilter; // 'all', 'open', 'completed'
  final String searchQuery;
  final VoidCallback? onPostTap;

  const CollaborationsListTab({
    super.key,
    this.isHistoryOnly = false,
    this.statusFilter = 'all',
    this.searchQuery = '',
    this.onPostTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CollaborationsBloc, CollaborationsState>(
      builder: (context, state) {
        if (state.status == CollaborationsStatus.loading && state.collaborations.isEmpty) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        final profileState = context.read<ProfileBloc>().state;
        final currentUserId = profileState.profile?.id;

        // 1. Filter by history / user
        var items = isHistoryOnly
            ? state.collaborations.where((c) => c.user.id == currentUserId).toList()
            : state.collaborations;

        // 2. Filter by status
        if (statusFilter == 'open') {
          items = items.where((c) => c.isIncomplete).toList();
        } else if (statusFilter == 'completed') {
          items = items.where((c) => c.isCompleted).toList();
        }

        // 3. Filter by search query
        if (searchQuery.trim().isNotEmpty) {
          final query = searchQuery.trim().toLowerCase();
          items = items.where((c) {
            final titleMatch = c.title.toLowerCase().contains(query);
            final descMatch = c.description.toLowerCase().contains(query);
            final userMatch = c.user.name.toLowerCase().contains(query);
            final cityMatch = c.user.city.toLowerCase().contains(query);
            final typeMatch = c.collaborationType.label.toLowerCase().contains(query);
            final indMatch = c.industry?.label.toLowerCase().contains(query) ?? false;
            return titleMatch || descMatch || userMatch || cityMatch || typeMatch || indMatch;
          }).toList();
        }

        if (items.isEmpty) {
          return _buildEmptyState(context, isDark);
        }

        return RefreshIndicator(
          color: AppColor.primaryBlue,
          onRefresh: () async => context.read<CollaborationsBloc>().add(const FetchCollaborationHistoryEvent()),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100), // Bottom padding for bottom nav & FAB
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              final item = items[index];
              return CollaborationCard(
                collaboration: item,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<CollaborationsBloc>(),
                        child: CollaborationDetailScreen(collaboration: item),
                      ),
                    ),
                  );
                },
                onAccept: (!isHistoryOnly && item.isIncomplete && item.user.id != currentUserId)
                    ? () => context.read<CollaborationsBloc>().add(AcceptCollaborationEvent(item.id))
                    : null,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    final textSecondary = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final textTertiary = isDark ? AppColor.darkTextTertiary : AppColor.lightTextTertiary;

    String emptyTitle;
    String emptySubtitle;

    if (searchQuery.trim().isNotEmpty) {
      emptyTitle = 'No matching collaborations';
      emptySubtitle = 'Try searching with a different keyword';
    } else if (statusFilter == 'completed') {
      emptyTitle = isHistoryOnly ? 'No completed asks yet' : 'No completed collaborations found';
      emptySubtitle = 'Completed collaborations will appear here.';
    } else if (statusFilter == 'open') {
      emptyTitle = isHistoryOnly ? 'No open asks right now' : 'No open opportunities right now';
      emptySubtitle = isHistoryOnly
          ? 'Post a collaboration ask to start connecting with peers.'
          : 'Check back soon or post your own collaboration opportunity.';
    } else {
      emptyTitle = isHistoryOnly ? 'No submitted collaborations yet' : 'No collaborations found';
      emptySubtitle = isHistoryOnly
          ? 'Post a collaboration ask to connect with peers globally.'
          : 'Explore peer collaborations or create your own opportunity.';
    }

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async => context.read<CollaborationsBloc>().add(const FetchCollaborationHistoryEvent()),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.18),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.handshake_outlined,
                      size: 36,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    emptyTitle,
                    style: AppTypography.titleSmall.copyWith(
                      color: textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    emptySubtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (onPostTap != null) ...[
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: onPostTap,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Post Collaboration Ask'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.primaryBlue,
                        side: const BorderSide(color: AppColor.primaryBlue),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
