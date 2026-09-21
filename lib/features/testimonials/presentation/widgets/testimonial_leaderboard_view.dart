import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/testimonials_bloc.dart';
import '../bloc/testimonials_event.dart';
import '../bloc/testimonials_state.dart';
import 'testimonial_leaderboard_tile.dart';

class TestimonialLeaderboardView extends StatelessWidget {
  const TestimonialLeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestimonialsBloc, TestimonialsState>(
      builder: (context, state) {
        final list = state.filteredLeaderboardList;
        final isLoading = state.leaderboardStatus == TestimonialsStatus.loading && list.isEmpty;

        if (isLoading) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue),
            ),
          );
        }

        if (state.leaderboardStatus == TestimonialsStatus.failure && list.isEmpty) {
          return _buildError(context, state.errorMessage);
        }

        return RefreshIndicator(
          color: AppColor.primaryBlue,
          onRefresh: () async => context
              .read<TestimonialsBloc>()
              .add(const TestimonialsFetchLeaderboardRequested(forceRefresh: true)),
          child: list.isEmpty
              ? _buildEmpty(state.searchQuery.isNotEmpty
                  ? 'No testimonial leaders match search'
                  : 'No testimonial leaders yet')
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: list.length,
                  itemBuilder: (context, index) =>
                      TestimonialLeaderboardTile(item: list[index]),
                ),
        );
      },
    );
  }

  Widget _buildEmpty(String text) {
    return ListView(
      children: [
        const SizedBox(height: 60),
        Center(
          child: Text(text, style: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextSecondary)),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40, color: AppColor.error),
            const SizedBox(height: 12),
            Text(message ?? 'Failed to load leaderboard', style: AppTypography.bodyMedium),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context
                  .read<TestimonialsBloc>()
                  .add(const TestimonialsFetchLeaderboardRequested(forceRefresh: true)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
