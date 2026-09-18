import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unity_app/core/router/app_router.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/widgets/app_common_bar.dart';
import 'package:unity_app/core/widgets/app_snack_bar.dart';
import 'package:unity_app/core/widgets/responsive_container.dart';
import 'package:unity_app/features/p2p_meetings/presentation/bloc/p2p_meetings_bloc.dart';
import 'package:unity_app/features/p2p_meetings/presentation/bloc/p2p_meetings_event.dart';
import 'package:unity_app/features/p2p_meetings/presentation/bloc/p2p_meetings_state.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/add_p2p_meeting_fab.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/common/p2p_sub_tab_chips.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/completed/p2p_completed_list_view.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/p2p_meetings_bottom_nav.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/scheduled/p2p_scheduled_list_view.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/scheduled/schedule_p2p_meeting_sheet.dart';

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
        acceptP2pMeetingRequestUseCase: ctx.read(),
        rejectP2pMeetingRequestUseCase: ctx.read(),
        cancelP2pMeetingRequestUseCase: ctx.read(),
        approveRescheduleRequestUseCase: ctx.read(),
        rejectRescheduleRequestUseCase: ctx.read(),
        requestRescheduleP2pMeetingUseCase: ctx.read(),
      )..add(const P2pMeetingsFetchRequested()),
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

  static const _completedLabels = ['I Initiated', 'Peer Initiated'];
  static const _completedIcons = [Icons.call_made_rounded, Icons.call_received_rounded];

  static const _scheduledLabels = ['Received', 'Sent', 'Reschedules'];
  static const _scheduledIcons = [
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
    context.read<P2pMeetingsBloc>().add(
          P2pMeetingsTopTabChanged(index == 0 ? 'completed' : 'scheduled'),
        );
  }

  void _onSubTabChanged(int index) {
    setState(() {
      if (_mainTabIndex == 0) {
        _completedSubIndex = index;
      } else {
        _scheduledSubIndex = index;
      }
    });
    final bloc = context.read<P2pMeetingsBloc>();
    if (_mainTabIndex == 0) {
      bloc.add(P2pMeetingsCompletedSubTabChanged(
        index == 0 ? 'i_initiated' : 'peer_initiated',
      ));
    } else {
      final sub = index == 0 ? 'received' : (index == 1 ? 'sent' : 'reschedules');
      bloc.add(P2pMeetingsScheduledSubTabChanged(sub));
    }
  }

  void _onFabPressed() async {
    if (_mainTabIndex == 0) {
      final result = await Navigator.pushNamed(context, AppRoutes.addP2pMeeting);
      if (result == true && mounted) {
        context.read<P2pMeetingsBloc>().add(const P2pMeetingsRefreshRequested());
      }
    } else {
      ScheduleP2pMeetingSheet.show(
        context,
        onSuccess: () {
          AppSnackBar.showSuccess(context, 'Meeting request sent successfully');
          context.read<P2pMeetingsBloc>().add(const P2pMeetingsRefreshRequested());
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
        searchHint: 'Search meetings by peer, location...',
        onSearchTap: () => setState(() => _isSearching = true),
        onSearchChanged: (q) =>
            context.read<P2pMeetingsBloc>().add(P2pMeetingsSearchChanged(q)),
        onSearchClose: () {
          _searchController.clear();
          context.read<P2pMeetingsBloc>().add(const P2pMeetingsSearchChanged(''));
          setState(() => _isSearching = false);
        },
        showNotifications: false,
        showProfile: true,
        onProfileTap: () => Navigator.pushNamed(context, AppRoutes.profile),
        onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
      ),
      body: SafeArea(
        top: false,
        child: ResponsiveContainer(
          child: BlocConsumer<P2pMeetingsBloc, P2pMeetingsState>(
            listener: (context, state) {
              if (state.successMessage != null) {
                AppSnackBar.showSuccess(context, state.successMessage!);
              }
              if (state.status == P2pMeetingsStatus.failure && state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              final subLabels = _mainTabIndex == 0 ? _completedLabels : _scheduledLabels;
              final subIcons = _mainTabIndex == 0 ? _completedIcons : _scheduledIcons;
              final subIndex = _mainTabIndex == 0 ? _completedSubIndex : _scheduledSubIndex;
              final badges = _mainTabIndex == 1 && state.rescheduleRequests.isNotEmpty
                  ? {2: state.rescheduleRequests.length}
                  : null;

              return Stack(
                children: [
                  Column(
                    children: [
                      P2pSubTabChips(
                        labels: subLabels,
                        icons: subIcons,
                        selectedIndex: subIndex,
                        badges: badges,
                        onSelected: _onSubTabChanged,
                      ),
                      Expanded(
                        child: _mainTabIndex == 0
                            ? P2pCompletedListView(
                                isLoading: state.status == P2pMeetingsStatus.loading,
                                errorMessage: state.errorMessage,
                                items: state.filteredCompletedMeetings,
                                onRefresh: () async => context
                                    .read<P2pMeetingsBloc>()
                                    .add(const P2pMeetingsRefreshRequested()),
                                isInitiatedByMe: _completedSubIndex == 0,
                              )
                            : P2pScheduledListView(
                                isLoading: state.status == P2pMeetingsStatus.loading,
                                errorMessage: state.errorMessage,
                                requests: state.filteredScheduledRequests,
                                reschedules: state.filteredRescheduleRequests,
                                subTabIndex: _scheduledSubIndex,
                                onRefresh: () async => context
                                    .read<P2pMeetingsBloc>()
                                    .add(const P2pMeetingsRefreshRequested()),
                                onAccept: (id) => context
                                    .read<P2pMeetingsBloc>()
                                    .add(P2pMeetingAcceptRequested(id)),
                                onReject: (id) => context
                                    .read<P2pMeetingsBloc>()
                                    .add(P2pMeetingRejectRequested(id)),
                                onCancel: (id) => context
                                    .read<P2pMeetingsBloc>()
                                    .add(P2pMeetingCancelRequested(id)),
                                onReschedule: (p) => context
                                    .read<P2pMeetingsBloc>()
                                    .add(P2pMeetingRescheduleRequested(p)),
                                onApproveReschedule: (id) => context
                                    .read<P2pMeetingsBloc>()
                                    .add(P2pMeetingRescheduleApproved(id)),
                                onRejectReschedule: (id) => context
                                    .read<P2pMeetingsBloc>()
                                    .add(P2pMeetingRescheduleRejected(id)),
                              ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: P2pMeetingsBottomNav(
                      activeTab: _mainTabIndex,
                      completedCount: state.iInitiatedMeetings.length +
                          state.peerInitiatedMeetings.length,
                      scheduledCount: state.receivedRequests.length +
                          state.rescheduleRequests.length,
                      onTabChanged: _onMainTabChanged,
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 34,
                    child: Center(
                      child: AddP2pMeetingFab(onTap: _onFabPressed),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
