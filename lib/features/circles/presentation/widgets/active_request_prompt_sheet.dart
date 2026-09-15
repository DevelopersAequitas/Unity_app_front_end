import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/circle_join_request_entity.dart';

class ActiveRequestPromptSheet extends StatelessWidget {
  final String categoryName;
  final CircleJoinRequestEntity request;
  final VoidCallback onSeeRequest;
  final VoidCallback onSubmitAgain;

  const ActiveRequestPromptSheet({
    super.key,
    required this.categoryName,
    required this.request,
    required this.onSeeRequest,
    required this.onSubmitAgain,
  });

  static Future<void> show({
    required BuildContext context,
    required String categoryName,
    required CircleJoinRequestEntity request,
    required VoidCallback onSeeRequest,
    required VoidCallback onSubmitAgain,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.transparent,
      isScrollControlled: true,
      builder: (context) => ActiveRequestPromptSheet(
        categoryName: categoryName,
        request: request,
        onSeeRequest: onSeeRequest,
        onSubmitAgain: onSubmitAgain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryText = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final status = request.statusLabel.isNotEmpty ? request.statusLabel : request.displayStatus;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + MediaQuery.of(context).padding.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.info_outline_rounded, color: AppColor.primaryBlue, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Request Exists',
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'You have already submitted a join request',
                      style: AppTypography.bodySmall.copyWith(color: secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        categoryName,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: primaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColor.primaryBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColor.primaryBlue,
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                if (request.level4CategoryName != null && request.level4CategoryName!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    request.level4CategoryName!,
                    style: AppTypography.bodySmall.copyWith(color: secondaryText),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: onSeeRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryBlue,
                foregroundColor: AppColor.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              child: const Text('See Request', style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 44,
            child: OutlinedButton(
              onPressed: onSubmitAgain,
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                side: BorderSide(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Submit Again', style: TextStyle(fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}
