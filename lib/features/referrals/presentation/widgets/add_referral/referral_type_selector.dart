import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class ReferralTypeOption {
  final String key;
  final String label;
  final IconData icon;

  const ReferralTypeOption({
    required this.key,
    required this.label,
    required this.icon,
  });
}

class ReferralTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const ReferralTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  static const List<ReferralTypeOption> options = [
    ReferralTypeOption(
      key: 'b2b_referral',
      label: 'B2B Referral',
      icon: Icons.business_center_outlined,
    ),
    ReferralTypeOption(
      key: 'customer_referral',
      label: 'Customer Referral',
      icon: Icons.person_add_alt_1_outlined,
    ),
    ReferralTypeOption(
      key: 'b2g_referral',
      label: 'B2G Referral',
      icon: Icons.account_balance_outlined,
    ),
    ReferralTypeOption(
      key: 'collaborative_projects',
      label: 'Collaborative Project',
      icon: Icons.handshake_outlined,
    ),
    ReferralTypeOption(
      key: 'referral_partnerships',
      label: 'Partnership',
      icon: Icons.groups_outlined,
    ),
    ReferralTypeOption(
      key: 'vendor_referrals',
      label: 'Vendor Referral',
      icon: Icons.storefront_outlined,
    ),
    ReferralTypeOption(
      key: 'others',
      label: 'Others',
      icon: Icons.category_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Referral Type *',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColor.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected =
                selectedType.toLowerCase() == opt.key.toLowerCase();
            return Material(
              color: isSelected
                  ? AppColor.primaryBlue.withValues(alpha: 0.08)
                  : AppColor.lightSurface,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () => onTypeChanged(opt.key),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColor.primaryBlue
                          : AppColor.lightBorder,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        opt.icon,
                        size: 16,
                        color: isSelected
                            ? AppColor.primaryBlue
                            : AppColor.lightTextSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        opt.label,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: isSelected
                              ? AppColor.primaryBlue
                              : AppColor.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
