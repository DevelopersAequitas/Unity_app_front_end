import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/core/widgets/app_common_bar.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/common_peer_selector_sheet.dart';
import '../../../circles/presentation/bloc/circles_bloc.dart';
import '../../../circles/presentation/bloc/circles_event.dart';
import '../../../circles/presentation/bloc/circles_state.dart';
import '../bloc/chat_list/chat_list_bloc.dart';
import '../bloc/chat_list/chat_list_event.dart';
import '../bloc/chat_list/chat_list_state.dart';
import '../widgets/chat_empty_view.dart';
import '../widgets/chat_hub_circle_tile.dart';
import '../widgets/chat_hub_conversation_tile.dart';
import '../widgets/chat_hub_leadership_tile.dart';
import '../widgets/chat_shimmer_loading.dart';

class ChatHubScreen extends StatefulWidget {
  const ChatHubScreen({super.key});

  @override
  State<ChatHubScreen> createState() => _ChatHubScreenState();
}

class _ChatHubScreenState extends State<ChatHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<ChatListBloc>().add(const LoadChatListEvent());
    context.read<CirclesBloc>().add(const CirclesFetchRequested());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _startNewChat() async {
    final peer = await CommonPeerSelectorSheet.show(
      context,
      title: 'Start Direct Chat',
    );
    if (!mounted || peer == null) return;
    Navigator.pushNamed(
      context,
      AppRoutes.directChat,
      arguments: {
        'peer_id': peer.id,
        'peer_name': peer.displayName,
        'peer_avatar': peer.profilePhotoUrl,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCommonBar(
        title: 'Messages',
        showBack: true,
        showChat: false,
        onBackTap: () => Navigator.pop(context),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColor.primaryBlue,
          unselectedLabelColor: AppColor.lightTextSecondary,
          indicatorColor: AppColor.primaryBlue,
          tabs: const [
            Tab(text: 'Direct'),
            Tab(text: 'Circles'),
            Tab(text: 'Leaders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDirectTab(context),
          _buildCirclesTab(context),
          _buildLeadersTab(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startNewChat,
        backgroundColor: AppColor.primaryBlue,
        icon: const Icon(Icons.edit_square, color: Colors.white, size: 18),
        label: const Text(
          'New Chat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildDirectTab(BuildContext context) {
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        if (state.status == ChatListStatus.loading) {
          return const ChatShimmerLoading();
        }
        if (state.status == ChatListStatus.error) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Failed to load chats',
              style: AppTypography.bodyMedium,
            ),
          );
        }
        if (state.filteredDirectChats.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 48,
                    color: AppColor.lightTextTertiary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Direct Messages Yet',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Start a 1-to-1 conversation with your peers to connect & collaborate.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColor.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _startNewChat,
                    icon: const Icon(Icons.add_comment_rounded, size: 18),
                    label: const Text('Start a Chat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async =>
              context.read<ChatListBloc>().add(const RefreshChatListEvent()),
          child: ListView.separated(
            itemCount: state.filteredDirectChats.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final conv = state.filteredDirectChats[index];
              return ChatHubConversationTile(
                conversation: conv,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.directChat,
                    arguments: {
                      'chat_id': conv.id,
                      'peer_id': conv.otherUser?.id,
                      'peer_name': conv.otherUser?.displayName,
                      'peer_avatar': conv.otherUser?.profilePhotoUrl,
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCirclesTab(BuildContext context) {
    return BlocBuilder<CirclesBloc, CirclesState>(
      builder: (context, state) {
        if (state.status == CirclesStatus.loading) {
          return const ChatShimmerLoading();
        }
        if (state.myCircles.isEmpty) {
          return const ChatEmptyView(
            icon: Icons.groups_rounded,
            title: 'No Joined Circles',
            subtitle:
                'Join circles to participate in group discussions with circle members.',
          );
        }
        return RefreshIndicator(
          onRefresh: () async =>
              context.read<CirclesBloc>().add(const CirclesFetchRequested()),
          child: ListView.separated(
            itemCount: state.myCircles.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final circle = state.myCircles[index];
              return ChatHubCircleTile(
                circle: circle,
                onOpenChat: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.circleChat,
                    arguments: {
                      'circle_id': circle.id,
                      'circle_name': circle.name,
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLeadersTab(BuildContext context) {
    return BlocBuilder<CirclesBloc, CirclesState>(
      builder: (context, state) {
        if (state.status == CirclesStatus.loading) {
          return const ChatShimmerLoading();
        }
        if (state.myCircles.isEmpty) {
          return const ChatEmptyView(
            icon: Icons.shield_rounded,
            title: 'Leadership Hub',
            subtitle:
                'Confidential discussions for designated circle leadership members.',
          );
        }
        return ListView.separated(
          itemCount: state.myCircles.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final circle = state.myCircles[index];
            return ChatHubLeadershipTile(
              circle: circle,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.circleLeadershipChat,
                  arguments: {
                    'circle_id': circle.id,
                    'circle_name': circle.name,
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
