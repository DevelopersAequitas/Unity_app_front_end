import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class LoginHeader extends StatelessWidget {
  final VoidCallback? onBack;

  const LoginHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;

    return SizedBox(
      height: 44,
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: iconColor,
              ),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
        ],
      ),
    );
  }
}
