import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_state.dart';

class HomeMetricCards extends StatelessWidget {
  const HomeMetricCards({super.key});

  static String _formatNumber(int number) {
    if (number >= 1000000000000000) {
      final val = (number / 1000000000000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}Q';
    }
    if (number >= 1000000000000) {
      final val = (number / 1000000000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}T';
    }
    if (number >= 1000000000) {
      final val = (number / 1000000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}B';
    }
    if (number >= 1000000) {
      final val = (number / 1000000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}M';
    }
    if (number >= 1000) {
      final val = (number / 1000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}K';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final profile = profileState.profile;
            final user = authState.user;

            final lifeImpacted =
                profile?.lifeImpactedCount ?? user?.lifeImpactedCount ?? 0;
            final coins = (profile != null && profile.coinsBalance > 0)
                ? profile.coinsBalance
                : (user?.coinsBalance ?? profile?.coinsBalance ?? 0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      label: 'Lives Impacted',
                      value: _formatNumber(lifeImpacted),
                      gradient: AppColor.brandGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryBlue.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.impactLeaderboard,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      label: 'Coins',
                      value: _formatNumber(coins),
                      gradient: const LinearGradient(
                        colors: [AppColor.primaryPink, AppColor.primaryBlue],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryPink.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.leaderboard);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final LinearGradient gradient;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.gradient,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // ── Big Count Number ──
                Text(
                  value,
                  style: AppTypography.displayLarge.copyWith(
                    color: AppColor.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                    height: 1.0,
                  ),
                ),
                const SizedBox(width: 6),
                // ── Label bottom-aligned to number ──
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      label,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColor.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
