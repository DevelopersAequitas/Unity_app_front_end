import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../bloc/coins/coins_bloc.dart';
import '../bloc/coins/coins_event.dart';
import '../bloc/coins/coins_state.dart';
import '../widgets/claim_activity_bottom_sheet.dart';
import '../widgets/claim_activity_tile.dart';
import '../widgets/claim_coins_bottom_nav.dart';
import '../widgets/claim_request_status_tile.dart';

class ClaimYourCoinScreen extends StatefulWidget {
  final int initialTabIndex;

  const ClaimYourCoinScreen({super.key, this.initialTabIndex = 0});

  @override
  State<ClaimYourCoinScreen> createState() => _ClaimYourCoinScreenState();
}

class _ClaimYourCoinScreenState extends State<ClaimYourCoinScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _currentIndex = 0;
  String? _submittingActivityCode;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex.clamp(0, 1);
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _currentIndex,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging && mounted) {
        setState(() => _currentIndex = _tabController.index);
      }
    });
    context.read<CoinsBloc>().add(const FetchCoinClaimActivitiesEvent());
    context.read<CoinsBloc>().add(const FetchCoinClaimsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleClaimPressed(BuildContext ctx, dynamic activity) async {
    final result = await ClaimActivityBottomSheet.show(ctx, activity: activity);
    if (result != null && mounted) {
      setState(() => _submittingActivityCode = activity.code);
      context.read<CoinsBloc>().add(
            SubmitCoinClaimEvent(
              activityCode: result['activity_code'] as String,
              fields: result['fields'] as Map<String, dynamic>,
              proofFile: result['proof_file'] as File?,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<CoinsBloc, CoinsState>(
      listenWhen: (prev, curr) => prev.claimSubmitStatus != curr.claimSubmitStatus,
      listener: (context, state) {
        if (state.claimSubmitStatus == CoinsClaimStatus.success) {
          setState(() {
            _submittingActivityCode = null;
            _currentIndex = 1;
          });
          _tabController.animateTo(1);
          AppSnackBar.showSuccess(
            context,
            state.claimSubmitMessage ?? 'Coin claim submitted successfully!',
          );
          context.read<CoinsBloc>().add(const ResetCoinClaimStatusEvent());
        } else if (state.claimSubmitStatus == CoinsClaimStatus.failure) {
          setState(() => _submittingActivityCode = null);
          AppSnackBar.showError(
            context,
            state.claimSubmitMessage ?? 'Failed to submit coin claim.',
          );
          context.read<CoinsBloc>().add(const ResetCoinClaimStatusEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark ? AppColor.darkBackground : AppColor.lightBackground,
          appBar: const AppCommonBar(
            title: 'Claim Coins',
            showBack: true,
            showSearch: false,
            showNotifications: false,
            showProfile: false,
          ),
          bottomNavigationBar: ClaimCoinsBottomNav(
            activeIndex: _currentIndex,
            onIndexChanged: (idx) {
              setState(() => _currentIndex = idx);
              _tabController.animateTo(idx);
            },
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildActivitiesTab(context, state),
              _buildRequestsTab(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivitiesTab(BuildContext context, CoinsState state) {
    if (state.activitiesStatus == CoinsStatus.loading && state.activities.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (state.activitiesStatus == CoinsStatus.failure && state.activities.isEmpty) {
      return _buildErrorView(
        message: state.activitiesError ?? 'Failed to load claim activities',
        onRetry: () => context.read<CoinsBloc>().add(const FetchCoinClaimActivitiesEvent()),
      );
    }
    if (state.activities.isEmpty) {
      return _buildEmptyView(icon: Icons.hourglass_empty_rounded, message: 'No claim activities available at the moment.');
    }

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async => context.read<CoinsBloc>().add(const FetchCoinClaimActivitiesEvent(isRefresh: true)),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.activities.length,
        itemBuilder: (ctx, index) {
          final act = state.activities[index];
          return ClaimActivityTile(
            activity: act,
            isSubmitting: _submittingActivityCode == act.code,
            onClaim: () => _handleClaimPressed(context, act),
          );
        },
      ),
    );
  }

  Widget _buildRequestsTab(BuildContext context, CoinsState state) {
    if (state.claimsStatus == CoinsStatus.loading && state.claims.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (state.claimsStatus == CoinsStatus.failure && state.claims.isEmpty) {
      return _buildErrorView(
        message: state.claimsError ?? 'Failed to load past claims',
        onRetry: () => context.read<CoinsBloc>().add(const FetchCoinClaimsEvent()),
      );
    }
    if (state.claims.isEmpty) {
      return _buildEmptyView(icon: Icons.inbox_outlined, message: 'No claim requests yet. Submit a claim to earn coins!');
    }

    return RefreshIndicator(
      color: AppColor.primaryBlue,
      onRefresh: () async => context.read<CoinsBloc>().add(const FetchCoinClaimsEvent(isRefresh: true)),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.claims.length,
        itemBuilder: (ctx, index) => ClaimRequestStatusTile(claim: state.claims[index]),
      ),
    );
  }

  Widget _buildEmptyView({required IconData icon, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColor.lightTextSecondary),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: AppTypography.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView({required String message, required VoidCallback onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40, color: AppColor.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: AppTypography.bodyMedium),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
