import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/widgets/app_error_view.dart';
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
    return BlocBuilder<PeerRequestsBloc, PeerRequestsState>(
      builder: (context, state) {
        final list = state.receivedRequests;

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
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    if (state.status == PeerRequestsStatus.loading &&
                        list.isEmpty)
                      const SliverToBoxAdapter(
                        child: PeersSkeletonLoader(),
                      )
                    else if (state.status == PeerRequestsStatus.failure &&
                        list.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: AppErrorView(
                          title: 'Unable to Load Requests',
                          message: state.errorMessage,
                          onRetry: () => context
                              .read<PeerRequestsBloc>()
                              .add(const PeerRequestsRefreshRequested()),
                          screenName: 'Peer Requests',
                        ),
                      )
                    else if (list.isEmpty)
                      SliverToBoxAdapter(
                        child: _buildEmptyState(),
                      )
                    else
                      SliverList.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final request = list[index];
                          return RequestPeerCard(
                            request: request,
                            isSent: false,
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
                            onCancel: () {},
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 48,
            color: AppColor.lightTextDisabled,
          ),
          const SizedBox(height: 12),
          const Text(
            'No incoming requests',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColor.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'When someone sends you a connection request, it will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColor.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

