import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/coin_wallet_entity.dart';

class MilestoneBadgesView extends StatelessWidget {
  final List<BadgeMilestoneEntity> badges;

  const MilestoneBadgesView({super.key, required this.badges});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (badges.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        alignment: Alignment.center,
        child: Text(
          'Keep collaborating to unlock milestone badges',
          style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
        ),
      );
    }

    return Column(
      children: badges.map((badge) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                badge.isUnlocked ? Icons.verified_rounded : Icons.lock_outline_rounded,
                color: badge.isUnlocked ? AppColor.primaryBlue : AppColor.lightTextSecondary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      badge.name,
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: badge.progress,
                      backgroundColor: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColor.primaryBlue),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${badge.currentLevel}/${badge.targetLevel}',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
