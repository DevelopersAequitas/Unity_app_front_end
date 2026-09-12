import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class RegisterDropdownField extends StatelessWidget {
  final String hintText;
  final String? value;
  final Widget? prefixIcon;
  final VoidCallback onTap;

  const RegisterDropdownField({
    super.key,
    required this.hintText,
    this.value,
    this.prefixIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasValue = value != null && value!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            if (prefixIcon != null) ...[prefixIcon!, const SizedBox(width: 12)],
            Expanded(
              child: Text(
                hasValue ? value! : hintText,
                style: AppTypography.bodyLarge.copyWith(
                  color: hasValue
                      ? (isDark
                            ? AppColor.darkTextPrimary
                            : AppColor.lightTextPrimary)
                      : (isDark
                            ? AppColor.darkTextDisabled
                            : AppColor.lightTextDisabled),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }
}
