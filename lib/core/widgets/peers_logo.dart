import 'package:flutter/material.dart';
import '../../app/app_config.dart';
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

    final logoPath = AppConfig.isInitialized
        ? AppConfig.current.logoPath
        : 'assets/logo/peers_global_logo.png';

    Widget iconWidget = Image.asset(
      logoPath,
      width: iconSize,
      height: iconSize,
      fit: BoxFit.contain,
    );

    final String firstWord;
    final String secondWord;
    final Color firstColor;
    final Color secondColor;

    if (AppConfig.isInitialized && AppConfig.current.flavor.isFempreneur) {
      firstWord = 'Fempreneur';
      secondWord = ' Unity';
      firstColor = AppColor.primaryPink;
      secondColor = isDark ? AppColor.white : const Color(0xFFC2185B);
    } else if (AppConfig.isInitialized && AppConfig.current.flavor.isGreenpreneur) {
      firstWord = 'Greenpreneur';
      secondWord = ' Unity';
      firstColor = const Color(0xFF2E7D32);
      secondColor = isDark ? AppColor.white : const Color(0xFF1B5E20);
    } else {
      firstWord = 'Peers';
      secondWord = 'Global';
      firstColor = AppColor.primaryPink;
      secondColor = isDark ? AppColor.white : const Color(0xFF1D4ED8);
    }

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
                        TextSpan(
                          text: firstWord,
                          style: TextStyle(color: firstColor),
                        ),
                        TextSpan(
                          text: secondWord,
                          style: TextStyle(
                            color: secondColor,
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
