import 'package:flutter/material.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';

class AppCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final bool showBack;

  const AppCustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBack,
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColor.darkBackground : AppColor.lightBackground;
    final textColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;

    return AppBar(
      title: Text(
        title,
        style: AppTypography.titleMedium.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      centerTitle: true,
      backgroundColor: bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: showBack
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: textColor,
              ),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      actions: actions,
    );
  }
}
