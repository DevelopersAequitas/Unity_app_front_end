import 'package:flutter/material.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';

class PeersLogo extends StatelessWidget {
  final bool isCentered;
  final double iconSize;
  final bool showText;

  const PeersLogo({
    super.key,
    this.isCentered = false,
    this.iconSize = 44.0,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    Widget iconWidget = Image.asset(
      'assets/images/icon.png',
      width: iconSize,
      height: iconSize,
      fit: BoxFit.contain,
    );

    Widget logoContent = showText
        ? Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      style: AppTypography.titleLarge.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Peers',
                          style: TextStyle(color: AppColor.primaryPink),
                        ),
                        TextSpan(
                          text: 'Global',
                          style: TextStyle(
                            color: isDark
                                ? AppColor.white
                                : const Color(0xFF1D4ED8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Community of Collaboration',
                    style: AppTypography.labelSmall.copyWith(
                      color: secondaryTextColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ],
          )
        : iconWidget;

    if (isCentered) {
      return Center(child: logoContent);
    }
    return logoContent;
  }
}
