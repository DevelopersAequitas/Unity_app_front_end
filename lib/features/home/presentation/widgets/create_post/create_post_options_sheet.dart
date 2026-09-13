import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class CreatePostOptionsSheet extends StatelessWidget {
  final bool isDark;
  final VoidCallback onPickCameraPhoto;
  final VoidCallback onPickGalleryPhoto;
  final VoidCallback onRecordVideo;
  final VoidCallback onPickGalleryVideo;

  const CreatePostOptionsSheet({
    super.key,
    required this.isDark,
    required this.onPickCameraPhoto,
    required this.onPickGalleryPhoto,
    required this.onRecordVideo,
    required this.onPickGalleryVideo,
  });

  static Future<void> show(
    BuildContext context, {
    required bool isDark,
    required VoidCallback onPickCameraPhoto,
    required VoidCallback onPickGalleryPhoto,
    required VoidCallback onRecordVideo,
    required VoidCallback onPickGalleryVideo,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => CreatePostOptionsSheet(
        isDark: isDark,
        onPickCameraPhoto: onPickCameraPhoto,
        onPickGalleryPhoto: onPickGalleryPhoto,
        onRecordVideo: onRecordVideo,
        onPickGalleryVideo: onPickGalleryVideo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
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
            const SizedBox(height: 14),
            Text(
              'Add Media to Post',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 14),
            _buildTile(
              context,
              icon: Icons.camera_alt_outlined,
              title: 'Take Photo',
              subtitle: 'Capture with camera & crop',
              color: AppColor.primaryBlue,
              onTap: onPickCameraPhoto,
            ),
            const SizedBox(height: 8),
            _buildTile(
              context,
              icon: Icons.photo_library_outlined,
              title: 'Choose Photo',
              subtitle: 'Select from gallery & crop',
              color: AppColor.primaryPink,
              onTap: onPickGalleryPhoto,
            ),
            const SizedBox(height: 8),
            _buildTile(
              context,
              icon: Icons.videocam_outlined,
              title: 'Record Video (Max 1 min)',
              subtitle: 'Record up to 1 minute update',
              color: AppColor.warning,
              onTap: onRecordVideo,
            ),
            const SizedBox(height: 8),
            _buildTile(
              context,
              icon: Icons.video_library_outlined,
              title: 'Choose Video (Max 2 mins)',
              subtitle: 'Select a video up to 2 minutes',
              color: AppColor.success,
              onTap: onPickGalleryVideo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.labelSmall.copyWith(
                      color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextDisabled,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextDisabled,
            ),
          ],
        ),
      ),
    );
  }
}
