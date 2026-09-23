import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../bloc/peers_bloc.dart';
import '../bloc/peers_event.dart';
import '../bloc/peers_state.dart';
import '../widgets/peer_card.dart';
import '../widgets/peers_section_header.dart';
import '../widgets/peers_skeleton_loader.dart';
import '../widgets/peers_sort_bottom_sheet.dart';
import 'connections_screen.dart';
import 'matches_screen.dart';
import 'near_me_screen.dart';
import 'package:geolocator/geolocator.dart';
import '../bloc/near_me_bloc.dart';
import '../bloc/near_me_event.dart';
import 'peer_requests_screen.dart';

class MyPeersScreen extends StatefulWidget {
  final int initialTabIndex;
  const MyPeersScreen({super.key, this.initialTabIndex = 0});

  @override
  State<MyPeersScreen> createState() => _MyPeersScreenState();
}

class _MyPeersScreenState extends State<MyPeersScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late int _activeTab;
  late final Set<int> _visitedTabs;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTabIndex.clamp(0, 4);
    _visitedTabs = {_activeTab};
    _scrollController.addListener(_onScroll);
    final bloc = context.read<PeersBloc>();
    if (bloc.state.status == PeersStatus.initial) {
      bloc.add(const PeersFetchRequested());
    }
    if (_activeTab == 4) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNearMeSelection();
      });
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _activeTab = index;
      _visitedTabs.add(index);
    });
    if (index == 4) {
      _handleNearMeSelection();
    }
  }

  Future<void> _handleNearMeSelection() async {
    final bloc = context.read<NearMeBloc>();
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          AppSnackBar.showInfo(
            context,
            'Please enable GPS location services to find nearby peers.',
          );
        }
        bloc.add(const NearMeFetchRequested(refresh: true));
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever && mounted) {
        AppSnackBar.showError(
          context,
          'Location permission is permanently denied. Please enable it in app settings.',
        );
      }
    } catch (_) {
      // Fallback
    }
    if (mounted) {
      bloc.add(const NearMeFetchRequested(refresh: true));
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= (maxScroll - 300)) {
      final peersBloc = context.read<PeersBloc>();
      if (!peersBloc.state.isLoadingMore && peersBloc.state.hasMore) {
        peersBloc.add(const PeersLoadMoreRequested());
      }
    }
  }

  void _onSearchClose() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    context.read<PeersBloc>().add(const PeersSearchChanged(''));
  }

  String get _currentTitle {
    switch (_activeTab) {
      case 1:
        return 'Connections';
      case 2:
        return 'Requests';
      case 3:
        return 'Matches';
      case 4:
        return 'Nearby Peers';
      default:
        return 'All Peers';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: _currentTitle,
        showBack: Navigator.canPop(context),
        showSearch: _activeTab == 0,
        showChat: true,
        showNotifications: true,
        showProfile: true,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: 'Search peers by name, company, city...',
        onSearchTap: () => setState(() => _isSearching = true),
        onSearchClose: _onSearchClose,
        onSearchChanged: (query) {
          context.read<PeersBloc>().add(PeersSearchChanged(query));
        },
        onNotificationsTap: () {
          Navigator.of(context).pushNamed(AppRoutes.notifications);
        },
        onProfileTap: () {
          Navigator.of(context).pushNamed(AppRoutes.profile);
        },
        onBackTap: () => Navigator.of(context).pop(),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: IndexedStack(
            index: _activeTab,
            children: [
              _buildAllPeersTab(),
              _visitedTabs.contains(1)
                  ? const ConnectionsScreen(isTab: true)
                  : const SizedBox.shrink(),
              _visitedTabs.contains(2)
                  ? const PeerRequestsScreen(isTab: true)
                  : const SizedBox.shrink(),
              _visitedTabs.contains(3)
                  ? const MatchesScreen(isTab: true)
                  : const SizedBox.shrink(),
              _visitedTabs.contains(4)
                  ? const NearMeScreen(isTab: true)
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllPeersTab() {
    return BlocBuilder<PeersBloc, PeersState>(
      builder: (context, state) {
        return RefreshIndicator(
          color: AppColor.primaryBlue,
          onRefresh: () async {
            context.read<PeersBloc>().add(const PeersRefreshRequested());
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: PeersSectionHeader(
                    selectedSort: state.selectedSort,
                    onSortTap: () {
                      PeersSortBottomSheet.show(
                        context,
                        selectedSort: state.selectedSort,
                        onSortSelected: (sort) {
                          context.read<PeersBloc>().add(PeersSortChanged(sort));
                        },
                      );
                    },
                  ),
                ),
              ),
              if (state.status == PeersStatus.loading && state.peers.isEmpty)
                const SliverToBoxAdapter(
                  child: PeersSkeletonLoader(),
                )
              else if (state.status == PeersStatus.failure && state.peers.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppErrorView(
                    title: 'Unable to Load Peers',
                    message: state.errorMessage,
                    onRetry: () => context
                        .read<PeersBloc>()
                        .add(const PeersRefreshRequested()),
                    screenName: 'Peers Directory',
                  ),
                )
              else if (state.peers.isEmpty)
                SliverToBoxAdapter(
                  child: _buildEmptyState(state.searchQuery),
                )
              else
                SliverList.builder(
                  itemCount: state.peers.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.peers.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.primaryBlue,
                          ),
                        ),
                      );
                    }
                    final peer = state.peers[index];
                    final statusLower = peer.connectionStatus.toLowerCase();
                    final isConnected = statusLower == 'connected' ||
                        statusLower == 'approved' ||
                        statusLower == 'accepted';

                    return RepaintBoundary(
                      child: PeerCard(
                        key: ValueKey(peer.id),
                        peer: peer,
                        onConnect: () {
                          context.read<PeersBloc>().add(
                                PeerConnectRequested(peer.id),
                              );
                        },
                        onFollow: () {
                          context.read<PeersBloc>().add(
                                PeerFollowToggled(
                                  peerId: peer.id,
                                  isCurrentlyFollowing: peer.isFollowing,
                                ),
                              );
                        },
                        onScheduleP2P: isConnected
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.addP2pMeeting,
                                  arguments: peer,
                                );
                              }
                            : null,
                        onMessage: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.directChat,
                            arguments: {
                              'peer_id': peer.id,
                              'peer_name': peer.displayName,
                              'peer_avatar': peer.profilePhotoUrl,
                            },
                          );
                        },
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.peerProfile,
                            arguments: peer.id,
                          );
                        },
                        onBookmark: () {
                          context.read<PeersBloc>().add(
                                PeerBookmarkToggled(
                                  peerId: peer.id,
                                  isCurrentlyBookmarked: peer.isBookmarked,
                                ),
                              );
                        },
                      ),
                    );
                  },
                ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 16 + MediaQuery.of(context).padding.bottom,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: _PeersBottomTabItem(
                label: 'All Peers',
                icon: Icons.people_outline_rounded,
                activeIcon: Icons.people_rounded,
                isSelected: _activeTab == 0,
                onTap: () => _onTabSelected(0),
              ),
            ),
            Expanded(
              child: _PeersBottomTabItem(
                label: 'Connections',
                icon: Icons.link_rounded,
                activeIcon: Icons.link_rounded,
                isSelected: _activeTab == 1,
                onTap: () => _onTabSelected(1),
              ),
            ),
            Expanded(
              child: _PeersBottomTabItem(
                label: 'Requests',
                icon: Icons.person_add_outlined,
                activeIcon: Icons.person_add_rounded,
                isSelected: _activeTab == 2,
                onTap: () => _onTabSelected(2),
              ),
            ),
            Expanded(
              child: _PeersBottomTabItem(
                label: 'Matches',
                icon: Icons.auto_awesome_outlined,
                activeIcon: Icons.auto_awesome_rounded,
                isSelected: _activeTab == 3,
                onTap: () => _onTabSelected(3),
              ),
            ),
            Expanded(
              child: _PeersBottomTabItem(
                label: 'Near Me',
                icon: Icons.location_on_outlined,
                activeIcon: Icons.location_on_rounded,
                isSelected: _activeTab == 4,
                onTap: () => _onTabSelected(4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String query) {
    final isSearching = query.trim().isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            isSearching ? Icons.search_off_rounded : Icons.people_outline_rounded,
            size: 48,
            color: AppColor.lightTextDisabled,
          ),
          const SizedBox(height: 12),
          Text(
            isSearching ? 'No peers found for "$query"' : 'No peers found',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColor.lightTextPrimary,
            ),
          ),
          if (isSearching) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                context.read<PeersBloc>().add(const PeersSearchChanged(''));
              },
              child: const Text('Clear search'),
            ),
          ],
        ],
      ),
    );
  }
}

class _PeersBottomTabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeersBottomTabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSelected
        ? AppColor.primaryBlue
        : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.12 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: Icon(
                isSelected ? activeIcon : icon,
                size: 20,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: color,
                fontSize: 9.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
