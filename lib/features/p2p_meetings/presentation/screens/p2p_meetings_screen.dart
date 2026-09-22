import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/core/router/app_router.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/widgets/app_common_bar.dart';
import 'package:unity_app/core/widgets/app_snack_bar.dart';
import 'package:unity_app/core/widgets/responsive_container.dart';
import '../bloc/p2p_meetings_bloc.dart';
import '../bloc/p2p_meetings_event.dart';
import '../bloc/p2p_meetings_state.dart';
import '../widgets/add_p2p_meeting_fab.dart';
import '../widgets/common/p2p_sub_tab_chips.dart';
import '../widgets/completed/p2p_completed_list_view.dart';
import '../widgets/p2p_meeting_leaderboard_view.dart';
import '../widgets/p2p_meetings_bottom_nav.dart';
import '../widgets/scheduled/p2p_scheduled_list_view.dart';
import '../widgets/scheduled/schedule_p2p_meeting_sheet.dart';

class P2pMeetingsScreen extends StatelessWidget {
  final int initialTabIndex;
  const P2pMeetingsScreen({super.key, this.initialTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => P2pMeetingsBloc(
        getP2pMeetingsHistoryUseCase: ctx.read(),
        getP2pMeetingRequestsInboxUseCase: ctx.read(),
        getP2pMeetingRequestsSentUseCase: ctx.read(),
        getPendingRescheduleRequestsReceivedUseCase: ctx.read(),
        getP2pMeetingsLeaderboardUseCase: ctx.read(),
        acceptP2pMeetingRequestUseCase: ctx.read(),
        rejectP2pMeetingRequestUseCase: ctx.read(),
        cancelP2pMeetingRequestUseCase: ctx.read(),
        approveRescheduleRequestUseCase: ctx.read(),
        rejectRescheduleRequestUseCase: ctx.read(),
        requestRescheduleP2pMeetingUseCase: ctx.read(),
      )..add(
          initialTabIndex == 0
              ? const P2pMeetingsFetchLeaderboardRequested()
              : const P2pMeetingsFetchRequested(),
        ),
      child: _P2pMeetingsView(initialTabIndex: initialTabIndex),
    );
  }
}

class _P2pMeetingsView extends StatefulWidget {
  final int initialTabIndex;
  const _P2pMeetingsView({required this.initialTabIndex});

  @override
  State<_P2pMeetingsView> createState() => _P2pMeetingsViewState();
}

class _P2pMeetingsViewState extends State<_P2pMeetingsView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late int _mainTabIndex;
  int _completedSubIndex = 0;
  int _scheduledSubIndex = 0;

  static const _compLabels = ['I Initiated', 'Peer Initiated'];
  static const _compIcons = [
    Icons.call_made_rounded,
    Icons.call_received_rounded,
  ];
  static const _schedLabels = ['Received', 'Sent', 'Reschedules'];
  static const _schedIcons = [
    Icons.inbox_rounded,
    Icons.outbox_rounded,
    Icons.schedule_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _mainTabIndex = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onMainTabChanged(int index) {
    setState(() => _mainTabIndex = index);
    final tabName = index == 0
        ? 'leaderboard'
        : (index == 1 ? 'completed' : 'scheduled');
    context.read<P2pMeetingsBloc>().add(P2pMeetingsTopTabChanged(tabName));
  }

  void _onSubTabChanged(int index) {
    setState(() {
      if (_mainTabIndex == 1) _completedSubIndex = index;
      if (_mainTabIndex == 2) _scheduledSubIndex = index;
    });
    final bloc = context.read<P2pMeetingsBloc>();
    if (_mainTabIndex == 1) {
      bloc.add(
        P2pMeetingsCompletedSubTabChanged(
          index == 0 ? 'i_initiated' : 'peer_initiated',
        ),
      );
    } else if (_mainTabIndex == 2) {
      bloc.add(
        P2pMeetingsScheduledSubTabChanged(
          index == 0 ? 'received' : (index == 1 ? 'sent' : 'reschedules'),
        ),
      );
    }
  }

  void _onFabPressed() async {
    if (_mainTabIndex == 1) {
      final result = await Navigator.pushNamed(
        context,
        AppRoutes.addP2pMeeting,
      );
      if (result == true && mounted) {
        context.read<P2pMeetingsBloc>().add(
          const P2pMeetingsRefreshRequested(),
        );
      }
    } else if (_mainTabIndex == 2) {
      ScheduleP2pMeetingSheet.show(
        context,
        onSuccess: () {
          AppSnackBar.showSuccess(context, 'Meeting request sent successfully');
          context.read<P2pMeetingsBloc>().add(
            const P2pMeetingsRefreshRequested(),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      appBar: AppCommonBar(
        title: 'P2P Meetings',
        showBack: Navigator.canPop(context),
        showSearch: true,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: _mainTabIndex == 0
            ? 'Search leaders by name, company...'
            : 'Search meetings...',
        onSearchTap: () => setState(() => _isSearching = true),
        onSearchChanged: (q) =>
            context.read<P2pMeetingsBloc>().add(P2pMeetingsSearchChanged(q)),
        onSearchClose: () {
          _searchController.clear();
          context.read<P2pMeetingsBloc>().add(
            const P2pMeetingsSearchChanged(''),
          );
          setState(() => _isSearching = false);
        },
        showNotifications: false,
        showProfile: false,
        showChat: false,
        onProfileTap: () => Navigator.pushNamed(context, AppRoutes.profile),
        onBackTap: Navigator.canPop(context)
            ? () => Navigator.pop(context)
            : null,
      ),
      body: SafeArea(
        top: false,
        child: ResponsiveContainer(
          child: BlocConsumer<P2pMeetingsBloc, P2pMeetingsState>(
            listener: (context, state) {
              if (state.successMessage != null) {
                AppSnackBar.showSuccess(context, state.successMessage!);
              }
              if (state.status == P2pMeetingsStatus.failure &&
                  state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      if (_mainTabIndex > 0)
                        P2pSubTabChips(
                          labels: _mainTabIndex == 1
                              ? _compLabels
                              : _schedLabels,
                          icons: _mainTabIndex == 1 ? _compIcons : _schedIcons,
                          selectedIndex: _mainTabIndex == 1
                              ? _completedSubIndex
                              : _scheduledSubIndex,
                          badges:
                              _mainTabIndex == 2 &&
                                  state.rescheduleRequests.isNotEmpty
                              ? {2: state.rescheduleRequests.length}
                              : null,
                          onSelected: _onSubTabChanged,
                        ),
                      Expanded(child: _buildBody(state)),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: P2pMeetingsBottomNav(
                      activeTab: _mainTabIndex,
                      completedCount:
                          state.iInitiatedMeetings.length +
                          state.peerInitiatedMeetings.length,
                      scheduledCount:
                          state.receivedRequests.length +
                          state.rescheduleRequests.length,
                      onTabChanged: _onMainTabChanged,
                    ),
                  ),
                  if (_mainTabIndex > 0)
                    Positioned(
                      right: 16,
                      bottom: 76,
                      child: AddP2pMeetingFab(onTap: _onFabPressed),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(P2pMeetingsState state) {
    if (_mainTabIndex == 0) return const P2pMeetingLeaderboardView();
    if (_mainTabIndex == 1) {
      return P2pCompletedListView(
        isLoading:
            state.status == P2pMeetingsStatus.loading &&
            state.filteredCompletedMeetings.isEmpty,
        errorMessage: state.errorMessage,
        items: state.filteredCompletedMeetings,
        onRefresh: () async => context.read<P2pMeetingsBloc>().add(
          const P2pMeetingsRefreshRequested(),
        ),
        isInitiatedByMe: _completedSubIndex == 0,
      );
    }
    return P2pScheduledListView(
      isLoading:
          state.status == P2pMeetingsStatus.loading &&
          state.filteredScheduledRequests.isEmpty,
      errorMessage: state.errorMessage,
      requests: state.filteredScheduledRequests,
      reschedules: state.filteredRescheduleRequests,
      subTabIndex: _scheduledSubIndex,
      onRefresh: () async => context.read<P2pMeetingsBloc>().add(
        const P2pMeetingsRefreshRequested(),
      ),
      onAccept: (id) =>
          context.read<P2pMeetingsBloc>().add(P2pMeetingAcceptRequested(id)),
      onReject: (id) =>
          context.read<P2pMeetingsBloc>().add(P2pMeetingRejectRequested(id)),
      onCancel: (id) =>
          context.read<P2pMeetingsBloc>().add(P2pMeetingCancelRequested(id)),
      onReschedule: (p) =>
          context.read<P2pMeetingsBloc>().add(P2pMeetingRescheduleRequested(p)),
      onApproveReschedule: (id) =>
          context.read<P2pMeetingsBloc>().add(P2pMeetingRescheduleApproved(id)),
      onRejectReschedule: (id) =>
          context.read<P2pMeetingsBloc>().add(P2pMeetingRescheduleRejected(id)),
    );
  }
}
