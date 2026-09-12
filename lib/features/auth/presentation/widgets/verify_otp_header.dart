import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
// import '../../../../core/widgets/peers_logo.dart';

class VerifyOtpHeader extends StatelessWidget {
  final VoidCallback onBack;

  const VerifyOtpHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        // const SizedBox(height: 12),
        // const PeersLogo(isCentered: true, showText: true, iconSize: 48),
      ],
    );
  }
}
