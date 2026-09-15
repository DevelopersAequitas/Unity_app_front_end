import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/highlight_section.dart';
import '../bloc/highlights_bloc.dart';
import '../bloc/highlights_event.dart';
import '../bloc/highlights_state.dart';
import '../widgets/highlights_bottom_banner.dart';
import '../widgets/highlights_sections_grid.dart';

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({super.key});

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<HighlightsBloc>();
    if (bloc.state.status == HighlightsStatus.initial) {
      bloc.add(const HighlightsFetchRequested());
    }
  }

  void _onSectionTap(HighlightSection item) {
    AppSnackBar.showInfo(context, '${item.title} section coming soon');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HighlightsBloc, HighlightsState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != null && prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        return RefreshIndicator(
          color: AppColor.primaryBlue,
          onRefresh: () async {
            context.read<HighlightsBloc>().add(const HighlightsRefreshRequested());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildBody(state),
                const SizedBox(height: 16),
                const HighlightsBottomBanner(),
                SizedBox(height: 24 + MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(HighlightsState state) {
    if (state.status == HighlightsStatus.loading && state.allSections.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (state.status == HighlightsStatus.failure && state.allSections.isEmpty) {
      return _buildErrorState();
    }

    if (state.filteredSections.isEmpty) {
      return _buildEmptySearchState();
    }

    return HighlightsSectionsGrid(
      sections: state.filteredSections,
      onSectionTap: _onSectionTap,
    );
  }

  Widget _buildEmptySearchState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 36,
              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              'No sections found',
              style: AppTypography.titleMedium.copyWith(
                color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 36, color: AppColor.error),
            const SizedBox(height: 8),
            Text(
              'Failed to load highlights',
              style: AppTypography.titleMedium.copyWith(color: AppColor.error),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                context.read<HighlightsBloc>().add(const HighlightsFetchRequested());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
