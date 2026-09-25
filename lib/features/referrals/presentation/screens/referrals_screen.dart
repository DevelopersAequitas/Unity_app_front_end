import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/offline_prompt_dialog.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/referral_entity.dart';
import '../../domain/usecases/get_given_referrals_usecase.dart';
import '../../domain/usecases/get_received_referrals_usecase.dart';
import '../../domain/usecases/get_referral_statuses_usecase.dart';
import '../../domain/usecases/get_referrals_leaderboard_usecase.dart';
import '../../domain/usecases/get_referrals_stats_usecase.dart';
import '../../domain/usecases/update_referral_status_usecase.dart';
import '../bloc/referrals_bloc.dart';
import '../bloc/referrals_event.dart';
import '../bloc/referrals_state.dart';
import '../widgets/add_referral_fab.dart';
import '../widgets/referral_empty_state.dart';
import '../widgets/referral_error_view.dart';
import '../widgets/referral_leaderboard_view.dart';
import '../widgets/referral_list_view.dart';
import '../widgets/referral_skeleton_list.dart';
import '../widgets/referral_success_sheet.dart';
import '../widgets/referrals_bottom_nav.dart';

class ReferralsScreen extends StatelessWidget {
  final bool isModal;
  final ReferralTab initialTab;

  const ReferralsScreen({
    super.key,
    this.isModal = false,
    this.initialTab = ReferralTab.received,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) {
        final bloc = ReferralsBloc(
          getReceivedReferralsUseCase: ctx.read<GetReceivedReferralsUseCase>(),
          getGivenReferralsUseCase: ctx.read<GetGivenReferralsUseCase>(),
          getReferralsStatsUseCase: ctx.read<GetReferralsStatsUseCase>(),
          getReferralStatusesUseCase: ctx.read<GetReferralStatusesUseCase>(),
          updateReferralStatusUseCase: ctx.read<UpdateReferralStatusUseCase>(),
          getReferralsLeaderboardUseCase: ctx.read<GetReferralsLeaderboardUseCase>(),
        )
          ..add(const ReferralsFetchLeaderboardRequested())
          ..add(const ReferralsFetchStatsRequested())
          ..add(const ReferralsStatusesFetchRequested());
        if (initialTab != ReferralTab.received) {
          bloc.add(ReferralsTabChanged(initialTab));
        }
        return bloc;
      },
      child: _ReferralsView(isModal: isModal),
    );
  }
}

class _ReferralsView extends StatefulWidget {
  final bool isModal;
  const _ReferralsView({required this.isModal});

  @override
  State<_ReferralsView> createState() => _ReferralsViewState();
}

class _ReferralsViewState extends State<_ReferralsView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final bloc = context.read<ReferralsBloc>();
      if (bloc.state.activeTab == ReferralTab.received) {
        bloc.add(const ReferralsLoadMoreReceivedRequested());
      } else if (bloc.state.activeTab == ReferralTab.given) {
        bloc.add(const ReferralsLoadMoreGivenRequested());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddReferral() async {
    if (!OfflineGuard.check(context, actionName: 'share referrals')) {
      return;
    }
    final result = await Navigator.pushNamed(context, AppRoutes.addReferral);
    if (!mounted || result == null) return;

    if (result is Map && result['success'] == true) {
      final createdReferral = result['referral'];
      final coins = (result['coinsEarned'] as int?) ??
          (createdReferral is ReferralEntity ? createdReferral.coinsEarned : null);
      final impact = (result['impactEarned'] as int?) ??
          (createdReferral is ReferralEntity ? createdReferral.impactEarned : null);

      context.read<ReferralsBloc>().add(const ReferralsTabChanged(ReferralTab.given));
      if (createdReferral is ReferralEntity) {
        context.read<ReferralsBloc>().add(ReferralCreatedLocally(createdReferral));
      }
      context.read<ReferralsBloc>().add(const ReferralsFetchGivenRequested(forceRefresh: true));

      if (mounted) {
        ReferralSuccessSheet.show(
          context,
          coinsEarned: coins,
          impactEarned: impact,
          onDone: () => Navigator.pop(context),
          onAddAnother: () {
            Navigator.pop(context);
            _openAddReferral();
          },
        );
      }
    }
  }

  Widget _buildStatusFilterBar(BuildContext context, ReferralsState state) {
    final filters = [
      {'label': 'All', 'value': null},
      {'label': 'Pending', 'value': 'Pending'},
      {'label': 'Contacted', 'value': 'Contacted'},
      {'label': 'Got Business', 'value': 'Got Business'},
      {'label': 'Not Qualified', 'value': 'Not Qualified'},
    ];

    return Container(
      height: 38,
      margin: const EdgeInsets.only(top: 4, bottom: 6),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = filters[index];
          final String label = item['label'] as String;
          final val = item['value'];
          final isSelected = state.statusFilter == val;

          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => context.read<ReferralsBloc>().add(ReferralsStatusFilterChanged(val)),
            labelStyle: TextStyle(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? AppColor.white : AppColor.lightTextSecondary,
            ),
            selectedColor: AppColor.primaryBlue,
            backgroundColor: AppColor.lightSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isSelected ? AppColor.primaryBlue : AppColor.lightBorder,
                width: 0.8,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      appBar: AppCommonBar(
        title: 'Referrals',
        showBack: Navigator.canPop(context),
        showSearch: true,
        isSearching: _isSearching,
        searchController: _searchController,
        searchHint: 'Search referral name, peer, city, phone...',
        onSearchTap: () => setState(() => _isSearching = true),
        onSearchChanged: (q) => context.read<ReferralsBloc>().add(ReferralsSearchChanged(q)),
        onSearchClose: () {
          _searchController.clear();
          context.read<ReferralsBloc>().add(const ReferralsSearchChanged(''));
          setState(() => _isSearching = false);
        },
        showNotifications: false,
        showProfile: false,
        showChat: false,
        onProfileTap: () => Navigator.pushNamed(context, AppRoutes.profile),
        onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
      ),
      body: SafeArea(
        top: false,
        child: ResponsiveContainer(
          child: BlocBuilder<ReferralsBloc, ReferralsState>(
            builder: (context, state) {
              final activeTab = state.activeTab;

              return Stack(
                children: [
                  Column(
                    children: [
                      if (activeTab != ReferralTab.leaderboard) _buildStatusFilterBar(context, state),
                      Expanded(
                        child: activeTab == ReferralTab.leaderboard
                            ? const ReferralLeaderboardView()
                            : _buildBodyContent(context, state),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ReferralsBottomNav(
                      activeTab: activeTab,
                      onTabChanged: (tab) => context.read<ReferralsBloc>().add(ReferralsTabChanged(tab)),
                    ),
                  ),
                  if (activeTab != ReferralTab.leaderboard)
                    Positioned(
                      right: 16,
                      bottom: 76,
                      child: AddReferralFab(onTap: _openAddReferral),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent(BuildContext context, ReferralsState state) {
    final activeTab = state.activeTab;
    final status = state.currentStatus;
    final list = state.currentList;

    if (status == ReferralsStatus.loading && list.isEmpty) {
      return const ReferralSkeletonList();
    }
    if (status == ReferralsStatus.failure && list.isEmpty) {
      return ReferralErrorView(
        onRetry: () {
          final isRec = activeTab == ReferralTab.received;
          context.read<ReferralsBloc>().add(isRec
              ? const ReferralsFetchReceivedRequested(forceRefresh: true)
              : const ReferralsFetchGivenRequested(forceRefresh: true));
        },
      );
    }
    if (list.isEmpty) {
      return ReferralEmptyState(
        tab: activeTab,
        searchQuery: state.searchQuery,
        statusFilter: state.statusFilter,
        onActionTap: _openAddReferral,
      );
    }
    return ReferralListView(
      referrals: list,
      tabType: activeTab == ReferralTab.received ? 'received' : 'given',
      scrollController: _scrollController,
      isLoadingMore: context.select<ReferralsBloc, bool>((b) => b.state.isLoadingMore),
      onRefresh: () async {
        final isRec = activeTab == ReferralTab.received;
        context.read<ReferralsBloc>().add(isRec
            ? const ReferralsFetchReceivedRequested(forceRefresh: true)
            : const ReferralsFetchGivenRequested(forceRefresh: true));
      },
    );
  }
}
