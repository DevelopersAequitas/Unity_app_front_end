import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

/// A compressed header row for the Notifications screen showing:
/// - Quick filter pills (All / Unread with badge count)
/// - Compact "Mark all read" action button
class NotificationsHeaderBar extends StatelessWidget {
  final int unreadCount;
  final String activeFilter;
  final ValueChanged<String> onFilterChanged;
  final VoidCallback onMarkAllRead;

  const NotificationsHeaderBar({
    super.key,
    required this.unreadCount,
    required this.activeFilter,
    required this.onFilterChanged,
    required this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Filter pills (All / Unread)
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColor.darkSurfaceSubtle
                  : AppColor.lightSurfaceMuted,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _FilterPill(
                  label: 'All',
                  isActive: activeFilter == 'all',
                  onTap: () => onFilterChanged('all'),
                ),
                const SizedBox(width: 2),
                _FilterPill(
                  label: 'Unread',
                  count: unreadCount,
                  isActive: activeFilter == 'unread',
                  onTap: () => onFilterChanged('unread'),
                ),
              ],
            ),
          ),

          // Mark all read button
          _CompactMarkAllReadButton(
            isEnabled: unreadCount > 0,
            onTap: onMarkAllRead,
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final int? count;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeBg = isDark ? AppColor.darkSurface : AppColor.white;
    final textColor = isActive
        ? (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary)
        : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: textColor,
              ),
            ),
            if (count != null && count! > 0) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColor.primaryPink
                      : (isDark ? AppColor.darkBorder : AppColor.badgePinkBg),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColor.primaryPink,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompactMarkAllReadButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onTap;

  const _CompactMarkAllReadButton({
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isEnabled
        ? AppColor.primaryBlue
        : (isDark ? AppColor.darkTextDisabled : AppColor.lightTextDisabled);

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.done_all_rounded, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              'Mark all read',
              style: AppTypography.labelSmall.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
