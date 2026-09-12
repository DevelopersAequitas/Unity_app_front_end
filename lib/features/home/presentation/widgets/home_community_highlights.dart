import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class HomeCommunityHighlights extends StatelessWidget {
  final VoidCallback? onSeeAllTap;
  final void Function(int index)? onCardTap;

  const HomeCommunityHighlights({
    super.key,
    this.onSeeAllTap,
    this.onCardTap,
  });

  static const _items = [
    _HighlightDef('Invite\nPeers', Icons.person_add_outlined, AppColor.primaryBlue),
    _HighlightDef('Join a\nCircle', Icons.bubble_chart_outlined, AppColor.success),
    _HighlightDef('Create\nImpact', Icons.volunteer_activism_outlined, AppColor.primaryPink),
    _HighlightDef('Explore\nEvents', Icons.event_available_outlined, AppColor.warning),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Community Highlights',
                style: AppTypography.titleMedium.copyWith(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: onSeeAllTap,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text(
                    'See all',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColor.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index < _items.length - 1 ? 8 : 0),
                  child: _HighlightCard(
                    def: item,
                    isDark: isDark,
                    onTap: () => onCardTap?.call(index),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final _HighlightDef def;
  final bool isDark;
  final VoidCallback? onTap;

  const _HighlightCard({required this.def, required this.isDark, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final border = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: def.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(def.icon, size: 20, color: def.color),
            ),
            const SizedBox(height: 8),
            Text(
              def.label,
              style: AppTypography.labelSmall.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
                height: 1.3,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightDef {
  final String label;
  final IconData icon;
  final Color color;
  const _HighlightDef(this.label, this.icon, this.color);
}
