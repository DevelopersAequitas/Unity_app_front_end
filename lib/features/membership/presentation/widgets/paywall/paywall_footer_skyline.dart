import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';

class PaywallFooterSkyline extends StatelessWidget {
  const PaywallFooterSkyline({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      color: isDark ? AppColor.darkBackground : AppColor.white,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Image.asset(
        'assets/images/skyline_banner.png',
        width: double.infinity,
        height: 140,
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
        errorBuilder: (_, _, _) => Image.asset(
          'assets/images/end_screen_image.png',
          width: double.infinity,
          height: 160,
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
