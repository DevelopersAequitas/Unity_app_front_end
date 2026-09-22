import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../models/home_quick_tab_config.dart';

class HomeDomeSubPillsBar extends StatelessWidget {
  final HomeQuickMainTab activeTab;
  final ValueChanged<HomeQuickTabItem> onItemTap;

  const HomeDomeSubPillsBar({
    super.key,
    required this.activeTab,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = activeTab.items;

    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 12, 6, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: First 4 items
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(4, (i) {
              if (i < items.length) {
                return Expanded(
                  child: _buildSquareSectionItem(context, items[i], isDark),
                );
              }
              return const Expanded(child: SizedBox.shrink());
            }),
          ),
          const SizedBox(height: 10),
          // Row 2: Next 4 items (items 4 to 7)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(4, (i) {
              final index = i + 4;
              if (index < items.length) {
                return Expanded(
                  child: _buildSquareSectionItem(context, items[index], isDark),
                );
              }
              return const Expanded(child: SizedBox.shrink());
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareSectionItem(
    BuildContext context,
    HomeQuickTabItem item,
    bool isDark,
  ) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => onItemTap(item),
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColor.primaryBlue.withValues(alpha: 0.12),
        highlightColor: AppColor.primaryBlue.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSquareBadge(item, isDark),
              const SizedBox(height: 5),
              SizedBox(
                height: 28,
                child: Center(
                  child: Text(
                    item.title,
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark
                          ? AppColor.darkTextPrimary
                          : const Color(0xFF1E293B),
                      height: 1.15,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.15,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSquareBadge(HomeQuickTabItem item, bool isDark) {
    final isCoin =
        item.id.contains('coin') ||
        item.title.toLowerCase().contains('coin') ||
        item.imageAsset != null;

    Widget iconContent;
    if (isCoin) {
      iconContent = Image.asset(
        item.imageAsset ?? 'assets/images/coin.png',
        width: 22,
        height: 22,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => ShaderMask(
          shaderCallback: (bounds) => AppColor.brandGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: const Icon(
            Icons.monetization_on_rounded,
            size: 20,
            color: Colors.white,
          ),
        ),
      );
    } else {
      iconContent = ShaderMask(
        shaderCallback: (bounds) => AppColor.brandGradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: Icon(item.icon, size: 20, color: Colors.white),
      );
    }

    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(1.4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        gradient: AppColor.brandGradient,
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryBlue.withValues(alpha: 0.10),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(11.6),
        ),
        child: Center(child: iconContent),
      ),
    );
  }
}
