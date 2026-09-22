import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/highlight_section.dart';

class HighlightsGridCard extends StatelessWidget {
  final HighlightSection item;
  final int index;
  final VoidCallback onTap;

  const HighlightsGridCard({
    super.key,
    required this.item,
    this.index = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: AppColor.primaryBlue.withValues(alpha: 0.12),
        highlightColor: AppColor.primaryBlue.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildIconBadge(isDark),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  item.title,
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColor.darkTextPrimary : const Color(0xFF1E293B),
                    fontWeight: FontWeight.w400,
                    height: 1.15,
                    fontSize: 11.5,
                    letterSpacing: -0.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBadge(bool isDark) {
    final isCoin = item.id.contains('coin') || item.title.toLowerCase().contains('coin');

    Widget iconContent;
    if (isCoin) {
      iconContent = Image.asset(
        'assets/images/coin.png',
        width: 22,
        height: 22,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => ShaderMask(
          shaderCallback: (bounds) => AppColor.brandGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: const Icon(
            Icons.monetization_on_rounded,
            size: 22,
            color: Colors.white,
          ),
        ),
      );
    } else {
      iconContent = ShaderMask(
        shaderCallback: (bounds) => AppColor.brandGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: Icon(
          item.icon,
          size: 22,
          color: Colors.white,
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: AppColor.brandGradient,
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryBlue.withValues(alpha: 0.10),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(13.5),
            ),
            child: Center(child: iconContent),
          ),
        ),
        if (item.isLocked)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_rounded,
                size: 9,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
