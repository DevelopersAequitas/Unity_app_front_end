import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/coins/coins_bloc.dart';
import '../bloc/coins/coins_event.dart';
import '../bloc/coins/coins_state.dart';
import '../widgets/coin_transaction_tile.dart';
import '../widgets/coins_balance_card.dart';
import '../widgets/milestone_badges_view.dart';

class CoinsScreen extends StatelessWidget {
  const CoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Coins & Badges'),
        centerTitle: true,
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
            onRefresh: () async => context.read<CoinsBloc>().add(const FetchCoinsWalletEvent(isRefresh: true)),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CoinsBalanceCard(balance: state.wallet.balance),
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

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.history_rounded, size: 40, color: AppColor.lightTextSecondary),
          const SizedBox(height: 8),
          Text(
            'No coin transactions yet',
            style: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40, color: AppColor.error),
            const SizedBox(height: 12),
            Text(message ?? 'Failed to load coin history', style: AppTypography.bodyMedium),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.read<CoinsBloc>().add(const FetchCoinsWalletEvent()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
