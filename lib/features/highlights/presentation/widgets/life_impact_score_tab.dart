import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/life_impact/life_impact_bloc.dart';
import '../bloc/life_impact/life_impact_event.dart';
import '../bloc/life_impact/life_impact_state.dart';
import 'life_impact_filter_bar.dart';
import 'life_impact_hero_card.dart';
import 'life_impact_tile.dart';

class LifeImpactScoreTab extends StatelessWidget {
  final LifeImpactState state;

  const LifeImpactScoreTab({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.status == LifeImpactStatus.loading && state.history.isEmpty) {
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue),
        ),
      );
    }

    if (state.status == LifeImpactStatus.failure && state.history.isEmpty) {
      return _buildError(context, state.errorMessage);
    }

    final filteredItems = state.filteredHistory;

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async => context
          .read<LifeImpactBloc>()
          .add(const FetchLifeImpactHistoryEvent(isRefresh: true)),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
        children: [
          LifeImpactHeroCard(
            totalScore: state.totalScore,
            activitiesCount: state.history.length,
          ),
          const SizedBox(height: 12),
          LifeImpactFilterBar(
            selectedFilter: state.selectedFilter,
            onFilterChanged: (filter) =>
                context.read<LifeImpactBloc>().add(ChangeLifeImpactFilterEvent(filter)),
          ),
          const SizedBox(height: 12),
          Text(
            'Impact History',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          if (filteredItems.isEmpty)
            _buildEmpty()
          else
            ...filteredItems.map((item) => LifeImpactTile(key: ValueKey(item.id), item: item)),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.bolt_outlined, size: 36, color: AppColor.lightTextSecondary),
          const SizedBox(height: 8),
          Text(
            'No impact activities found for this filter',
            style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 36, color: AppColor.error),
            const SizedBox(height: 10),
            Text(
              message ?? 'Failed to load impact history',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            TextButton(
              onPressed: () =>
                  context.read<LifeImpactBloc>().add(const FetchLifeImpactHistoryEvent()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
