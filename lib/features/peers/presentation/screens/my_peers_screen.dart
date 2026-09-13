import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../bloc/peers_bloc.dart';
import '../bloc/peers_event.dart';
import '../bloc/peers_state.dart';
import '../widgets/peer_card.dart';
import '../widgets/peers_action_grid.dart';
import '../widgets/peers_section_header.dart';
import '../widgets/peers_skeleton_loader.dart';
import '../widgets/peers_sort_bottom_sheet.dart';
import 'connections_screen.dart';
import 'matches_screen.dart';
import 'near_me_screen.dart';
import 'peer_requests_screen.dart';

class MyPeersScreen extends StatefulWidget {
  const MyPeersScreen({super.key});

  @override
  State<MyPeersScreen> createState() => _MyPeersScreenState();
}

class _MyPeersScreenState extends State<MyPeersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final bloc = context.read<PeersBloc>();
    if (bloc.state.status == PeersStatus.initial) {
      bloc.add(const PeersFetchRequested());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PeersBloc, PeersState>(
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
            context.read<PeersBloc>().add(const PeersRefreshRequested());
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 350) {
                final peersBloc = context.read<PeersBloc>();
                if (!peersBloc.state.isLoadingMore && peersBloc.state.hasMore) {
                  peersBloc.add(const PeersLoadMoreRequested());
                }
              }
              return false;
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: PeersActionGrid(
                    onConnectionsTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ConnectionsScreen(),
                        ),
                      );
                    },
                    onRequestsTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PeerRequestsScreen(),
                        ),
                      );
                    },
                    onMatchesTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MatchesScreen(),
                        ),
                      );
                    },
                    onNearMeTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NearMeScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
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

                    return PeerCard(
                      peer: peer,
                      onConnect: () {
                        context.read<PeersBloc>().add(
                          PeerConnectRequested(peer.id),
                        );
                      },
                      onScheduleP2P: isConnected
                          ? () {
                              AppSnackBar.showInfo(
                                context,
                                'Scheduling P2P with ${peer.displayName}',
                              );
                            }
                          : null,
                      onMessage: () {
                        AppSnackBar.showInfo(
                          context,
                          'Messaging ${peer.displayName}',
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
        ),
      );
      },
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
