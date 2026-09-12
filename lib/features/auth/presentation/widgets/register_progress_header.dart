import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class RegisterProgressHeader extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBack;

  const RegisterProgressHeader({
    super.key,
    required this.currentStep,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        ),
        const Spacer(),
        SizedBox(
          width: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildStepDot(1), _buildConnector(1), _buildStepDot(2)],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 40,
          child: Text(
            '$currentStep/2',
            style: AppTypography.bodySmall.copyWith(
              color: secondaryColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDot(int step) {
    final isActive = step == currentStep;
    final isCompleted = step < currentStep;

    return Container(
      width: isActive ? 10 : 7,
      height: isActive ? 10 : 7,
      decoration: BoxDecoration(
        color: (isActive || isCompleted)
            ? AppColor.primaryBlue
            : const Color(0xFFCBD5E1),
        shape: BoxShape.circle,
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColor.primaryBlue.withValues(alpha: 0.35),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildConnector(int step) {
    final isPassed = step < currentStep;

    return Expanded(
      child: Container(
        height: 2,
        color: isPassed
            ? AppColor.primaryBlue.withValues(alpha: 0.6)
            : const Color(0xFFE2E8F0),
      ),
    );
  }
}
