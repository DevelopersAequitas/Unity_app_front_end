import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/peer_requests_bloc.dart';
import '../bloc/peer_requests_event.dart';
import '../bloc/peer_requests_state.dart';
import '../widgets/peers_skeleton_loader.dart';
import '../widgets/request_peer_card.dart';

class PeerRequestsScreen extends StatefulWidget {
  final bool isTab;
  const PeerRequestsScreen({super.key, this.isTab = false});

  @override
  State<PeerRequestsScreen> createState() => _PeerRequestsScreenState();
}

class _PeerRequestsScreenState extends State<PeerRequestsScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<PeerRequestsBloc>();
    if (bloc.state.status == PeerRequestsStatus.initial) {
      bloc.add(const PeerRequestsFetchRequested());
    } else {
      bloc.add(const PeerRequestsRefreshRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PeerRequestsBloc, PeerRequestsState>(
      listenWhen: (prev, curr) =>
          curr.errorMessage != null &&
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        final isReceivedTab = state.activeTab == 0;
        final list = isReceivedTab
            ? state.receivedRequests
            : state.sentRequests;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: widget.isTab
              ? null
              : AppCommonBar(
                  title: 'Requests',
                  showBack: true,
                  showSearch: false,
                  showNotifications: false,
                  showProfile: false,
                  onBackTap: () => Navigator.pop(context),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildTabBar(
                        state.activeTab,
                        receivedCount: state.receivedRequests.length,
                        sentCount: state.sentRequests.length,
                      ),
                    ),
                  ),
                ),
          body: AppGradientBackground(
            child: ResponsiveContainer(
              child: RefreshIndicator(
                color: AppColor.primaryBlue,
                onRefresh: () async {
                  context
                      .read<PeerRequestsBloc>()
                      .add(const PeerRequestsRefreshRequested());
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    if (widget.isTab)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 6),
                          child: _buildTabBar(
                            state.activeTab,
                            receivedCount: state.receivedRequests.length,
                            sentCount: state.sentRequests.length,
                          ),
                        ),
                      )
                    else
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 8),
                      ),
                    if (state.status == PeerRequestsStatus.loading &&
                        list.isEmpty)
                      const SliverToBoxAdapter(
                        child: PeersSkeletonLoader(),
                      )
                    else if (list.isEmpty)
                      SliverToBoxAdapter(
                        child: _buildEmptyState(isReceivedTab),
                      )
                    else
                      SliverList.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final request = list[index];
                          return RequestPeerCard(
                            request: request,
                            isSent: !isReceivedTab,
                            onTap: () {
                              final targetId = request.peer.id.isNotEmpty
                                  ? request.peer.id
                                  : request.id;
                              Navigator.pushNamed(
                                context,
                                AppRoutes.peerProfile,
                                arguments: targetId,
                              );
                            },
                            onAccept: () {
                              context.read<PeerRequestsBloc>().add(
                                    PeerRequestAcceptRequested(
                                      requestId: request.id,
                                      requesterId: request.peer.id,
                                    ),
                                  );
                            },
                            onDecline: () {
                              context.read<PeerRequestsBloc>().add(
                                    PeerRequestDeclineRequested(
                                      requestId: request.id,
                                      memberId: request.peer.id,
                                    ),
                                  );
                            },
                            onCancel: () {
                              final addresseeId = request.peer.id.isNotEmpty
                                  ? request.peer.id
                                  : request.id;
                              context.read<PeerRequestsBloc>().add(
                                    PeerRequestCancelRequested(addresseeId),
                                  );
                            },
                            onBookmark: () {},
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
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar(int activeTab, {required int receivedCount, required int sentCount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColor.lightSurfaceMuted,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: _PillTabItem(
                label: 'Received',
                count: receivedCount,
                isActive: activeTab == 0,
                onTap: () {
                  context
                      .read<PeerRequestsBloc>()
                      .add(const PeerRequestsTabChanged(0));
                },
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _PillTabItem(
                label: 'Sent',
                count: sentCount,
                isActive: activeTab == 1,
                onTap: () {
                  context
                      .read<PeerRequestsBloc>()
                      .add(const PeerRequestsTabChanged(1));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isReceived) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 48,
            color: AppColor.lightTextDisabled,
          ),
          const SizedBox(height: 12),
          Text(
            isReceived ? 'No incoming requests' : 'No sent requests',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColor.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillTabItem extends StatelessWidget {
  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const _PillTabItem({
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColor.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppColor.lightTextPrimary
                      : AppColor.lightTextSecondary,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1.5,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColor.primaryBlue.withValues(alpha: 0.12)
                        : AppColor.lightBorder,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? AppColor.primaryBlue
                          : AppColor.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
