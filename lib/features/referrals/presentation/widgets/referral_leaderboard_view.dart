import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../bloc/referrals_bloc.dart';
import '../bloc/referrals_event.dart';
import '../bloc/referrals_state.dart';
import 'referral_leaderboard_tile.dart';

class ReferralLeaderboardView extends StatelessWidget {
  const ReferralLeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReferralsBloc, ReferralsState>(
      builder: (context, state) {
        final list = state.filteredLeaderboardList;
        final isLoading = state.leaderboardStatus == ReferralsStatus.loading && list.isEmpty;

        if (isLoading) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue),
            ),
          );
        }

        if (state.leaderboardStatus == ReferralsStatus.failure && list.isEmpty) {
          return _buildError(context, state.errorMessage);
        }

        return RefreshIndicator(
          color: AppColor.primaryBlue,
          onRefresh: () async => context
              .read<ReferralsBloc>()
              .add(const ReferralsFetchLeaderboardRequested(forceRefresh: true)),
          child: list.isEmpty
              ? _buildEmpty(state.searchQuery.isNotEmpty
                  ? 'No referral leaders match search'
                  : 'No referral leaders yet')
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: list.length,
                  itemBuilder: (context, index) =>
                      ReferralLeaderboardTile(item: list[index]),
                ),
        );
      },
    );
  }

  Widget _buildEmpty(String text) {
    return ListView(
      children: [
        const SizedBox(height: 60),
        Center(
          child: Text(text, style: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextSecondary)),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String? message) {
    return AppErrorView(
      title: 'Unable to Load Leaderboard',
      message: message,
      onRetry: () => context
          .read<ReferralsBloc>()
          .add(const ReferralsFetchLeaderboardRequested(forceRefresh: true)),
      screenName: 'Referrals Leaderboard',
    );
  }
}
