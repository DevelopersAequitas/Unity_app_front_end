import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../bloc/life_impact/life_impact_bloc.dart';
import '../bloc/life_impact/life_impact_event.dart';
import '../bloc/life_impact/life_impact_state.dart';
import '../widgets/add_impact_bottom_sheet.dart';
import '../widgets/life_impact_hero_card.dart';
import '../widgets/life_impact_tile.dart';

class LifeImpactScreen extends StatelessWidget {
  const LifeImpactScreen({super.key});

  void _openAddImpact(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<LifeImpactBloc>(),
        child: BlocConsumer<LifeImpactBloc, LifeImpactState>(
          listenWhen: (prev, curr) => curr.successMessage != null && prev.successMessage != curr.successMessage,
          listener: (ctx, state) {
            Navigator.pop(ctx);
            AppSnackBar.showSuccess(context, state.successMessage!);
          },
          builder: (ctx, state) => AddImpactBottomSheet(
            isSubmitting: state.isSubmitting,
            onSubmit: (title, description, category, points) {
              ctx.read<LifeImpactBloc>().add(
                    SubmitLifeImpactEvent(
                      title: title,
                      description: description,
                      category: category,
                      impactPoints: points,
                    ),
                  );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lives Impacted'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddImpact(context),
        backgroundColor: AppColor.primaryBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Record Impact'),
      ),
      body: BlocConsumer<LifeImpactBloc, LifeImpactState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            AppSnackBar.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          if (state.status == LifeImpactStatus.loading && state.history.isEmpty) {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          if (state.status == LifeImpactStatus.failure && state.history.isEmpty) {
            return _buildError(context, state.errorMessage);
          }

          return RefreshIndicator(
            color: AppColor.primaryBlue,
            onRefresh: () async => context.read<LifeImpactBloc>().add(const FetchLifeImpactHistoryEvent(isRefresh: true)),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              children: [
                LifeImpactHeroCard(totalScore: state.totalScore),
                const SizedBox(height: 24),
                Text('Impact Timeline', style: AppTypography.titleMedium),
                const SizedBox(height: 12),
                if (state.history.isEmpty)
                  _buildEmpty()
                else
                  ...state.history.map((item) => LifeImpactTile(item: item)),
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
          Icon(Icons.bolt_outlined, size: 40, color: AppColor.lightTextSecondary),
          const SizedBox(height: 8),
          Text(
            'No impact stories recorded yet',
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
            Text(message ?? 'Failed to load impact history', style: AppTypography.bodyMedium),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.read<LifeImpactBloc>().add(const FetchLifeImpactHistoryEvent()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
