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
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconBadge(),
              const SizedBox(height: 6),
              Text(
                item.title,
                style: AppTypography.labelSmall.copyWith(
                  color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  height: 1.15,
                  fontSize: 11.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBadge() {
    final accent = item.accentColor;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent, accent.withValues(alpha: 0.85)],
        ),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.32),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Icon(item.icon, size: 20, color: Colors.white),
      ),
    );
  }
}
