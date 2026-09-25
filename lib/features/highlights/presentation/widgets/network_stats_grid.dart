import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/network_stats_entity.dart';

class NetworkStatsGrid extends StatelessWidget {
  final NetworkStatsEntity stats;

  const NetworkStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.group_rounded,
              iconColor: AppColor.primaryBlue,
              value: '${stats.totalInvited}',
              label: 'Joined Peers',
              isDark: isDark,
            ),
          ),
          Container(
            height: 34,
            width: 0.8,
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
          Expanded(
            child: _StatItem(
              iconWidget: Image.asset(
                'assets/images/coin.png',
                width: 16,
                height: 16,
              ),
              iconColor: const Color(0xFFF59E0B),
              value: '${stats.rewardsEarned}',
              label: 'Earned Coins',
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final Color iconColor;
  final String value;
  final String label;
  final bool isDark;

  const _StatItem({
    this.icon,
    this.iconWidget,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: iconWidget ?? (icon != null ? Icon(icon, size: 15, color: iconColor) : const SizedBox.shrink()),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: isDark
                    ? AppColor.darkTextPrimary
                    : AppColor.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: isDark
                ? AppColor.darkTextSecondary
                : AppColor.lightTextSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
