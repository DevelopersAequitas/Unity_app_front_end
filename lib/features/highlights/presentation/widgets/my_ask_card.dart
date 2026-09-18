import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/post_ask_entity.dart';

class MyAskCard extends StatelessWidget {
  final PostAskEntity ask;
  final VoidCallback? onComplete;

  const MyAskCard({
    super.key,
    required this.ask,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOpen = ask.isOpen;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  ask.category,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColor.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (isOpen ? AppColor.warning : AppColor.success).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isOpen ? 'Open' : 'Completed',
                  style: AppTypography.labelSmall.copyWith(
                    color: isOpen ? AppColor.warning : AppColor.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ask.subject,
            style: AppTypography.titleMedium.copyWith(
              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ask.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (ask.cityName.isNotEmpty || ask.regionLabel.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  [ask.cityName, ask.regionLabel].where((s) => s.isNotEmpty).join(', '),
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
          if (isOpen && onComplete != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onComplete,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColor.success),
                label: Text(
                  'Mark Complete',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColor.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
