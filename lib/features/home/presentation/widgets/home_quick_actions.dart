import 'package:flutter/material.dart';
import '../../../highlights/domain/entities/highlight_section.dart';
import '../../../highlights/presentation/widgets/highlights_navigation_handler.dart';
import '../models/home_quick_tab_config.dart';
import 'home_dome_sub_pills_bar.dart';
import 'home_dome_tab_header.dart';
import 'swiggy_dome_painter.dart';

class HomeQuickActions extends StatefulWidget {
  final void Function(String route)? onActionSelected;

  const HomeQuickActions({super.key, this.onActionSelected});

  @override
  State<HomeQuickActions> createState() => _HomeQuickActionsState();
}

class _HomeQuickActionsState extends State<HomeQuickActions> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tabs = HomeQuickTabConfig.tabs;
    final activeTab = tabs[_selectedTabIndex.clamp(0, tabs.length - 1)];

    final bgFill = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark
        ? activeTab.accentColor.withValues(alpha: 0.5)
        : const Color(0xFF334155).withValues(alpha: 0.25);
    final baselineColor = isDark
        ? Colors.white12
        : const Color(0xFF334155).withValues(alpha: 0.18);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: _selectedTabIndex.toDouble(),
        end: _selectedTabIndex.toDouble(),
      ),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
      builder: (context, animatedIndex, child) {
        return CustomPaint(
          painter: SwiggyDomePainter(
            selectedIndex: animatedIndex,
            tabCount: tabs.length,
            backgroundColor: bgFill,
            borderColor: borderColor,
            baselineColor: baselineColor,
            tabHeaderHeight: 74.0,
            borderWidth: 1.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HomeDomeTabHeader(
                selectedIndex: _selectedTabIndex,
                onTabSelected: (index) {
                  setState(() => _selectedTabIndex = index);
                },
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.03),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<String>(activeTab.id),
                  child: HomeDomeSubPillsBar(
                    activeTab: activeTab,
                    onItemTap: (item) => _handleItemTap(context, item),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleItemTap(BuildContext context, HomeQuickTabItem item) {
    if (item.route != null) {
      if (widget.onActionSelected != null) {
        widget.onActionSelected!(item.route!);
      } else {
        Navigator.of(context).pushNamed(item.route!);
      }
      return;
    }
    HighlightsNavigationHandler.handleTap(
      context,
      HighlightSection(
        id: item.id,
        title: item.title,
        icon: item.icon,
        accentColor: item.color,
      ),
    );
  }
}
