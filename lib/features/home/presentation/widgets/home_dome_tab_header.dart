import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../models/home_quick_tab_config.dart';

class HomeDomeTabHeader extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const HomeDomeTabHeader({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = HomeQuickTabConfig.tabs;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 74,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final isSelected = index == selectedIndex;
          return Expanded(
            child: _buildTabItem(
              context,
              tab,
              index,
              isSelected,
              isDark,
              tabs.length,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context,
    HomeQuickMainTab tab,
    int index,
    bool isSelected,
    bool isDark,
    int totalTabs,
  ) {
    final textColor = isSelected
        ? (isDark ? Colors.white : const Color(0xFF0F172A))
        : (isDark ? Colors.white54 : const Color(0xFF64748B));

    final isFirst = index == 0;
    final isLast = index == totalTabs - 1;

    return Padding(
      padding: EdgeInsets.only(
        left: isFirst ? 0 : 1.5,
        right: isLast ? 0 : 1.5,
      ),
      child: InkWell(
        onTap: () => onTabSelected(index),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(isSelected ? 16 : 14),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOutCubic,
          padding: EdgeInsets.only(
            top: isSelected ? 4 : 8,
            bottom: 4,
            left: 2,
            right: 2,
          ),
          decoration: isSelected
              ? null
              : BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : const Color(0xFFF8FAFC).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isFirst || isLast ? 16 : 14),
                  ),
                ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTabIcon(tab, isSelected),
              const SizedBox(height: 3),
              Text(
                tab.title,
                style: AppTypography.labelSmall.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  fontSize: 10.5,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabIcon(HomeQuickMainTab tab, bool isSelected) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: isSelected
            ? tab.accentColor
            : tab.accentColor.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: tab.accentColor.withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          tab.icon,
          size: 18,
          color: isSelected ? Colors.white : tab.accentColor,
        ),
      ),
    );
  }
}
