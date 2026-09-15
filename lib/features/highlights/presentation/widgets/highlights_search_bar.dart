import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class HighlightsSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const HighlightsSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            width: 1,
          ),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTypography.bodyLarge.copyWith(
            color: isDark
                ? AppColor.darkTextPrimary
                : AppColor.lightTextPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Search highlights...',
            hintStyle: AppTypography.bodyLarge.copyWith(
              color: isDark
                  ? AppColor.darkTextDisabled
                  : AppColor.lightTextDisabled,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 20,
              color: isDark
                  ? AppColor.darkTextSecondary
                  : AppColor.lightTextSecondary,
            ),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    color: isDark
                        ? AppColor.darkTextSecondary
                        : AppColor.lightTextSecondary,
                    onPressed: onClear,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }
}
