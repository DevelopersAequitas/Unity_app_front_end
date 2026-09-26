import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../asks/presentation/widgets/ask_flow_selection_overlay.dart';

class HomeAskBanner extends StatelessWidget {
  const HomeAskBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final titleColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final subtitleColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.openAsks),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'What do you need right now?',
                                style: AppTypography.titleMedium.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: titleColor,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 10.5,
                                color: AppColor.primaryBlue,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Collaborations · Referrals · Help',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11.5,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => AskFlowSelectionOverlay.show(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 5.5,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColor.brandGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_rounded, size: 14, color: Colors.white),
                        SizedBox(width: 2),
                        Text(
                          'Post Ask',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
