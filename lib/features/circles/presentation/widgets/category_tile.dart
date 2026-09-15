import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/entities/circle_join_request_entity.dart';
import 'circle_icon_helper.dart';

class CategoryTile extends StatefulWidget {
  final CircleCategoryEntity category;
  final CircleJoinRequestEntity? joinRequest;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.category,
    this.joinRequest,
    required this.onTap,
  });

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = CircleIconHelper.getCategoryConfig(
      widget.category.name,
      widget.category.circleKey,
    );
    final accent = config.tintColor;

    final cardBg = isDark
        ? AppColor.darkSurface
        : Color.lerp(AppColor.white, accent, 0.04)!;
    final borderColor = isDark
        ? AppColor.darkBorder
        : accent.withValues(alpha: 0.16);

    return AnimatedScale(
      scale: _isPressed ? 0.94 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 0.8),
        ),
        child: Material(
          color: AppColor.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent,
                    ),
                    child: Center(
                      child: Icon(config.icon, size: 20, color: AppColor.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.category.name,
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
