import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/offline_prompt_dialog.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../domain/entities/membership_plan_entity.dart';
import '../../domain/usecases/get_membership_plans_usecase.dart';
import '../../domain/usecases/get_subscription_history_usecase.dart';
import '../../domain/usecases/initiate_plan_checkout_usecase.dart';
import '../../domain/usecases/verify_checkout_status_usecase.dart';
import '../bloc/membership_bloc.dart';
import '../bloc/membership_event.dart';
import '../bloc/membership_state.dart';
import '../widgets/paywall/paywall_features_grid.dart';
import '../widgets/paywall/paywall_footer_skyline.dart';
import '../widgets/paywall/paywall_hero_section.dart';
import '../widgets/paywall/paywall_plan_card.dart';

class MembershipPaywallScreen extends StatelessWidget {
  const MembershipPaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => MembershipBloc(
        getMembershipPlansUseCase: ctx.read<GetMembershipPlansUseCase>(),
        initiatePlanCheckoutUseCase: ctx.read<InitiatePlanCheckoutUseCase>(),
        verifyCheckoutStatusUseCase: ctx.read<VerifyCheckoutStatusUseCase>(),
        getSubscriptionHistoryUseCase: ctx
            .read<GetSubscriptionHistoryUseCase>(),
      )..add(const MembershipPlansFetchRequested()),
      child: const _PaywallView(),
    );
  }
}

class _PaywallView extends StatefulWidget {
  const _PaywallView();

  @override
  State<_PaywallView> createState() => _PaywallViewState();
}

class _PaywallViewState extends State<_PaywallView>
    with WidgetsBindingObserver {
  String? _activeHostedPageId;
  bool _isWaitingForPayment = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _isWaitingForPayment &&
        _activeHostedPageId != null) {
      context.read<MembershipBloc>().add(
        MembershipCheckoutStatusVerified(_activeHostedPageId!),
      );
    }
  }

  Future<void> _handleCheckout(String checkoutUrl, String hostedPageId) async {
    if (!OfflineGuard.check(context, actionName: 'open membership checkout')) {
      return;
    }
    _activeHostedPageId = hostedPageId;
    _isWaitingForPayment = true;
    try {
      final uri = Uri.parse(checkoutUrl);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri);
      }
    } catch (e) {
      _isWaitingForPayment = false;
      // Handled gracefully without popping intrusive errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = context.watch<ProfileBloc>().state.profile;
    final userPlanCode = profile?.zohoPlanCode;
    final isPro = profile?.isPro ?? false;

    return Scaffold(
      backgroundColor: isDark ? AppColor.darkBackground : AppColor.white,
      appBar: AppCommonBar(
        title: 'Peers Pro Membership',
        showBack: true,
        showSearch: false,
        showNotifications: false,
        showProfile: false,
        onBackTap: () => Navigator.of(context).pop(),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, size: 21),
            tooltip: 'Help & Support',
            onPressed: () => Navigator.of(context).pushNamed(
              AppRoutes.submitTicket,
              arguments: {
                'screen_name': 'Membership Paywall',
                'department': 'Billing & Membership',
                'subject': 'Help with Pro Membership',
              },
            ),
          ),
        ],
      ),
      body: BlocConsumer<MembershipBloc, MembershipState>(
        listener: (context, state) {
          if (state.status == MembershipStatus.checkoutReady &&
              state.checkoutSession != null) {
            _handleCheckout(
              state.checkoutSession!.checkoutUrl,
              state.checkoutSession!.hostedPageId,
            );
          } else if (state.status == MembershipStatus.verificationSuccess) {
            _isWaitingForPayment = false;
            _activeHostedPageId = null;
            AppSnackBar.showSuccess(
              context,
              '🎉 Membership payment confirmed! Welcome to Peers Pro.',
            );

            // 1. Instant real-time local update to ProfileBloc so UI updates without any delay
            final currentProfile = context.read<ProfileBloc>().state.profile;
            if (currentProfile != null) {
              final subStatus = state.subscriptionStatus;
              final planCode = subStatus?.zohoPlanCode ??
                  state.selectedPlan?.planCode ??
                  currentProfile.zohoPlanCode ??
                  '012';
              final updated = currentProfile.copyWith(
                isPro: true,
                membershipStatus: (subStatus?.membershipStatus != null &&
                        subStatus!.membershipStatus.isNotEmpty)
                    ? subStatus.membershipStatus
                    : 'Only Unity Peer',
                membershipStatusLabel: (subStatus?.membershipStatus != null &&
                        subStatus!.membershipStatus.isNotEmpty)
                    ? subStatus.membershipStatus
                    : 'Only Unity Peer',
                membershipStartsAt: subStatus?.membershipStartsAt?.toIso8601String() ??
                    currentProfile.membershipStartsAt,
                membershipEndsAt: subStatus?.membershipEndsAt?.toIso8601String() ??
                    currentProfile.membershipEndsAt,
                zohoPlanCode: planCode,
                zohoSubscriptionId: subStatus?.zohoSubscriptionId ??
                    currentProfile.zohoSubscriptionId,
              );
              context.read<ProfileBloc>().add(ProfileLocallyUpdated(updated));
            }

            // 2. Force network refresh to fetch and cache the authoritative updated profile from backend
            context.read<ProfileBloc>().add(
              const ProfileFetchRequested(forceRefresh: true),
            );
            context.read<MembershipBloc>().add(
              const MembershipPlansFetchRequested(),
            );
          } else if (state.status == MembershipStatus.verificationFailed) {
            _isWaitingForPayment = false;
          } else if (state.status == MembershipStatus.error) {
            _isWaitingForPayment = false;
            // Failure is handled in-screen via AppErrorView; no snackbar shown
          }
        },
        builder: (context, state) {
          final plans = state.plans;
          final isLoading =
              state.status == MembershipStatus.loading && plans.isEmpty;
          final isCheckoutLoading =
              state.status == MembershipStatus.checkoutLoading;
          final isVerifying = state.status == MembershipStatus.verifying;
          final selectedPlan =
              state.selectedPlan ??
              (isPro && userPlanCode != null
                  ? plans.where((p) => p.planCode == userPlanCode).firstOrNull
                  : null) ??
              (plans.isNotEmpty ? plans.first : null);

          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.primaryBlue,
              ),
            );
          }

          if (state.status == MembershipStatus.error && plans.isEmpty) {
            return AppErrorView(
              screenName: 'Membership Paywall',
              message: state.errorMessage,
              onRetry: () => context.read<MembershipBloc>().add(
                const MembershipPlansFetchRequested(),
              ),
            );
          }

          return Container(
            color: isDark ? AppColor.darkBackground : AppColor.white,
            child: SafeArea(
              top: false,
              child: ResponsiveContainer(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const PaywallHeroSection(),
                          const PaywallFeaturesGrid(),
                          const SizedBox(height: 10),
                          _buildPlansHeader(context),
                          const SizedBox(height: 8),
                          _buildPlansRow(
                            context,
                            plans,
                            selectedPlan,
                            userPlanCode,
                            isPro,
                          ),
                          const SizedBox(height: 6),
                          _buildCheckoutCta(
                            context,
                            selectedPlan,
                            userPlanCode,
                            isPro,
                          ),
                          const SizedBox(height: 72),
                          const PaywallFooterSkyline(),
                        ],
                      ),
                    ),
                    if (isCheckoutLoading || isVerifying)
                      _buildVerifyingOverlay(
                        context,
                        isCheckoutLoading: isCheckoutLoading,
                        isDark: isDark,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerifyingOverlay(
    BuildContext context, {
    required bool isCheckoutLoading,
    required bool isDark,
  }) {
    return Container(
      color: Colors.black.withValues(alpha: 0.55),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 340),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.8,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isCheckoutLoading
                    ? 'Opening Checkout...'
                    : 'Verifying Payment...',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: isDark
                      ? AppColor.darkTextPrimary
                      : AppColor.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isCheckoutLoading
                    ? 'Securely connecting to Zoho Billing...'
                    : 'Confirming your transaction in real-time. Please wait...',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12,
                  color: isDark
                      ? AppColor.darkTextSecondary
                      : AppColor.lightTextSecondary,
                ),
              ),
              if (!isCheckoutLoading) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    _isWaitingForPayment = false;
                    context.read<MembershipBloc>().add(
                      const MembershipPlansFetchRequested(),
                    );
                  },
                  child: Text(
                    'Cancel / Check Later',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlansHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Select Pro Membership',
        style: AppTypography.titleSmall.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 15.5,
          color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
        ),
      ),
    );
  }

  Widget _buildPlansRow(
    BuildContext context,
    List<MembershipPlanEntity> plans,
    MembershipPlanEntity? selectedPlan,
    String? userPlanCode,
    bool isPro,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: plans.map((plan) {
          final isSelected = selectedPlan?.planCode == plan.planCode;
          final isCurrentPlan =
              isPro &&
              (userPlanCode == plan.planCode ||
                  (userPlanCode == null && plan.planCode == '012'));
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: PaywallPlanCard(
                plan: plan,
                isSelected: isSelected,
                isCurrentPlan: isCurrentPlan,
                onTap: () {
                  context.read<MembershipBloc>().add(
                    MembershipPlanSelected(plan),
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCheckoutCta(
    BuildContext context,
    MembershipPlanEntity? selectedPlan,
    String? userPlanCode,
    bool isPro,
  ) {
    if (selectedPlan == null) return const SizedBox.shrink();
    final isCurrent =
        isPro &&
        (userPlanCode == selectedPlan.planCode ||
            (userPlanCode == null && selectedPlan.planCode == '012'));

    final buttonText = isCurrent
        ? 'Renew ${selectedPlan.displayTitle}'
        : (isPro
              ? 'Switch to ${selectedPlan.displayTitle}'
              : 'Upgrade to ${selectedPlan.displayTitle}');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton(
          onPressed: () {
            if (!OfflineGuard.check(context, actionName: 'upgrade or renew membership')) {
              return;
            }
            context.read<MembershipBloc>().add(
              MembershipCheckoutInitiated(selectedPlan.planCode),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCurrent) ...[
                const Icon(
                  Icons.autorenew_rounded,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                buttonText,
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
