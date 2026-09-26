import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/ask_flow_entity.dart';
import '../../domain/entities/ask_item_entity.dart';
import '../../domain/entities/ask_match_peer_entity.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../../domain/entities/ask_type_entity.dart';
import '../../../peers/domain/entities/peer_entity.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../bloc/my_asks/my_asks_bloc.dart';
import '../bloc/my_asks/my_asks_event.dart';
import '../bloc/my_asks/my_asks_state.dart';
import '../bloc/peers_feed/peers_feed_bloc.dart';
import '../bloc/peers_feed/peers_feed_event.dart';
import '../bloc/peers_feed/peers_feed_state.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../widgets/feed_filter_pills.dart';
import '../widgets/my_ask_dashboard_card.dart';
import '../widgets/peers_feed_card.dart';
import '../widgets/peers_asks_bottom_nav.dart';
import '../widgets/add_ask_fab.dart';
import '../widgets/ask_share_helper.dart';
import '../widgets/ask_leaderboard_tab.dart';

class PeersAsksHubScreen extends StatefulWidget {
  final int initialTabIndex;
  final String? highlightAskId;
  final String? flowCode;
  final String? flowTitle;

  const PeersAsksHubScreen({
    super.key,
    this.initialTabIndex = 0,
    this.highlightAskId,
    this.flowCode,
    this.flowTitle,
  });

  @override
  State<PeersAsksHubScreen> createState() => _PeersAsksHubScreenState();
}

class _PeersAsksHubScreenState extends State<PeersAsksHubScreen> {
  late int _activeTab;
  final Map<String, GlobalKey> _cardKeys = {};
  bool _hasScrolledToHighlight = false;

  static const _feedFilters = [
    {'label': 'For You', 'value': 'for_you'},
    {'label': 'My Circle', 'value': 'circle'},
    {'label': 'My City', 'value': 'city'},
    {'label': 'Global / All', 'value': 'all'},
  ];

  static const _myAsksFilters = [
    {'label': 'All', 'value': 'all'},
    {'label': 'Open', 'value': 'open'},
    {'label': 'In Progress', 'value': 'in_progress'},
    {'label': 'Fulfilled', 'value': 'fulfilled'},
    {'label': 'Closed', 'value': 'expired'},
  ];

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTabIndex;
    final initialScope = widget.flowCode ?? 'all';
    context.read<PeersFeedBloc>().add(PeersFeedFetchRequested(scope: initialScope));
    context.read<MyAsksBloc>().add(MyAsksFetchRequested(flow: widget.flowCode ?? 'all'));
  }

  void _scrollToHighlightedAsk() {
    if (_hasScrolledToHighlight || widget.highlightAskId == null) return;
    final key = _cardKeys[widget.highlightAskId];
    if (key?.currentContext != null) {
      _hasScrolledToHighlight = true;
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
        alignment: 0.15,
      );
    }
  }

  void _onHelpTap(AskItemEntity item) {
    final profile = context.read<ProfileBloc?>()?.state.profile;
    final currentUserId = profile?.id ?? '';
    final authorId = item.authorId;
    final authorName = item.authorName.isNotEmpty ? item.authorName : 'Peer';
    final isMyAsk = (currentUserId.isNotEmpty && authorId.isNotEmpty && currentUserId == authorId) ||
        (profile != null && profile.displayName.isNotEmpty && authorName == profile.displayName);

    if (isMyAsk) {
      _onReviewTap(item);
      return;
    }

    final flowCode = item.flowCode.isNotEmpty ? item.flowCode : (widget.flowCode ?? 'collaboration');
    final flowName = item.flowName.isNotEmpty
        ? item.flowName
        : (flowCode == 'help'
            ? 'Get Help'
            : (flowCode == 'referral'
                ? 'Ask for an Introduction'
                : 'Find a Collaborator'));

    final flow = AskFlowEntity(
      id: flowCode,
      code: flowCode,
      name: flowName,
      description: '',
    );

    final raw = item.rawData;
    final typeCode =
        raw['type_code']?.toString() ??
        raw['type']?.toString() ??
        item.typeName.toLowerCase().replaceAll(' ', '_');

    final type = AskTypeEntity(
      id: typeCode,
      flowId: flow.id,
      code: typeCode,
      name: item.typeName.isNotEmpty ? item.typeName : flow.name,
    );

    final peer = AskMatchPeerEntity(
      id: authorId,
      name: authorName,
      businessType: item.authorCompany,
      location: item.authorCity,
      typeLabel: type.name,
      isTypeMatched: true,
      capitalLabel: '',
      isCapitalMatched: true,
      stageLabel: '',
      isStageMatched: true,
      peer: PeerEntity(
        id: authorId,
        displayName: authorName,
        companyName: item.authorCompany,
        profilePhotoUrl: item.authorAvatar,
      ),
    );

    final submission = AskSubmissionEntity(
      flow: flow,
      type: type,
      goal: item.title,
    );

    Navigator.of(context).pushNamed(
      AppRoutes.askExpressInterest,
      arguments: {'peer': peer, 'submission': submission, 'askId': item.id},
    );
  }

  void _onReviewTap(AskItemEntity ask) {
    Navigator.of(context).pushNamed(
      AppRoutes.askResponses,
      arguments: {
        'askId': ask.id,
        'flowName': ask.flowName,
        'title': ask.title,
        'askItem': ask,
      },
    );
  }

  void _openCreateAsk() {
    Navigator.of(context).pushNamed(AppRoutes.postAsk);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColor.darkBackground : AppColor.lightScaffoldBg;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppCommonBar(
        title: widget.flowTitle ?? 'Open Asks & Needs',
        showBack: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: _activeTab == 0
                ? _buildPeersFeedTab(isDark)
                : (_activeTab == 1
                    ? _buildMyAsksTab(isDark)
                    : AskLeaderboardTab(flowCode: widget.flowCode ?? 'all')),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PeersAsksBottomNav(
              activeTab: _activeTab,
              onTabChanged: (tab) => setState(() => _activeTab = tab),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 74,
            child: AddAskFab(onTap: _openCreateAsk),
          ),
        ],
      ),
    );
  }

  Widget _buildPeersFeedTab(bool isDark) {
    return BlocConsumer<PeersFeedBloc, PeersFeedState>(
      listener: (context, state) {
        if (state.status == PeersFeedStatus.success &&
            widget.highlightAskId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToHighlightedAsk();
          });
        }
      },
      builder: (context, state) {
        if (state.status == PeersFeedStatus.success &&
            widget.highlightAskId != null &&
            !_hasScrolledToHighlight) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToHighlightedAsk();
          });
        }

        final feedItems = widget.flowCode != null
            ? state.items.where((i) {
                if (i.flowCode.isEmpty) return true;
                final f = i.flowCode.toLowerCase();
                final target = widget.flowCode!.toLowerCase();
                if (f == target) return true;
                if (target == 'help' && (f == 'get_help' || f == 'help')) return true;
                if (target == 'collaboration' && (f == 'collaborator' || f == 'collaboration')) return true;
                return true; // keep items returned by flow endpoint
              }).toList()
            : state.items;

        return Column(
          children: [
            const SizedBox(height: 4),
            FeedFilterPills(
              filters: _feedFilters,
              selectedValue: state.selectedScope,
              onSelected: (val) {
                final targetScope = (val == 'all' || val == 'for_you')
                    ? (widget.flowCode ?? val)
                    : val;
                context.read<PeersFeedBloc>().add(
                  PeersFeedFetchRequested(scope: targetScope),
                );
              },
            ),
            const SizedBox(height: 4),
            Expanded(
              child: state.status == PeersFeedStatus.loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryBlue,
                        strokeWidth: 2,
                      ),
                    )
                  : RefreshIndicator(
                      color: AppColor.primaryBlue,
                      onRefresh: () async => context.read<PeersFeedBloc>().add(
                        PeersFeedFetchRequested(scope: widget.flowCode ?? state.selectedScope, isRefresh: true),
                      ),
                      child: feedItems.isEmpty
                          ? ListView(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Center(
                                    child: Text(
                                      'No requests in this scope yet.',
                                      style: TextStyle(
                                        color: isDark
                                            ? AppColor.darkTextSecondary
                                            : AppColor.lightTextSecondary,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: feedItems.length,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              itemBuilder: (context, index) {
                                final item = feedItems[index];
                                final cardKey = _cardKeys.putIfAbsent(
                                  item.id,
                                  () => GlobalKey(),
                                );
                                final isHighlighted =
                                    item.id == widget.highlightAskId;

                                return PeersFeedCard(
                                  key: cardKey,
                                  item: item,
                                  isHighlighted: isHighlighted,
                                  isCongratulated: state.congratulatedIds
                                      .contains(item.id),
                                  isSaved: state.savedIds.contains(item.id),
                                  onHelpTap: () => _onHelpTap(item),
                                  onCongratulate: () =>
                                      context.read<PeersFeedBloc>().add(
                                        PeersFeedCongratulateRequested(
                                          askId: item.id,
                                        ),
                                      ),
                                  onShare: () =>
                                      AskShareHelper.shareAsk(item: item),
                                  onSave: () =>
                                      context.read<PeersFeedBloc>().add(
                                        PeersFeedToggleSaveRequested(
                                          askId: item.id,
                                        ),
                                      ),
                                );
                              },
                            ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMyAsksTab(bool isDark) {
    return BlocBuilder<MyAsksBloc, MyAsksState>(
      builder: (context, state) {
        final myItems = widget.flowCode != null
            ? state.filteredAsks.where((i) {
                if (i.flowCode.isEmpty) return true;
                final f = i.flowCode.toLowerCase();
                final target = widget.flowCode!.toLowerCase();
                if (f == target) return true;
                if (target == 'help' && (f == 'get_help' || f == 'help')) return true;
                if (target == 'collaboration' && (f == 'collaborator' || f == 'collaboration')) return true;
                return true;
              }).toList()
            : state.filteredAsks;

        return Column(
          children: [
            const SizedBox(height: 4),
            FeedFilterPills(
              filters: _myAsksFilters,
              selectedValue: state.selectedStatus,
              onSelected: (val) => context.read<MyAsksBloc>().add(
                MyAsksFetchRequested(flow: widget.flowCode ?? 'all', status: val),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: state.status == MyAsksStatus.loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primaryBlue,
                        strokeWidth: 2,
                      ),
                    )
                  : RefreshIndicator(
                      color: AppColor.primaryBlue,
                      onRefresh: () async => context.read<MyAsksBloc>().add(
                        MyAsksFetchRequested(flow: widget.flowCode ?? 'all', refresh: true),
                      ),
                      child: myItems.isEmpty
                          ? ListView(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Center(
                                    child: Text(
                                      'No asks found in this status.',
                                      style: TextStyle(
                                        color: isDark
                                            ? AppColor.darkTextSecondary
                                            : AppColor.lightTextSecondary,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              itemCount: myItems.length,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              itemBuilder: (context, index) {
                                final ask = myItems[index];
                                return MyAskDashboardCard(
                                  ask: ask,
                                  onReviewTap: () => _onReviewTap(ask),
                                );
                              },
                            ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
