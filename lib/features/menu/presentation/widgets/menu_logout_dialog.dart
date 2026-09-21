import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class MenuLogoutBottomSheet extends StatelessWidget {
  const MenuLogoutBottomSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const MenuLogoutBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.lightSurface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),

            // Red logout icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColor.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 22,
                color: AppColor.error,
              ),
            ),
            const SizedBox(height: 14),

            // Title
            Text(
              'Log Out',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.lightTextPrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),

            // Subtitle
            Text(
              'Are you sure you want to log out of your Unity account?',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColor.lightTextSecondary,
                fontSize: 12.5,
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.lightTextPrimary,
                      side: const BorderSide(color: AppColor.lightBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColor.lightTextPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.error,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: Text(
                      'Log Out',
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

typedef MenuLogoutDialog = MenuLogoutBottomSheet;
