import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/milestone_entity.dart';
import '../bloc/milestone_bloc.dart';
import '../bloc/milestone_event.dart';
import '../bloc/milestone_state.dart';
import '../widgets/badge_detail_card.dart';

class CoinMilestonesScreen extends StatelessWidget {
  final String? userId;

  const CoinMilestonesScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return _CoinMilestonesView(userId: userId);
  }
}

class _CoinMilestonesView extends StatefulWidget {
  final String? userId;

  const _CoinMilestonesView({this.userId});

  @override
  State<_CoinMilestonesView> createState() => _CoinMilestonesViewState();
}

class _CoinMilestonesViewState extends State<_CoinMilestonesView>
    with SingleTickerProviderStateMixin {
  String? _resolvedUserId;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initUserId());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _initUserId() {
    if (widget.userId != null && widget.userId!.isNotEmpty) {
      _resolvedUserId = widget.userId;
    } else {
      final profile = context.read<ProfileBloc>().state.profile;
      _resolvedUserId = profile?.id;
    }
    if (mounted && _resolvedUserId != null && _resolvedUserId!.isNotEmpty) {
      context.read<MilestoneBloc>().add(
        FetchMilestonesEvent(userId: _resolvedUserId!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColor.darkBackground : AppColor.lightBackground,
      appBar: AppCommonBar(
        title: 'My Badges',
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: BlocBuilder<MilestoneBloc, MilestoneState>(
            buildWhen: (prev, curr) => prev.latestMilestone != curr.latestMilestone,
            builder: (context, state) {
              final latest = state.latestMilestone;
              final lifeCount = latest?.lifeImpactBadges.length ?? 0;
              final introCount = latest?.memberIntroBadges.length ?? 0;
              final coinsCount = latest?.coinsBadges.length ?? 0;

              return Container(
                color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: AppColor.primaryBlue,
                  unselectedLabelColor: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                  indicatorColor: AppColor.primaryBlue,
                  indicatorWeight: 2.5,
                  labelStyle: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w500),
                  unselectedLabelStyle: AppTypography.labelSmall,
                  tabs: [
                    Tab(text: 'Lives Impacted ($lifeCount)'),
                    Tab(text: 'Peers Introduced ($introCount)'),
                    Tab(text: 'Coins Earned ($coinsCount)'),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: BlocBuilder<MilestoneBloc, MilestoneState>(
        builder: (context, state) {
          if (state.status == MilestoneStatus.loading && state.latestMilestone == null) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue),
            );
          }

          if (state.status == MilestoneStatus.failure && state.latestMilestone == null) {
            return AppErrorView(
              title: 'Unable to Load Badges',
              message: state.errorMessage,
              onRetry: () {
                if (_resolvedUserId != null) {
                  context.read<MilestoneBloc>().add(
                      FetchMilestonesEvent(userId: _resolvedUserId!));
                } else {
                  _initUserId();
                }
              },
              screenName: 'Milestones & Badges',
            );
          }

          final latest = state.latestMilestone;
          final lifeBadges = latest?.lifeImpactBadges ?? [];
          final introBadges = latest?.memberIntroBadges ?? [];
          final coinsBadges = latest?.coinsBadges ?? [];

          return RefreshIndicator(
            color: AppColor.primaryBlue,
            onRefresh: () async {
              if (_resolvedUserId != null) {
                context.read<MilestoneBloc>().add(
                  FetchMilestonesEvent(userId: _resolvedUserId!, isRefresh: true),
                );
              } else {
                _initUserId();
              }
            },
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBadgeList(lifeBadges, 'No Lives Impacted badges earned yet.'),
                _buildBadgeList(introBadges, 'No Peers Introduced badges earned yet.'),
                _buildBadgeList(coinsBadges, 'No Coins Earned badges earned yet.'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadgeList(List<BadgeDetailEntity> badges, String emptyMsg) {
    if (badges.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.25),
          Center(
            child: Text(
              emptyMsg,
              style: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextSecondary),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: badges.length,
      itemBuilder: (context, index) => BadgeDetailCard(badge: badges[index]),
    );
  }
}
