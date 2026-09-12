import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class TimelineInteractionBar extends StatelessWidget {
  final int likesCount;
  final int commentsCount;
  final int savesCount;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback? onLikeTap;
  final VoidCallback? onCommentTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onShareTap;

  const TimelineInteractionBar({
    super.key,
    required this.likesCount,
    required this.commentsCount,
    required this.savesCount,
    required this.isLiked,
    required this.isSaved,
    this.onLikeTap,
    this.onCommentTap,
    this.onSaveTap,
    this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Row(
      children: [
        _InteractionButton(
          icon: isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          count: likesCount,
          activeColor: AppColor.primaryPink,
          defaultColor: defaultColor,
          isActive: isLiked,
          onTap: onLikeTap,
        ),
        const SizedBox(width: 16),
        _InteractionButton(
          icon: Icons.chat_bubble_outline_rounded,
          count: commentsCount,
          activeColor: AppColor.primaryBlue,
          defaultColor: defaultColor,
          isActive: false,
          onTap: onCommentTap,
        ),
        const Spacer(),
        _InteractionButton(
          icon: isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          count: savesCount > 0 ? savesCount : null,
          activeColor: AppColor.primaryBlue,
          defaultColor: defaultColor,
          isActive: isSaved,
          onTap: onSaveTap,
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onShareTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.share_outlined, size: 20, color: defaultColor),
          ),
        ),
      ],
    );
  }
}

class _InteractionButton extends StatelessWidget {
  final IconData icon;
  final int? count;
  final Color activeColor;
  final Color defaultColor;
  final bool isActive;
  final VoidCallback? onTap;

  const _InteractionButton({
    required this.icon,
    this.count,
    required this.activeColor,
    required this.defaultColor,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : defaultColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            if (count != null) ...[
              const SizedBox(width: 6),
              Text(
                count.toString(),
                style: AppTypography.bodySmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
