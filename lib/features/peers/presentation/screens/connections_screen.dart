import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/connections_bloc.dart';
import '../bloc/connections_event.dart';
import '../bloc/connections_state.dart';
import '../widgets/connected_peer_card.dart';
import '../widgets/peers_skeleton_loader.dart';

class ConnectionsScreen extends StatefulWidget {
  final bool isTab;
  const ConnectionsScreen({super.key, this.isTab = false});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    final bloc = context.read<ConnectionsBloc>();
    if (bloc.state.status == ConnectionsStatus.initial) {
      bloc.add(const ConnectionsFetchRequested());
    } else {
      bloc.add(const ConnectionsRefreshRequested());
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
    if (currentScroll >= (maxScroll - 200)) {
      context.read<ConnectionsBloc>().add(const ConnectionsLoadMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: widget.isTab
          ? null
          : AppCommonBar(
              title: 'Connections',
              showBack: true,
              showSearch: false,
              showNotifications: false,
              showProfile: false,
              onBackTap: () => Navigator.pop(context),
            ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocConsumer<ConnectionsBloc, ConnectionsState>(
            listenWhen: (prev, curr) =>
                curr.errorMessage != null &&
                prev.errorMessage != curr.errorMessage,
            listener: (context, state) {
              if (state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              return RefreshIndicator(
                color: AppColor.primaryBlue,
                onRefresh: () async {
                  context
                      .read<ConnectionsBloc>()
                      .add(const ConnectionsRefreshRequested());
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    if (state.connections.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                          child: Text(
                            '${state.connections.length} Connections',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColor.lightTextSecondary,
                            ),
                          ),
                        ),
                      ),
                    if (state.status == ConnectionsStatus.loading &&
                        state.connections.isEmpty)
                      const SliverToBoxAdapter(
                        child: PeersSkeletonLoader(),
                      )
                    else if (state.connections.isEmpty)
                      SliverToBoxAdapter(
                        child: _buildEmptyState(),
                      )
                    else
                      SliverList.builder(
                        itemCount: state.connections.length +
                            (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.connections.length) {
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
                          final peer = state.connections[index];
                          return ConnectedPeerCard(
                            peer: peer,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.peerProfile,
                                arguments: peer.id,
                              );
                            },
                            onFollow: () {
                              context.read<ConnectionsBloc>().add(
                                    ConnectionFollowToggled(
                                      peerId: peer.id,
                                      isCurrentlyFollowing:
                                          peer.isFollowing,
                                    ),
                                  );
                            },
                            onScheduleP2P: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.addP2pMeeting,
                                arguments: peer,
                              );
                            },
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
                            onBookmark: () {
                              context.read<ConnectionsBloc>().add(
                                    ConnectionBookmarkToggled(
                                      peerId: peer.id,
                                      isCurrentlyBookmarked:
                                          peer.isBookmarked,
                                    ),
                                  );
                            },
                          );
                        },
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
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Icon(
            Icons.group_outlined,
            size: 48,
            color: AppColor.lightTextDisabled,
          ),
          SizedBox(height: 12),
          Text(
            'No connections yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColor.lightTextPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Connect with peers to expand your network.',
            style: TextStyle(
              fontSize: 13,
              color: AppColor.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
