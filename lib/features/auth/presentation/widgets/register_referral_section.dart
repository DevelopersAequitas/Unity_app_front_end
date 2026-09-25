import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/referral_validation_entity.dart';

class RegisterReferralSection extends StatelessWidget {
  final TextEditingController controller;
  final bool isValidating;
  final ReferralValidationEntity? validation;
  final VoidCallback onValidate;
  final VoidCallback onClear;

  const RegisterReferralSection({
    super.key,
    required this.controller,
    required this.isValidating,
    this.validation,
    required this.onValidate,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isValid = validation?.valid == true;
    final isInvalid = validation != null && !validation!.valid;
    final referrer = validation?.referrer;
    final referrerName = validation?.displayName ?? '';
    final company = referrer?.companyName ?? '';
    final city = referrer?.city ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: controller,
          hintText: 'Referral / Invite Code (optional)',
          prefixIcon: const Icon(
            Icons.card_giftcard_outlined,
            size: 20,
          ),
          suffixIcon: _buildSuffix(context, isValid),
          onSubmitted: (_) => onValidate(),
        ),
        if (isValid && referrerName.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: Color(0xFF10B981),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Referred by: $referrerName',
                        style: AppTypography.labelSmall.copyWith(
                          color: const Color(0xFF047857),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (company.isNotEmpty || city.isNotEmpty) ...[
                        const SizedBox(height: 1),
                        Text(
                          [
                            if (company.isNotEmpty) company,
                            if (city.isNotEmpty) city,
                          ].join(' • '),
                          style: AppTypography.labelSmall.copyWith(
                            color: const Color(0xFF047857).withValues(alpha: 0.8),
                            fontSize: 10.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: Color(0xFF047857),
                  ),
                  tooltip: 'Remove',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onClear,
                ),
              ],
            ),
          ),
        ] else if (isInvalid) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Invalid referral code. Please check and try again.',
              style: AppTypography.labelSmall.copyWith(
                color: AppColor.error,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSuffix(BuildContext context, bool isValid) {
    if (isValidating) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColor.primaryBlue,
          ),
        ),
      );
    }
    if (isValid) {
      return const Icon(
        Icons.verified_rounded,
        color: Color(0xFF10B981),
        size: 20,
      );
    }
    if (controller.text.trim().isNotEmpty) {
      return TextButton(
        onPressed: onValidate,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Verify',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryBlue,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
