import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/theme/app_typography.dart';

class P2pSubTabChips extends StatelessWidget {
  final List<String> labels;
  final List<IconData>? icons;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Map<int, int>? badges;

  const P2pSubTabChips({
    super.key,
    required this.labels,
    this.icons,
    required this.selectedIndex,
    required this.onSelected,
    this.badges,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor.lightBorder,
          width: 0.8,
        ),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = selectedIndex == index;
          final count = badges?[index];
          final icon = icons != null && index < icons!.length ? icons![index] : null;

          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColor.brandGradient : null,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.primaryPink.withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 13,
                        color: isSelected
                            ? AppColor.white
                            : AppColor.lightTextSecondary,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Flexible(
                      child: Text(
                        labels[index],
                        style: AppTypography.labelMedium.copyWith(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColor.white
                              : AppColor.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (count != null && count > 0) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColor.white.withValues(alpha: 0.25)
                              : AppColor.primaryPink.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          count > 99 ? '99+' : count.toString(),
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColor.white
                                : AppColor.primaryPink,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
