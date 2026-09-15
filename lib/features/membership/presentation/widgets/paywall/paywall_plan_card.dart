import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/membership_plan_entity.dart';

class PaywallPlanCard extends StatelessWidget {
  final MembershipPlanEntity plan;
  final bool isSelected;
  final VoidCallback onChooseTap;

  const PaywallPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onChooseTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.white;
    final isPopular = plan.isPopular;
    final hasBadge = plan.badgeLabel != null;
    final badgeText = plan.badgeLabel ?? '';

    final themeColor = plan.planCode == '012'
        ? const Color(0xFF3B82F6)
        : plan.planCode == '014'
            ? const Color(0xFFEC4899)
            : const Color(0xFF8B5CF6);

    final borderColor = hasBadge
        ? themeColor
        : isDark
            ? AppColor.darkBorder
            : const Color(0xFFE2E8F0);

    final priceFormatted = plan.price.toInt() == plan.price
        ? '₹ ${plan.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
        : '₹ ${plan.price.toStringAsFixed(2)}';

    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
          width: hasBadge ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: hasBadge
                ? themeColor.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: hasBadge ? 12 : 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasBadge)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Text(
                badgeText,
                textAlign: TextAlign.center,
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.5,
                ),
              ),
            )
          else
            const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Column(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeColor.withValues(alpha: 0.12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.diamond_outlined,
                      color: themeColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  plan.displayTitle,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  plan.displayTier,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  priceFormatted,
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                ),
                Text(
                  plan.durationLabel,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10.5,
                    color: isDark ? AppColor.darkTextTertiary : AppColor.lightTextTertiary,
                  ),
                ),
                const SizedBox(height: 12),
                ...plan.resolvedFeatures.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 14,
                          color: themeColor,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            feature,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 10.5,
                              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                              height: 1.15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: isPopular
                      ? ElevatedButton(
                          onPressed: onChooseTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Choose Plan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        )
                      : OutlinedButton(
                          onPressed: onChooseTap,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: themeColor,
                            side: BorderSide(color: themeColor.withValues(alpha: 0.5), width: 1),
                            backgroundColor: themeColor.withValues(alpha: 0.04),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Choose Plan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
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
