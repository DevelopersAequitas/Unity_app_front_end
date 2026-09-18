import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class ContactImportTile extends StatelessWidget {
  final VoidCallback onTap;

  const ContactImportTile({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.primaryBlue.withValues(alpha: 0.04),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColor.primaryBlue.withValues(alpha: 0.25),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.perm_contact_calendar_outlined,
                  size: 20,
                  color: AppColor.primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto-fill from Device Contacts',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tap to select prospect name, phone & details',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 11,
                        color: AppColor.lightTextTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColor.primaryBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
