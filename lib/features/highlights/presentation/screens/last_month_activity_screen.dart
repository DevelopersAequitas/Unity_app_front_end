import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/last_month_activity/last_month_activity_bloc.dart';
import '../bloc/last_month_activity/last_month_activity_event.dart';
import '../bloc/last_month_activity/last_month_activity_state.dart';
import '../widgets/activity_breakdown_card.dart';
import '../widgets/activity_header_card.dart';
import '../widgets/activity_metric_grid.dart';
import '../widgets/activity_script_card.dart';

class LastMonthActivityScreen extends StatefulWidget {
  const LastMonthActivityScreen({super.key});

  @override
  State<LastMonthActivityScreen> createState() => _LastMonthActivityScreenState();
}

class _LastMonthActivityScreenState extends State<LastMonthActivityScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<LastMonthActivityBloc>();
    if (bloc.state.status == LastMonthActivityStatus.initial) {
      bloc.add(const FetchLastMonthActivityEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Last Month Activity',
        showBack: Navigator.canPop(context),
        showProfile: true,
        onProfileTap: () => Navigator.pushNamed(context, AppRoutes.profile),
        onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocBuilder<LastMonthActivityBloc, LastMonthActivityState>(
            builder: (context, state) {
              if (state.status == LastMonthActivityStatus.loading &&
                  state.activity.userName.isEmpty &&
                  state.activity.p2pMeetings == 0) {
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue),
                  ),
                );
              }

              if (state.status == LastMonthActivityStatus.failure &&
                  state.activity.gratitudeStatement.isEmpty) {
                return _buildError(context, state.errorMessage);
              }

              return RefreshIndicator(
                color: AppColor.primaryBlue,
                onRefresh: () async {
                  context.read<LastMonthActivityBloc>().add(const FetchLastMonthActivityEvent(isRefresh: true));
                },
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  children: [
                    ActivityHeaderCard(activity: state.activity),
                    const SizedBox(height: 12),
                    ActivityMetricGrid(activity: state.activity),
                    const SizedBox(height: 12),
                    ActivityBreakdownCard(activity: state.activity),
                    const SizedBox(height: 12),
                    ActivityScriptCard(
                      statement: state.activity.gratitudeStatement,
                      periodName: state.activity.periodName,
                    ),
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

  Widget _buildError(BuildContext context, String? message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40, color: AppColor.error),
            const SizedBox(height: 12),
            Text(message ?? 'Failed to load activity', style: AppTypography.bodyMedium),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.read<LastMonthActivityBloc>().add(const FetchLastMonthActivityEvent()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

