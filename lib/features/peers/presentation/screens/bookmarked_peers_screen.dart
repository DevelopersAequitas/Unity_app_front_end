import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/peers_bloc.dart';
import '../bloc/peers_event.dart';
import '../bloc/peers_state.dart';
import '../widgets/bookmarked_peers_empty_view.dart';
import '../widgets/peer_card.dart';
import '../widgets/peers_skeleton_loader.dart';

class BookmarkedPeersScreen extends StatefulWidget {
  const BookmarkedPeersScreen({super.key});

  @override
  State<BookmarkedPeersScreen> createState() => _BookmarkedPeersScreenState();
}

class _BookmarkedPeersScreenState extends State<BookmarkedPeersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<PeersBloc>();
    bloc.add(const BookmarkedPeersFetchRequested());
    if (bloc.state.status == PeersStatus.initial) {
      bloc.add(const PeersFetchRequested());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authUserId = context.read<AuthBloc>().state.user?.id ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Bookmarks',
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
        onBackTap: () => Navigator.pop(context),
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocBuilder<PeersBloc, PeersState>(
            builder: (context, state) {
              final bookmarks = state.bookmarkedPeers;

              if ((state.isLoadingBookmarks || state.status == PeersStatus.loading) &&
                  bookmarks.isEmpty) {
                return const PeersSkeletonLoader();
              }

              return RefreshIndicator(
                color: AppColor.primaryBlue,
                onRefresh: () async {
                  context
                      .read<PeersBloc>()
                      .add(const BookmarkedPeersRefreshRequested());
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    if (bookmarks.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                          child: Text(
                            '${bookmarks.length} Bookmarked ${bookmarks.length == 1 ? 'Peer' : 'Peers'}',
                            style: AppTypography.labelMedium.copyWith(
                              color: isDark
                                  ? AppColor.darkTextSecondary
                                  : AppColor.lightTextSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (state.status == PeersStatus.failure && bookmarks.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: AppErrorView(
                          title: 'Unable to Load Bookmarks',
                          message: state.errorMessage,
                          onRetry: () => context
                              .read<PeersBloc>()
                              .add(const BookmarkedPeersRefreshRequested()),
                          screenName: 'Bookmarks',
                        ),
                      )
                    else if (bookmarks.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: BookmarkedPeersEmptyView(),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        sliver: SliverList.separated(
                          itemCount: bookmarks.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final peer = bookmarks[index];
                            final isMe = peer.id == authUserId;

                            return PeerCard(
                              peer: peer,
                              isCurrentUser: isMe,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.peerProfile,
                                  arguments: peer.id,
                                );
                              },
                              onBookmark: () {
                                context.read<PeersBloc>().add(
                                      PeerBookmarkToggled(
                                        peerId: peer.id,
                                        isCurrentlyBookmarked:
                                            peer.isBookmarked,
                                      ),
                                    );
                              },
                              onConnect: isMe || peer.isConnected
                                  ? null
                                  : () {
                                      context.read<PeersBloc>().add(
                                            PeerConnectRequested(peer.id),
                                          );
                                    },
                              onFollow: isMe
                                  ? null
                                  : () {
                                      context.read<PeersBloc>().add(
                                            PeerFollowToggled(
                                              peerId: peer.id,
                                              isCurrentlyFollowing:
                                                  peer.isFollowing,
                                            ),
                                          );
                                    },
                            );
                          },
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
}
