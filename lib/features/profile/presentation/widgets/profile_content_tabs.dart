import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

enum ProfileTab { posts, media, about }

class ProfileContentTabs extends StatelessWidget {
  final ProfileTab selectedTab;
  final ValueChanged<ProfileTab> onTabSelected;
  final int postCount;
  final int mediaCount;

  const ProfileContentTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    this.postCount = 0,
    this.mediaCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColor.backgroundSubtle,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Row(
        children: [
          _buildTab(
            tab: ProfileTab.posts,
            label: 'Posts',
            icon: Icons.grid_on_rounded,
            count: postCount > 0 ? '$postCount' : null,
          ),
          _buildTab(
            tab: ProfileTab.media,
            label: 'Media',
            icon: Icons.video_library_outlined,
            count: mediaCount > 0 ? '$mediaCount' : null,
          ),
          _buildTab(
            tab: ProfileTab.about,
            label: 'About',
            icon: Icons.person_outline_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required ProfileTab tab,
    required String label,
    required IconData icon,
    String? count,
  }) {
    final isSelected = selectedTab == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(tab),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColor.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? AppColor.primary : AppColor.textTertiary,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColor.primary : AppColor.textTertiary,
                  fontSize: 12,
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.primary.withValues(alpha: 0.1)
                        : AppColor.borderSubtle.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColor.primary : AppColor.textTertiary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
