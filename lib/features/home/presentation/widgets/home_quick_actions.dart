import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class HomeQuickActions extends StatelessWidget {
  final void Function(String action)? onActionSelected;

  const HomeQuickActions({super.key, this.onActionSelected});

  static const _actions = [
    _ActionDef('Impact', Icons.favorite_border_rounded, AppColor.primaryPink),
    _ActionDef('Peers', Icons.people_outline_rounded, AppColor.primaryBlue),
    _ActionDef('Circles', Icons.bubble_chart_outlined, Color(0xFF7C3AED)),
    _ActionDef('Events', Icons.calendar_month_outlined, Color(0xFF0891B2)),
    _ActionDef('Learning', Icons.auto_stories_outlined, Color(0xFF059669)),
    _ActionDef('Opportunities', Icons.work_outline_rounded, Color(0xFFD97706)),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _actions.map((item) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: _actions.last == item ? 0 : 6,
              ),
              child: InkWell(
                onTap: () => onActionSelected?.call(item.label),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item.icon, size: 22, color: item.color),
                      const SizedBox(height: 5),
                      Text(
                        _shortLabel(item.label),
                        style: AppTypography.labelSmall.copyWith(
                          color: textColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _shortLabel(String label) {
    // Truncate 'Opportunities' to fit in narrow card
    if (label == 'Opportunities') return 'Opport.';
    return label;
  }
}

class _ActionDef {
  final String label;
  final IconData icon;
  final Color color;
  const _ActionDef(this.label, this.icon, this.color);
}
