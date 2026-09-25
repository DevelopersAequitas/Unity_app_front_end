import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/post_share_helper.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_posts_bloc.dart';
import '../../../profile/presentation/bloc/profile_posts_event.dart';
import '../../domain/entities/timeline_item_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import 'report_post_bottom_sheet.dart';

class PostOptionsBottomSheet extends StatelessWidget {
  final TimelineItemEntity item;
  final bool isOwner;

  const PostOptionsBottomSheet({
    super.key,
    required this.item,
    required this.isOwner,
  });

  static Future<void> show(
    BuildContext context, {
    required TimelineItemEntity item,
  }) {
    final profile = context.read<ProfileBloc>().state.profile;
    final currentUserId = profile?.userId ?? profile?.id ?? '';
    final authorId = item.author?.id ?? '';
    final isOwner =
        (currentUserId.isNotEmpty &&
            authorId.isNotEmpty &&
            currentUserId == authorId) ||
        (profile != null && item.author?.displayName == profile.displayName);

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => PostOptionsBottomSheet(item: item, isOwner: isOwner),
    );
  }

  void _handleDelete(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    ProfilePostsBloc? profilePostsBloc;
    try {
      profilePostsBloc = context.read<ProfilePostsBloc>();
    } catch (_) {}
    final navigator = Navigator.of(context, rootNavigator: true);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Navigator.pop(context);

    showDialog(
      context: navigator.context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Post',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColor.darkTextPrimary
                : AppColor.lightTextPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this post? This action cannot be undone.',
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColor.darkTextSecondary
                : AppColor.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: AppTypography.labelMedium.copyWith(
                color: isDark
                    ? AppColor.darkTextSecondary
                    : AppColor.lightTextSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              homeBloc.add(HomePostDeleted(item.id));
              if (profilePostsBloc != null) {
                profilePostsBloc.add(ProfilePostDeleted(item.id));
              }
              if (navigator.context.mounted) {
                AppSnackBar.showSuccess(
                    navigator.context, 'Post deleted successfully');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleEdit(BuildContext context) {
    Navigator.pop(context); // close the options sheet
    // Navigate to CreatePostScreen in edit mode
    Navigator.pushNamed(context, AppRoutes.createPost, arguments: item);
  }

  void _handleReport(BuildContext context) {
    Navigator.pop(context);
    ReportPostBottomSheet.show(context, item: item);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            if (isOwner) ...[
              _buildTile(
                icon: Icons.edit_outlined,
                title: 'Edit Post',
                color: primaryTextColor,
                onTap: () => _handleEdit(context),
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _buildTile(
                icon: Icons.share_outlined,
                title: 'Share Post',
                color: primaryTextColor,
                onTap: () {
                  Navigator.pop(context);
                  PostShareHelper.sharePost(item);
                },
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _buildTile(
                icon: Icons.delete_outline_rounded,
                title: 'Delete Post',
                color: AppColor.error,
                onTap: () => _handleDelete(context),
                isDark: isDark,
              ),
            ] else ...[
              _buildTile(
                icon: Icons.share_outlined,
                title: 'Share Post',
                color: primaryTextColor,
                onTap: () {
                  Navigator.pop(context);
                  PostShareHelper.sharePost(item);
                },
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _buildTile(
                icon: item.isSaved
                    ? Icons.bookmark_remove_outlined
                    : Icons.bookmark_border_rounded,
                title: item.isSaved ? 'Unsave Post' : 'Save Post',
                color: primaryTextColor,
                onTap: () {
                  Navigator.pop(context);
                  try {
                    context.read<HomeBloc>().add(
                      HomePostSaveToggled(
                        postId: item.id,
                        isCurrentlySaved: item.isSaved,
                      ),
                    );
                  } catch (_) {}
                },
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _buildTile(
                icon: Icons.flag_outlined,
                title: 'Report Post',
                color: AppColor.warning,
                onTap: () => _handleReport(context),
                isDark: isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppTypography.bodySmall.copyWith(
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
