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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.people_outline_rounded,
              value: '${stats.totalInvited}',
              label: 'Total Referrals',
              isDark: isDark,
            ),
          ),
          _buildDivider(isDark),
          Expanded(
            child: _StatItem(
              icon: Icons.send_outlined,
              value: '${stats.referralsGiven}',
              label: 'Given',
              isDark: isDark,
            ),
          ),
          _buildDivider(isDark),
          Expanded(
            child: _StatItem(
              icon: Icons.call_received_rounded,
              value: '${stats.referralsReceived}',
              label: 'Received',
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 28,
      width: 0.8,
      color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool isDark;

  const _StatItem({
    required this.icon,
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
            Icon(icon, size: 14, color: AppColor.primaryBlue),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            fontSize: 10.5,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

