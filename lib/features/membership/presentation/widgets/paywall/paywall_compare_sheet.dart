import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/membership_plan_entity.dart';

class PaywallCompareSheet extends StatelessWidget {
  final List<MembershipPlanEntity> plans;
  final ValueChanged<String> onSelectPlan;

  const PaywallCompareSheet({
    super.key,
    required this.plans,
    required this.onSelectPlan,
  });

  static void show(BuildContext context, {
    required List<MembershipPlanEntity> plans,
    required ValueChanged<String> onSelectPlan,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      builder: (_) => PaywallCompareSheet(
        plans: plans,
        onSelectPlan: onSelectPlan,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.white;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final comparisonItems = [
      {'feature': 'Peer Direct Messaging', '012': true, '013': true, '014': true},
      {'feature': 'Circle Seat Eligibility', '012': true, '013': true, '014': true},
      {'feature': 'Networking & Introductions', '012': true, '013': true, '014': true},
      {'feature': 'Online & Offline Events', '012': true, '013': true, '014': true},
      {'feature': 'Extended Multi-Year Savings', '012': false, '013': true, '014': true},
      {'feature': 'Priority Opportunity Matching', '012': false, '013': true, '014': true},
      {'feature': 'Featured Peer Profile Badge', '012': false, '013': false, '014': true},
      {'feature': 'VIP Community Access', '012': false, '013': false, '014': true},
    ];

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Plan Comparison',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: primaryText,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                Row(
                  children: [
                    Expanded(flex: 4, child: Text('Features', style: AppTypography.labelSmall.copyWith(color: secondaryText))),
                    Expanded(flex: 2, child: Center(child: Text('1 Month', style: AppTypography.labelSmall.copyWith(color: const Color(0xFF3B82F6), fontWeight: FontWeight.w600)))),
                    Expanded(flex: 2, child: Center(child: Text('1 Year', style: AppTypography.labelSmall.copyWith(color: const Color(0xFF8B5CF6), fontWeight: FontWeight.w600)))),
                    Expanded(flex: 2, child: Center(child: Text('2 Year', style: AppTypography.labelSmall.copyWith(color: const Color(0xFFEC4899), fontWeight: FontWeight.w600)))),
                  ],
                ),
                const SizedBox(height: 10),
                ...comparisonItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            item['feature'] as String,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11.5,
                              color: primaryText,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Icon(
                              item['012'] == true ? Icons.check_circle_rounded : Icons.remove_rounded,
                              size: 16,
                              color: item['012'] == true ? const Color(0xFF3B82F6) : Colors.grey.shade400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Icon(
                              item['013'] == true ? Icons.check_circle_rounded : Icons.remove_rounded,
                              size: 16,
                              color: item['013'] == true ? const Color(0xFF8B5CF6) : Colors.grey.shade400,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Icon(
                              item['014'] == true ? Icons.check_circle_rounded : Icons.remove_rounded,
                              size: 16,
                              color: item['014'] == true ? const Color(0xFFEC4899) : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
