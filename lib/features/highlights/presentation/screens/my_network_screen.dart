import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/my_network/my_network_bloc.dart';
import '../bloc/my_network/my_network_event.dart';
import '../bloc/my_network/my_network_state.dart';
import '../widgets/invite_code_card.dart';
import '../widgets/network_member_tile.dart';
import '../widgets/network_stats_grid.dart';

class MyNetworkScreen extends StatelessWidget {
  const MyNetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Invite Friends',
        showBack: Navigator.canPop(context),
        showProfile: true,
        onProfileTap: () => Navigator.pushNamed(context, AppRoutes.profile),
        onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocBuilder<MyNetworkBloc, MyNetworkState>(
            builder: (context, state) {
              if (state.status == MyNetworkStatus.loading && state.members.isEmpty) {
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue),
                  ),
                );
              }

              if (state.status == MyNetworkStatus.failure && state.members.isEmpty) {
                return _buildErrorState(context, state.errorMessage);
              }

              return RefreshIndicator(
                color: AppColor.primaryBlue,
                onRefresh: () async {
                  context.read<MyNetworkBloc>().add(const FetchMyNetworkDataEvent(isRefresh: true));
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: InviteCodeCard(
                        referralCode: state.stats.referralCode,
                        referralLink: state.stats.referralLink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: NetworkStatsGrid(stats: state.stats),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Invited & Referral Peers', style: AppTypography.titleSmall),
                          Text(
                            '${state.members.length} Peers',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColor.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (state.members.isEmpty)
                      _buildEmptyState()
                    else
                      ...state.members.map((m) => NetworkMemberTile(member: m)),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(Icons.people_outline_rounded, size: 40, color: AppColor.lightTextSecondary),
          const SizedBox(height: 8),
          Text(
            'No invited members yet',
            style: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40, color: AppColor.error),
            const SizedBox(height: 12),
            Text(error ?? 'Failed to load network data', style: AppTypography.bodyMedium),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.read<MyNetworkBloc>().add(const FetchMyNetworkDataEvent()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
