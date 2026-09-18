import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/gratitude_script/gratitude_script_bloc.dart';
import '../bloc/gratitude_script/gratitude_script_event.dart';
import '../bloc/gratitude_script/gratitude_script_state.dart';
import '../widgets/gratitude_card_preview.dart';
import '../widgets/gratitude_form.dart';
import '../widgets/script_stats_banner.dart';

class GratitudeScriptScreen extends StatefulWidget {
  const GratitudeScriptScreen({super.key});

  @override
  State<GratitudeScriptScreen> createState() => _GratitudeScriptScreenState();
}

class _GratitudeScriptScreenState extends State<GratitudeScriptScreen> {
  late final TextEditingController _progressController;
  late final TextEditingController _goalController;
  late final TextEditingController _storyController;

  @override
  void initState() {
    super.initState();
    _progressController = TextEditingController();
    _goalController = TextEditingController();
    _storyController = TextEditingController();
    final bloc = context.read<GratitudeScriptBloc>();
    if (bloc.state.status == GratitudeScriptStatus.initial) {
      bloc.add(const FetchGratitudeScriptEvent());
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _goalController.dispose();
    _storyController.dispose();
    super.dispose();
  }

  void _onSave() {
    context.read<GratitudeScriptBloc>().add(
          SaveGratitudeScriptEvent(
            progressWord: _progressController.text.trim(),
            nextMonthGoal: _goalController.text.trim(),
            experienceStory: _storyController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppCommonBar(
        title: 'Monthly Impact Script',
        showBack: Navigator.canPop(context),
        showProfile: true,
        onProfileTap: () => Navigator.pushNamed(context, AppRoutes.profile),
        onBackTap: Navigator.canPop(context) ? () => Navigator.pop(context) : null,
      ),
      body: AppGradientBackground(
        child: ResponsiveContainer(
          child: BlocConsumer<GratitudeScriptBloc, GratitudeScriptState>(
            listener: (context, state) {
              if (state.successMessage != null) {
                AppSnackBar.showSuccess(context, state.successMessage!);
              } else if (state.errorMessage != null) {
                AppSnackBar.showError(context, state.errorMessage!);
              }
            },
            builder: (context, state) {
              if (state.status == GratitudeScriptStatus.loading &&
                  state.script.authorName.isEmpty) {
                return const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primaryBlue),
                  ),
                );
              }

              if (state.status == GratitudeScriptStatus.failure &&
                  state.script.authorName.isEmpty) {
                return _buildError(context, state.errorMessage);
              }

              if (_progressController.text.isEmpty && state.script.progressWord.isNotEmpty) {
                _progressController.text = state.script.progressWord;
              }
              if (_goalController.text.isEmpty && state.script.nextMonthGoal.isNotEmpty) {
                _goalController.text = state.script.nextMonthGoal;
              }
              if (_storyController.text.isEmpty && state.script.experienceStory.isNotEmpty) {
                _storyController.text = state.script.experienceStory;
              }

              return RefreshIndicator(
                color: AppColor.primaryBlue,
                onRefresh: () async => context
                    .read<GratitudeScriptBloc>()
                    .add(const FetchGratitudeScriptEvent(isRefresh: true)),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  children: [
                    ScriptStatsBanner(script: state.script),
                    const SizedBox(height: 12),
                    GratitudeCardPreview(script: state.script),
                    const SizedBox(height: 14),
                    GratitudeForm(
                      progressController: _progressController,
                      goalController: _goalController,
                      storyController: _storyController,
                      onSave: _onSave,
                      isSaving: state.isSaving,
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
            Text(message ?? 'Failed to load script', style: AppTypography.bodyMedium),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context
                  .read<GratitudeScriptBloc>()
                  .add(const FetchGratitudeScriptEvent()),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

