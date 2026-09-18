import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/post_ask/post_ask_bloc.dart';
import '../bloc/post_ask/post_ask_event.dart';
import '../bloc/post_ask/post_ask_state.dart';
import 'my_ask_card.dart';

class MyAsksListView extends StatelessWidget {
  const MyAsksListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<PostAskBloc, PostAskState>(
      builder: (context, state) {
        if (state.status == PostAskStatus.loading && state.asks.isEmpty) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        final asks = state.filteredAsks;

        return RefreshIndicator(
          color: AppColor.primaryBlue,
          onRefresh: () async => context.read<PostAskBloc>().add(const FetchMyAsksEvent()),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              _buildFilterChips(context, state, isDark),
              const SizedBox(height: 12),
              if (asks.isEmpty)
                _buildEmptyView(isDark)
              else
                ...asks.map((ask) => MyAskCard(
                      ask: ask,
                      onComplete: ask.isOpen
                          ? () => context.read<PostAskBloc>().add(CompleteAskEvent(ask.id, subject: ask.subject))
                          : null,
                    )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChips(BuildContext context, PostAskState state, bool isDark) {
    return Row(
      children: [
        _chip(context, 'All (${state.asks.length})', 'all', state.activeFilter, isDark),
        const SizedBox(width: 8),
        _chip(context, 'Open (${state.openCount})', 'open', state.activeFilter, isDark),
        const SizedBox(width: 8),
        _chip(context, 'Completed (${state.completedCount})', 'completed', state.activeFilter, isDark),
      ],
    );
  }

  Widget _chip(BuildContext context, String label, String value, String active, bool isDark) {
    final isSelected = active == value;
    return InkWell(
      onTap: () => context.read<PostAskBloc>().add(FilterAsksEvent(value)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryBlue
              : (isDark ? AppColor.darkSurface : AppColor.lightSurface),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColor.primaryBlue : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? Colors.white : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.assignment_outlined, size: 48, color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
            const SizedBox(height: 12),
            Text(
              'No Asks found',
              style: AppTypography.titleMedium.copyWith(
                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Post your requirements to collaborate with peers',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
