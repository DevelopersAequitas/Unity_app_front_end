import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/membership_plan_entity.dart';

class PaywallPlanCard extends StatelessWidget {
  final MembershipPlanEntity plan;
  final bool isSelected;
  final bool isCurrentPlan;
  final VoidCallback onTap;

  const PaywallPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    this.isCurrentPlan = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.white;
    final hasBadge = isCurrentPlan || plan.badgeLabel != null;
    final badgeText = isCurrentPlan ? 'CURRENT PLAN' : (plan.badgeLabel ?? '');
    final badgeColor = isCurrentPlan
        ? const Color(0xFF10B981)
        : (plan.planCode == '012'
            ? const Color(0xFF3B82F6)
            : plan.planCode == '014'
                ? const Color(0xFFEC4899)
                : const Color(0xFF8B5CF6));

    final themeColor = isCurrentPlan
        ? const Color(0xFF10B981)
        : (plan.planCode == '012'
            ? const Color(0xFF3B82F6)
            : plan.planCode == '014'
                ? const Color(0xFFEC4899)
                : const Color(0xFF8B5CF6));

    final borderColor = isSelected
        ? themeColor
        : isCurrentPlan
            ? const Color(0xFF10B981).withValues(alpha: 0.6)
            : isDark
                ? AppColor.darkBorder
                : const Color(0xFFE2E8F0);

    final priceFormatted = plan.price.toInt() == plan.price
        ? '₹${plan.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
        : '₹${plan.price.toStringAsFixed(2)}';

    // Short duration label for compact card
    String shortDuration;
    if (plan.planCode == '012') {
      shortDuration = '/ mo';
    } else if (plan.planCode == '014') {
      shortDuration = '/ 2 yrs';
    } else {
      shortDuration = '/ yr';
    }

    // Savings tag
    String? savingsTag;
    if (isCurrentPlan) {
      savingsTag = 'Active Plan';
    } else if (plan.planCode == '013') {
      savingsTag = 'Save 58%';
    } else if (plan.planCode == '014') {
      savingsTag = 'Save 71%';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? themeColor.withValues(alpha: isDark ? 0.12 : 0.04)
                : cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? themeColor.withValues(alpha: 0.18)
                    : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: isSelected ? 10 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Badge if available
                if (hasBadge)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(color: badgeColor),
                    child: Text(
                      badgeText,
                      textAlign: TextAlign.center,
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 9.5,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  const SizedBox(height: 18),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                  child: Column(
                    children: [
                      // Selection Indicator
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? themeColor : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? themeColor
                                : (isDark ? AppColor.darkBorder : const Color(0xFFCBD5E1)),
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                size: 13,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(height: 8),

                      // Plan Title (e.g. 1 Month, 1 Year, 2 Year)
                      Text(
                        plan.displayTitle.replaceAll(' Pro', ''),
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Tier (Starter, Builder, Leader)
                      Text(
                        plan.displayTier,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Price
                      Text(
                        priceFormatted,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                          color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Duration label
                      Text(
                        shortDuration,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 9.5,
                          color: isDark ? AppColor.darkTextTertiary : AppColor.lightTextTertiary,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Savings badge / spacer
                      if (savingsTag != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: themeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            savingsTag,
                            style: AppTypography.labelSmall.copyWith(
                              color: themeColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 9,
                            ),
                          ),
                        )
                      else
                        const SizedBox(height: 16),
                    ],
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
