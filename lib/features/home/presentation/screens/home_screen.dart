import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/core/router/app_router.dart';
import '../../../peers/presentation/bloc/peers_bloc.dart';
import '../../../peers/presentation/bloc/peers_event.dart';
import '../../../peers/presentation/bloc/peers_state.dart';
import '../../../peers/presentation/screens/my_peers_screen.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/create_action_sheet.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../widgets/home_brand_partners_section.dart';
import '../widgets/home_metric_cards.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/home_skeleton_loader.dart';
import '../widgets/home_timeline_header.dart';
import '../widgets/timeline_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  int _currentNavIndex = 0;
  bool _isSearching = false;

  static const _tabTitles = ['Home', 'Peers', '', 'Circles', 'Highlights'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Initial fetch for Home feed
    final homeBloc = context.read<HomeBloc>();
    if (homeBloc.state.status == HomeFeedStatus.initial) {
      homeBloc.add(const HomeFeedFetchRequested());
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= (maxScroll - 300)) {
      final homeBloc = context.read<HomeBloc>();
      if (!homeBloc.state.isLoadingMore && homeBloc.state.pagination.hasMore) {
        homeBloc.add(const HomeFeedLoadMoreRequested());
      }
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (_currentNavIndex == 1) {
        context.read<PeersBloc>().add(PeersSearchChanged(query));
      }
    });
  }

  void _onSearchClose() {
    _debounceTimer?.cancel();
    _searchController.clear();
    setState(() => _isSearching = false);
    if (_currentNavIndex == 1) {
      context.read<PeersBloc>().add(const PeersSearchChanged(''));
    }
  }

  String get _currentTitle {
    if (_currentNavIndex == 2) return '';
    return _tabTitles[_currentNavIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: _currentTitle,
        showSearch: true,
        showNotifications: true,
        showProfile: true,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: _currentNavIndex == 1
            ? 'Search peers by name, company, city...'
            : 'Search...',
        onSearchTap: () => setState(() => _isSearching = true),
        onSearchChanged: _onSearchChanged,
        onSearchClose: _onSearchClose,
        onNotificationsTap: () {},
        onProfileTap: () {
          Navigator.of(context).pushNamed(AppRoutes.profile);
        },
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _currentNavIndex,
        onItemSelected: (index) {
          if (_isSearching) {
            _onSearchClose();
          }
          setState(() => _currentNavIndex = index);
          if (index == 1) {
            final peersBloc = context.read<PeersBloc>();
            if (peersBloc.state.status == PeersStatus.initial) {
              peersBloc.add(const PeersFetchRequested());
            }
          }
        },
        onCreateTap: () => CreateActionSheet.show(context),
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: IndexedStack(
            index: _currentNavIndex,
            children: [
              _buildHomeFeedTab(),
              const MyPeersScreen(),
              const SizedBox.shrink(),
              _buildComingSoonTab('Circles'),
              _buildComingSoonTab('Highlights'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeFeedTab() {
    return BlocConsumer<HomeBloc, HomeState>(
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
            context.read<HomeBloc>().add(const HomeFeedRefreshRequested());
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 16),
                  child: HomeMetricCards(),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: HomeQuickActions(),
                ),
              ),
              if (state.brandPartners.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: HomeBrandPartnersSection(
                      brandPartners: state.brandPartners,
                      onPartnerTap: (_) {},
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HomeTimelineHeader(
                    activeFilter: state.activeFilter,
                    onFilterTap: () {},
                  ),
                ),
              ),
              if (state.status == HomeFeedStatus.loading && state.items.isEmpty)
                const SliverToBoxAdapter(
                  child: HomeSkeletonLoader(),
                )
              else if (state.items.isEmpty)
                SliverToBoxAdapter(
                  child: _buildEmptyFeedState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      final item = state.items[index];
                      return TimelineCard(
                        item: item,
                        autoPlay: _currentNavIndex == 0,
                        onLikeTap: () {
                          context.read<HomeBloc>().add(
                            HomePostLikeToggled(
                              postId: item.id,
                              isCurrentlyLiked: item.isLikedByMe,
                            ),
                          );
                        },
                        onSaveTap: () {
                          context.read<HomeBloc>().add(
                            HomePostSaveToggled(
                              postId: item.id,
                              isCurrentlySaved: item.isSaved,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 24 + MediaQuery.of(context).padding.bottom,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyFeedState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.dynamic_feed_outlined,
              size: 36,
              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              'No activity yet',
              style: AppTypography.titleMedium.copyWith(
                color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComingSoonTab(String name) {
    return Center(
      child: Text(
        '$name Coming Soon',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColor.lightTextSecondary,
        ),
      ),
    );
  }
}
