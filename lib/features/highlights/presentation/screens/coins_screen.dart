import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../bloc/coins/coins_bloc.dart';
import '../bloc/coins/coins_event.dart';
import '../bloc/coins/coins_state.dart';
import '../widgets/claim_request_status_tile.dart';
import '../widgets/coin_transaction_tile.dart';
import '../widgets/coins_balance_card.dart';
import '../widgets/milestone_badges_view.dart';
import 'claim_coins_form_screen.dart';

class CoinsScreen extends StatelessWidget {
  const CoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColor.darkBackground : AppColor.lightBackground,
      appBar: const AppCommonBar(
        title: 'My Coins & Badges',
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openClaimForm(context),
        backgroundColor: AppColor.primaryBlue,
        icon: const Icon(Icons.add_task_rounded, color: Colors.white, size: 20),
        label: const Text(
          'Claim Coins',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: BlocBuilder<CoinsBloc, CoinsState>(
        builder: (context, state) {
          if (state.status == CoinsStatus.loading && state.wallet.transactions.isEmpty) {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          if (state.status == CoinsStatus.failure && state.wallet.transactions.isEmpty) {
            return _buildError(context, state.errorMessage);
          }

          return RefreshIndicator(
            color: AppColor.primaryBlue,
            onRefresh: () async {
              context.read<CoinsBloc>().add(const FetchCoinsWalletEvent(isRefresh: true));
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              children: [
                CoinsBalanceCard(balance: state.wallet.balance),
                const SizedBox(height: 16),
                _buildClaimCtaCard(context),
                if (state.claims.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('My Claims', style: AppTypography.titleMedium),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${state.claims.length}',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColor.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...state.claims.map((c) => ClaimRequestStatusTile(claim: c)),
                ],
                const SizedBox(height: 24),
                Text('Milestone Badges', style: AppTypography.titleMedium),
                const SizedBox(height: 12),
                MilestoneBadgesView(badges: state.wallet.badges),
                const SizedBox(height: 24),
                Text('Transaction History', style: AppTypography.titleMedium),
                const SizedBox(height: 12),
                if (state.wallet.transactions.isEmpty)
                  _buildEmpty()
                else
                  ...state.wallet.transactions.map((t) => CoinTransactionTile(transaction: t)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openClaimForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ClaimCoinsFormScreen()),
    );
  }

  Widget _buildClaimCtaCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => _openClaimForm(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColor.primaryBlue.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/images/coin.png', width: 20, height: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Did an offline activity?',
                    style: AppTypography.titleMedium.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Submit a claim to earn coins for your contributions',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColor.primaryBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.history_rounded, size: 36, color: AppColor.lightTextSecondary),
          const SizedBox(height: 6),
          Text(
            'No coin transactions yet',
            style: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String? message) {
    return AppErrorView(
      title: 'Unable to Load Coin History',
      message: message,
      onRetry: () =>
          context.read<CoinsBloc>().add(const FetchCoinsWalletEvent()),
      screenName: 'Coins & Badges',
    );
  }
}
