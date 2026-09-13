import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class CreatePostBottomBar extends StatelessWidget {
  final bool isSubmitting;
  final bool isDark;
  final VoidCallback onPickCameraPhoto;
  final VoidCallback onPickGalleryPhoto;
  final VoidCallback onRecordVideo;
  final VoidCallback onPickGalleryVideo;
  final VoidCallback onShowAllOptions;

  const CreatePostBottomBar({
    super.key,
    required this.isSubmitting,
    required this.isDark,
    required this.onPickCameraPhoto,
    required this.onPickGalleryPhoto,
    required this.onRecordVideo,
    required this.onPickGalleryVideo,
    required this.onShowAllOptions,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Text(
              'Attach:',
              style: AppTypography.labelSmall.copyWith(
                color: secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),

            // 1. Camera Photo
            _buildButton(
              icon: Icons.camera_alt_outlined,
              tooltip: 'Camera Photo',
              color: AppColor.primaryBlue,
              onTap: onPickCameraPhoto,
            ),
            const SizedBox(width: 6),

            // 2. Gallery Photo
            _buildButton(
              icon: Icons.photo_outlined,
              tooltip: 'Gallery Photo',
              color: AppColor.primaryPink,
              onTap: onPickGalleryPhoto,
            ),
            const SizedBox(width: 6),

            // 3. Record Video (1 min)
            _buildButton(
              icon: Icons.videocam_outlined,
              tooltip: 'Record Video (1 min)',
              color: AppColor.warning,
              onTap: onRecordVideo,
            ),
            const SizedBox(width: 6),

            // 4. Gallery Video (2 min)
            _buildButton(
              icon: Icons.video_library_outlined,
              tooltip: 'Gallery Video (2 min)',
              color: AppColor.success,
              onTap: onPickGalleryVideo,
            ),

            const Spacer(),

            // More Options Icon
            IconButton(
              icon: Icon(
                Icons.add_photo_alternate_outlined,
                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                size: 22,
              ),
              onPressed: isSubmitting ? null : onShowAllOptions,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: isSubmitting ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
