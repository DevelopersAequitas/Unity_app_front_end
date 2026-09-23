import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../bloc/business_deals_bloc.dart';
import '../bloc/business_deals_event.dart';
import '../bloc/business_deals_state.dart';
import 'business_deal_leaderboard_tile.dart';

class BusinessDealLeaderboardView extends StatelessWidget {
  const BusinessDealLeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessDealsBloc, BusinessDealsState>(
      builder: (context, state) {
        final status = state.leaderboardStatus;
        final list = state.filteredLeaderboardList;

        if (status == BusinessDealsStatus.loading && list.isEmpty) {
          return const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue),
            ),
          );
        }

        if (status == BusinessDealsStatus.failure && list.isEmpty) {
          return _buildError(context, state.errorMessage);
        }

        return RefreshIndicator(
          color: AppColor.primaryBlue,
          onRefresh: () async => context
              .read<BusinessDealsBloc>()
              .add(const BusinessDealsFetchLeaderboardRequested(forceRefresh: true)),
          child: list.isEmpty
              ? _buildEmpty(state.searchQuery.isNotEmpty
                  ? 'No business deal leaders match search'
                  : 'No business deal leaders yet')
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: list.length,
                  itemBuilder: (context, index) =>
                      BusinessDealLeaderboardTile(item: list[index]),
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
          .read<BusinessDealsBloc>()
          .add(const BusinessDealsFetchLeaderboardRequested(forceRefresh: true)),
      screenName: 'Business Deals Leaderboard',
    );
  }
}
