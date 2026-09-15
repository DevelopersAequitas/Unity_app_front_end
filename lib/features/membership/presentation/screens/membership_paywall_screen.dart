import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
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
import '../widgets/paywall/paywall_compare_sheet.dart';
import '../widgets/paywall/paywall_features_grid.dart';
import '../widgets/paywall/paywall_footer_skyline.dart';
import '../widgets/paywall/paywall_hero_section.dart';
import '../widgets/paywall/paywall_plan_card.dart';
import '../widgets/paywall/paywall_secure_badge.dart';
import '../widgets/paywall/paywall_top_bar.dart';

class MembershipPaywallScreen extends StatelessWidget {
  const MembershipPaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => MembershipBloc(
        getMembershipPlansUseCase: ctx.read<GetMembershipPlansUseCase>(),
        initiatePlanCheckoutUseCase: ctx.read<InitiatePlanCheckoutUseCase>(),
        verifyCheckoutStatusUseCase: ctx.read<VerifyCheckoutStatusUseCase>(),
        getSubscriptionHistoryUseCase: ctx.read<GetSubscriptionHistoryUseCase>(),
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

class _PaywallViewState extends State<_PaywallView> with WidgetsBindingObserver {
  String? _activeHostedPageId;

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
    if (state == AppLifecycleState.resumed && _activeHostedPageId != null) {
      context
          .read<MembershipBloc>()
          .add(MembershipCheckoutStatusVerified(_activeHostedPageId!));
    }
  }

  Future<void> _handleCheckout(String checkoutUrl, String hostedPageId) async {
    _activeHostedPageId = hostedPageId;
    final uri = Uri.parse(checkoutUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColor.darkBackground : AppColor.white,
      body: BlocConsumer<MembershipBloc, MembershipState>(
        listener: (context, state) {
          if (state.status == MembershipStatus.checkoutReady &&
              state.checkoutSession != null) {
            _handleCheckout(
              state.checkoutSession!.checkoutUrl,
              state.checkoutSession!.hostedPageId,
            );
          } else if (state.status == MembershipStatus.verificationSuccess) {
            AppSnackBar.showSuccess(context, '🎉 Welcome to Pro Membership!');
            context.read<ProfileBloc>().add(const ProfileFetchRequested());
            Navigator.of(context).pop(true);
          } else if (state.status == MembershipStatus.error &&
              state.errorMessage != null) {
            AppSnackBar.showError(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          final plans = state.plans;
          final isLoading = state.status == MembershipStatus.loading && plans.isEmpty;
          final isCheckoutLoading = state.status == MembershipStatus.checkoutLoading;

          return Container(
            color: isDark ? AppColor.darkBackground : AppColor.white,
            child: SafeArea(
              child: ResponsiveContainer(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.primaryBlue,
                        ),
                      )
                    : Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PaywallTopBar(onBackTap: () => Navigator.of(context).pop()),
                                const PaywallHeroSection(),
                                const PaywallFeaturesGrid(),
                                const SizedBox(height: 8),
                                _buildPlansHeader(context, plans),
                                const SizedBox(height: 8),
                                _buildPlansCarousel(plans),
                                const SizedBox(height: 4),
                                const PaywallSecureBadge(),
                                const PaywallFooterSkyline(),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                          if (isCheckoutLoading)
                            Container(
                              color: Colors.black.withValues(alpha: 0.35),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
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

  Widget _buildPlansHeader(BuildContext context, List<MembershipPlanEntity> plans) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Choose Your Plan',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurface : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Plans',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => PaywallCompareSheet.show(
                    context,
                    plans: plans,
                    onSelectPlan: (code) =>
                        context.read<MembershipBloc>().add(MembershipCheckoutInitiated(code)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      'Compare',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansCarousel(List<MembershipPlanEntity> plans) {
    return SizedBox(
      height: 360,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return PaywallPlanCard(
            plan: plan,
            isSelected: plan.isPopular,
            onChooseTap: () => context
                .read<MembershipBloc>()
                .add(MembershipCheckoutInitiated(plan.planCode)),
          );
        },
      ),
    );
  }
}
