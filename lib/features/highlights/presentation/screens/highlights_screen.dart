import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../bloc/highlights_bloc.dart';
import '../bloc/highlights_event.dart';
import '../bloc/highlights_state.dart';
import '../widgets/highlights_bottom_banner.dart';
import '../widgets/highlights_navigation_handler.dart';
import '../widgets/highlights_sections_grid.dart';
import 'welcome_creative_template_screen.dart';

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({super.key});

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<HighlightsBloc>();
    if (bloc.state.status == HighlightsStatus.initial) {
      bloc.add(const HighlightsFetchRequested());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    context.read<HighlightsBloc>().add(HighlightsSearchChanged(query));
  }

  void _onSearchClose() {
    setState(() => _isSearching = false);
    _searchController.clear();
    context.read<HighlightsBloc>().add(const HighlightsSearchChanged(''));
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
        return PopScope(
          canPop: !_isSearching,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && _isSearching) {
              _onSearchClose();
            }
          },
          child: AppGradientBackground(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppCommonBar(
                title: 'Highlights',
                showBack: Navigator.canPop(context),
                onBackTap: Navigator.canPop(context)
                    ? () => Navigator.pop(context)
                    : null,
                showSearch: true,
                showChat: true,
                showNotifications: true,
                showProfile: true,
                isSearching: _isSearching,
                searchController: _searchController,
                searchHint: 'Search features, actions, services...',
                onSearchTap: () => setState(() => _isSearching = true),
                onSearchChanged: _onSearchChanged,
                onSearchClose: _onSearchClose,
                onNotificationsTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.notifications);
                },
                onProfileTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.profile);
                },
              ),
              body: RefreshIndicator(
                color: AppColor.primaryBlue,
                onRefresh: () async => context
                    .read<HighlightsBloc>()
                    .add(const HighlightsRefreshRequested()),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildBody(state),
                      const SizedBox(height: 8),
                      HighlightsBottomBanner(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const WelcomeCreativeTemplateScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 24 + MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ),
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
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5),
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
      isSearching: _isSearching,
      onSectionTap: (item) =>
          HighlightsNavigationHandler.handleTap(context, item),
    );
  }

  Widget _buildEmptySearchState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                ),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 32,
                color: isDark
                    ? AppColor.darkTextSecondary
                    : AppColor.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No sections found',
              style: AppTypography.titleMedium.copyWith(
                color: isDark
                    ? AppColor.darkTextPrimary
                    : AppColor.lightTextPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try a different keyword or search query',
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColor.darkTextSecondary
                    : AppColor.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (_isSearching) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _onSearchClose,
                icon: const Icon(Icons.clear_all_rounded, size: 18),
                label: const Text('Clear Search'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.primaryBlue,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return AppErrorView(
      title: 'Unable to Load Highlights',
      onRetry: () =>
          context.read<HighlightsBloc>().add(const HighlightsFetchRequested()),
      screenName: 'Highlights',
    );
  }
}
