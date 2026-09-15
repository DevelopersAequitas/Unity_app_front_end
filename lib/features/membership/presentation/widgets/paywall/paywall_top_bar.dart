import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class PaywallTopBar extends StatelessWidget {
  final VoidCallback onBackTap;

  const PaywallTopBar({
    super.key,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconBg = isDark ? AppColor.darkSurface : AppColor.white;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Material(
            color: iconBg,
            shape: const CircleBorder(),
            elevation: 1,
            shadowColor: Colors.black.withValues(alpha: 0.08),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBackTap,
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 0.8),
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 20,
                  color: textColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.public_rounded,
                  size: 20,
                  color: AppColor.primaryBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  'PEERS GLOBAL',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2.0,
                    fontSize: 13,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 38),
        ],
      ),
    );
  }
}
