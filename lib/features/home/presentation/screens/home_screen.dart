import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/core/router/app_router.dart';
import '../../../peers/presentation/bloc/peers_bloc.dart';
import '../../../peers/presentation/bloc/peers_event.dart';
import '../../../peers/presentation/bloc/peers_state.dart';
import '../../../peers/presentation/screens/my_peers_screen.dart';
import '../../../profile/presentation/bloc/profile_posts_bloc.dart';
import '../../../profile/presentation/bloc/profile_posts_event.dart';
import '../../../circles/presentation/bloc/circles_bloc.dart';
import '../../../circles/presentation/bloc/circles_event.dart';
import '../../../circles/presentation/bloc/circles_state.dart';
import '../../../circles/presentation/screens/circles_screen.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
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
      if (_currentNavIndex == 0) {
        context.read<HomeBloc>().add(HomeSearchChanged(query));
      } else if (_currentNavIndex == 1) {
        context.read<PeersBloc>().add(PeersSearchChanged(query));
      } else if (_currentNavIndex == 3) {
        context.read<CirclesBloc>().add(CirclesSearchChanged(query));
      }
    });
  }

  void _onSearchClose() {
    _debounceTimer?.cancel();
    _searchController.clear();
    setState(() => _isSearching = false);
    // Clear search in current tab
    if (_currentNavIndex == 0) {
      context.read<HomeBloc>().add(const HomeSearchChanged(''));
    } else if (_currentNavIndex == 1) { 
      context.read<PeersBloc>().add(const PeersSearchChanged(''));
    } else if (_currentNavIndex == 3) {
      context.read<CirclesBloc>().add(const CirclesSearchChanged(''));
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
            : (_currentNavIndex == 3
                ? 'Search circles by name, category, city...'
                : 'Search posts by name, content, category...'),
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
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: _currentNavIndex,
        onItemSelected: (index) {
          // Don't close search on tab switch — clear search query for old tab first
          if (_isSearching && index != _currentNavIndex) {
            _debounceTimer?.cancel();
            _searchController.clear();
            // Clear old tab's search
            if (_currentNavIndex == 0) {
              context.read<HomeBloc>().add(const HomeSearchChanged(''));
            } else if (_currentNavIndex == 1) {
              context.read<PeersBloc>().add(const PeersSearchChanged(''));
            } else if (_currentNavIndex == 3) {
              context.read<CirclesBloc>().add(const CirclesSearchChanged(''));
            }
          }
          if (index == 0 && _currentNavIndex == 0) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
              );
            }
          }
          setState(() => _currentNavIndex = index);
          if (index == 1) {
            final peersBloc = context.read<PeersBloc>();
            if (peersBloc.state.status == PeersStatus.initial) {
              peersBloc.add(const PeersFetchRequested());
            }
          } else if (index == 3) {
            final circlesBloc = context.read<CirclesBloc>();
            if (circlesBloc.state.status == CirclesStatus.initial) {
              circlesBloc.add(const CirclesFetchRequested());
            }
          }
        },
        onCreateTap: () => CreateActionSheet.show(context),
      ),
      floatingActionButton: _currentNavIndex == 0
          ? _buildCreatePostFloatingButton(context)
          : null,
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: IndexedStack(
            index: _currentNavIndex,
            children: [
              _buildHomeFeedTab(),
              const MyPeersScreen(),
              const SizedBox.shrink(),
              const CirclesScreen(),
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
              if (state.status == HomeFeedStatus.loading && state.allItems.isEmpty)
                const SliverToBoxAdapter(
                  child: HomeSkeletonLoader(),
                )
              else if (state.items.isEmpty && state.searchQuery.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildSearchEmptyState(state.searchQuery),
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
                        onAuthorTap: () {
                          final author = item.author;
                          final authorId = author?.id ?? '';
                          if (authorId.isEmpty) return;
                          // Skip system/org accounts (no company, designation or category)
                          final isSystemAccount = (author?.companyName == null || author!.companyName!.isEmpty) &&
                              (author!.designation == null || author.designation!.isEmpty) &&
                              (author.level4Category == null || author.level4Category!.isEmpty);
                          if (isSystemAccount) return;
                          // Determine if this is the current logged-in user
                          final authUser = context.read<AuthBloc>().state.user;
                          final myId = authUser?.id ?? '';
                          if (myId.isNotEmpty && authorId == myId) {
                            Navigator.of(context).pushNamed(AppRoutes.profile);
                          } else {
                            Navigator.of(context).pushNamed(
                              AppRoutes.peerProfile,
                              arguments: authorId,
                            );
                          }
                        },
                        onLikeTap: () {
                          final currentLiked = item.isLikedByMe;
                          final newLiked = !currentLiked;
                          final newCount = (item.likesCount + (newLiked ? 1 : -1)).clamp(0, 9999999);
                          context.read<HomeBloc>().add(
                            HomePostLikeToggled(
                              postId: item.id,
                              isCurrentlyLiked: currentLiked,
                            ),
                          );
                          try {
                            context.read<ProfilePostsBloc>().add(
                              ProfilePostLikeSyncRequested(
                                postId: item.id,
                                isLiked: newLiked,
                                likesCount: newCount,
                              ),
                            );
                          } catch (_) {}
                        },
                        onSaveTap: () {
                          final currentSaved = item.isSaved;
                          final newSaved = !currentSaved;
                          context.read<HomeBloc>().add(
                            HomePostSaveToggled(
                              postId: item.id,
                              isCurrentlySaved: currentSaved,
                            ),
                          );
                          try {
                            context.read<ProfilePostsBloc>().add(
                              ProfilePostSaveSyncRequested(
                                postId: item.id,
                                isSaved: newSaved,
                              ),
                            );
                          } catch (_) {}
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

  Widget _buildSearchEmptyState(String query) {
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
              'No results for "$query"',
              style: AppTypography.titleMedium.copyWith(
                color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () {
                _searchController.clear();
                context.read<HomeBloc>().add(const HomeSearchChanged(''));
              },
              child: const Text('Clear search'),
            ),
          ],
        ),
      ),
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

  Widget _buildCreatePostFloatingButton(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColor.brandGradient,
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryBlue.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.createPost),
          customBorder: const CircleBorder(),
          child: const Center(
            child: Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
