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
    if (number >= 100000) {
      final val = (number / 1000).toStringAsFixed(1);
      return '${val.endsWith('.0') ? val.substring(0, val.length - 2) : val}K';
    }
    if (number >= 1000) {
      final str = number.toString();
      final chars = str.split('');
      final buffer = StringBuffer();
      for (int i = 0; i < chars.length; i++) {
        if (i > 0 && (chars.length - i) % 3 == 0) {
          buffer.write(',');
        }
        buffer.write(chars[i]);
      }
      return buffer.toString();
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

            final lifeImpacted = profile?.lifeImpactedCount ?? user?.lifeImpactedCount ?? 0;
            final coins = (profile != null && profile.coinsBalance > 0)
                ? profile.coinsBalance
                : (user?.coinsBalance ?? profile?.coinsBalance ?? 0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      label: 'Lives Impacted',
                      value: _formatNumber(lifeImpacted),
                      icon: Icons.bar_chart_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1D4ED8), Color(0xFF3B6FE8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.impactLeaderboard);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      label: 'Coins',
                      value: _formatNumber(coins),
                      icon: Icons.toll_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE11D48), Color(0xFFFF6584)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColor.white.withValues(alpha: 0.85),
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: AppTypography.displayLarge.copyWith(
                          color: AppColor.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AppColor.white.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
