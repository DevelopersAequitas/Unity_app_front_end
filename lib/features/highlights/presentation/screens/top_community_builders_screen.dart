import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/top_builders/top_builders_bloc.dart';
import '../bloc/top_builders/top_builders_event.dart';
import '../bloc/top_builders/top_builders_state.dart';
import '../widgets/introduced_peer_tile.dart';
import '../widgets/top_builder_tile.dart';
import '../widgets/top_builders_bottom_nav.dart';

class TopCommunityBuildersScreen extends StatefulWidget {
  final int initialTabIndex;

  const TopCommunityBuildersScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<TopCommunityBuildersScreen> createState() =>
      _TopCommunityBuildersScreenState();
}

class _TopCommunityBuildersScreenState
    extends State<TopCommunityBuildersScreen> {
  final TextEditingController _searchController = TextEditingController();
  late int _activeTab;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchClose() {
    _searchController.clear();
    context.read<TopBuildersBloc>().add(
      const SearchIntroducedPeersEvent(query: ''),
    );
    setState(() => _isSearching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: _activeTab == 0 ? 'Top Community Builders' : 'My Invites',
        showBack: Navigator.canPop(context),
        showSearch: true,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: _activeTab == 0
            ? 'Search builders by name, role...'
            : 'Search invites...',
        onSearchTap: () => setState(() => _isSearching = true),
        onSearchChanged: (val) => context.read<TopBuildersBloc>().add(
          SearchIntroducedPeersEvent(query: val),
        ),
        onSearchClose: _onSearchClose,
        showNotifications: false,
        showProfile: false,
        showChat: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded, size: 20),
            tooltip: 'Add Invite',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addReferral),
          ),
        ],
        onProfileTap: () => Navigator.pushNamed(context, AppRoutes.profile),
        onBackTap: Navigator.canPop(context)
            ? () => Navigator.pop(context)
            : null,
      ),
      bottomNavigationBar: TopBuildersBottomNav(
        activeIndex: _activeTab,
        onIndexChanged: (idx) => setState(() => _activeTab = idx),
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocBuilder<TopBuildersBloc, TopBuildersState>(
            builder: (context, state) {
              if (state.status == TopBuildersStatus.loading &&
                  state.topBuilders.isEmpty) {
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                );
              }

              if (state.status == TopBuildersStatus.failure &&
                  state.topBuilders.isEmpty) {
                return _buildError(context, state.errorMessage);
              }

              return IndexedStack(
                index: _activeTab,
                children: [
                  _buildLeaderboardTab(context, state),
                  _buildMyIntroductionsTab(context, state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardTab(BuildContext context, TopBuildersState state) {
    final list = state.filteredTopBuilders;
    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async => context.read<TopBuildersBloc>().add(
        const FetchTopBuildersDataEvent(isRefresh: true),
      ),
      child: list.isEmpty
          ? _buildEmpty(
              state.searchQuery.isNotEmpty
                  ? 'No community builders match search'
                  : 'No community builders found',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: list.length,
              itemBuilder: (context, index) =>
                  TopBuilderTile(builder: list[index]),
            ),
    );
  }

  Widget _buildMyIntroductionsTab(
    BuildContext context,
    TopBuildersState state,
  ) {
    final list = state.filteredMyIntroduced;
    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async => context.read<TopBuildersBloc>().add(
        const FetchTopBuildersDataEvent(isRefresh: true),
      ),
      child: list.isEmpty
          ? _buildEmpty(
              state.searchQuery.isNotEmpty
                  ? 'No introduced peers match search'
                  : 'No introduced peers yet',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: list.length,
              itemBuilder: (context, index) =>
                  IntroducedPeerTile(peer: list[index]),
            ),
    );
  }

  Widget _buildEmpty(String text) {
    return ListView(
      children: [
        const SizedBox(height: 60),
        Center(
          child: Text(
            text,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColor.lightTextSecondary,
            ),
          ),
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
            const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: AppColor.error,
            ),
            const SizedBox(height: 12),
            Text(
              message ?? 'Failed to load data',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.read<TopBuildersBloc>().add(
                const FetchTopBuildersDataEvent(),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
