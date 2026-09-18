import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/gratitude_script_entity.dart';

class ScriptStatsBanner extends StatelessWidget {
  final GratitudeScriptEntity script;

  const ScriptStatsBanner({super.key, required this.script});

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)} k';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                imageUrl: script.profilePhotoUrl,
                name: script.authorName,
                size: 40,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      script.authorName,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (script.businessName.isNotEmpty) script.businessName,
                        if (script.category.isNotEmpty) script.category,
                      ].join(' · '),
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (script.startDate.isNotEmpty && script.endDate.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${script.totalDays} Days',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.primaryBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MetricItem(
                    label: '30d Lives Impacted',
                    value: '${script.livesImpacted}',
                    isDark: isDark,
                  ),
                ),
                Container(height: 22, width: 0.8, color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
                Expanded(
                  child: _MetricItem(
                    label: '30d Business Done',
                    value: _formatAmount(script.businessDone),
                    isDark: isDark,
                  ),
                ),
                Container(height: 22, width: 0.8, color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
                Expanded(
                  child: _MetricItem(
                    label: 'Lifetime Impact',
                    value: '${script.lifetimeLivesImpacted}',
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _MetricItem({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
            fontSize: 12.5,
          ),
          maxLines: 1,
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
