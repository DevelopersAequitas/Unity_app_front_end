import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/usecases/submit_circle_join_usecase.dart';
import '../bloc/circle_join_bloc.dart';
import '../bloc/circle_join_event.dart';
import '../bloc/circle_join_state.dart';
import '../widgets/join/circle_join_custom_role_input.dart';
import '../widgets/join/circle_join_reason_input.dart';
import '../widgets/join/circle_join_specialization_card.dart';
import 'circle_subcategories_screen.dart';

class CircleJoinScreen extends StatelessWidget {
  final String circleId;
  final String? defaultSectorName;
  final String? defaultSectorId;
  final CircleCategoryEntity? preselectedCategory;
  final bool isOtherCategory;

  const CircleJoinScreen({
    super.key,
    required this.circleId,
    this.defaultSectorName,
    this.defaultSectorId,
    this.preselectedCategory,
    this.isOtherCategory = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CircleJoinBloc(
        submitCircleJoinUseCase: context.read<SubmitCircleJoinUseCase>(),
        initialCategory: preselectedCategory,
        initialIsOther: isOtherCategory,
      ),
      child: _CircleJoinView(
        circleId: circleId,
        defaultSectorName: defaultSectorName,
        defaultSectorId: defaultSectorId,
      ),
    );
  }
}

class _CircleJoinView extends StatefulWidget {
  final String circleId;
  final String? defaultSectorName;
  final String? defaultSectorId;

  const _CircleJoinView({
    required this.circleId,
    this.defaultSectorName,
    this.defaultSectorId,
  });

  @override
  State<_CircleJoinView> createState() => _CircleJoinViewState();
}

class _CircleJoinViewState extends State<_CircleJoinView> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _customCategoryController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  Future<void> _openPicker(BuildContext context, CircleJoinState state) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => CircleSubcategoriesScreen(
          circleId: widget.circleId,
          circleName: widget.defaultSectorName ?? 'Circle',
          isPicker: true,
          initialSelectedCategory: state.selectedSubcategory,
          initialIsOther: state.isOtherSelected,
        ),
      ),
    );
    if (result != null && context.mounted) {
      context.read<CircleJoinBloc>().add(
            CircleJoinSubcategoryUpdated(
              subcategory: result['category'] as CircleCategoryEntity?,
              isOther: result['isOther'] == true,
            ),
          );
    }
  }

  void _submit(BuildContext context, CircleJoinState state) {
    if (!state.hasValidSelection) {
      AppSnackBar.showError(context, 'Please choose your specialization');
      return;
    }
    if (state.isOtherSelected && _customCategoryController.text.trim().isEmpty) {
      AppSnackBar.showError(context, 'Please enter your custom specialization name');
      return;
    }
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      AppSnackBar.showError(context, 'Please enter why you want to join this circle');
      return;
    }

    final customName = state.isOtherSelected ? _customCategoryController.text.trim() : null;
    final finalReason = (state.isOtherSelected && customName != null)
        ? 'Custom Role: $customName\n$reason'
        : reason;

    context.read<CircleJoinBloc>().add(
          CircleJoinSubmitted(
            circleId: widget.circleId,
            reason: finalReason,
            defaultSectorId: widget.defaultSectorId,
            customCategoryName: customName,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return BlocConsumer<CircleJoinBloc, CircleJoinState>(
      listener: (context, state) {
        if (state.status == CircleJoinStatus.error) {
          AppSnackBar.showError(context, state.errorMessage ?? 'Submission failed');
        } else if (state.status == CircleJoinStatus.success && state.submittedRequest != null) {
          AppSnackBar.showSuccess(context, 'Join request submitted successfully');
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.joinRequestStatus,
            arguments: {
              'requestId': state.submittedRequest!.id,
              'circleName': state.submittedRequest!.circleName.isNotEmpty
                  ? state.submittedRequest!.circleName
                  : (widget.defaultSectorName ?? 'Circle'),
            },
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == CircleJoinStatus.submitting;

        return Scaffold(
          backgroundColor: AppColor.transparent,
          appBar: AppCommonBar(
            title: 'Join Circle',
            showBack: true,
            showSearch: false,
            showNotifications: false,
            showProfile: false,
            onBackTap: () => Navigator.of(context).pop(),
          ),
          body: AppGradientBackground(
            child: ResponsiveContainer(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.defaultSectorName != null) ...[
                      Text('Circle Category', style: AppTypography.labelSmall.copyWith(color: secondaryText)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.groups_outlined, size: 20, color: AppColor.primaryBlue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.defaultSectorName!,
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: primaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    CircleJoinSpecializationCard(
                      selectedSubcategory: state.selectedSubcategory,
                      isOtherSelected: state.isOtherSelected,
                      onTap: () => _openPicker(context, state),
                    ),
                    const SizedBox(height: 16),
                    if (state.isOtherSelected) ...[
                      CircleJoinCustomRoleInput(controller: _customCategoryController),
                      const SizedBox(height: 16),
                    ],
                    CircleJoinReasonInput(controller: _reasonController),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : () => _submit(context, state),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryBlue,
                          foregroundColor: AppColor.white,
                          disabledBackgroundColor: AppColor.primaryBlue.withValues(alpha: 0.4),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.white),
                              )
                            : Text(
                                'Submit Join Request',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
