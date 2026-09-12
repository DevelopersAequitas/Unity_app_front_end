import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';

class VideoSourcePickerSheet extends StatelessWidget {
  final int maxDurationSeconds;

  const VideoSourcePickerSheet({super.key, this.maxDurationSeconds = 30});

  static Future<XFile?> show(
    BuildContext context, {
    int maxDurationSeconds = 30,
  }) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => VideoSourcePickerSheet(maxDurationSeconds: maxDurationSeconds),
    );

    if (source != null) {
      try {
        final picker = ImagePicker();
        final picked = await picker.pickVideo(
          source: source,
          maxDuration: Duration(seconds: maxDurationSeconds),
        );

        if (picked == null) return null;

        Duration? duration;
        try {
          final videoFile = File(picked.path);
          final controller = VideoPlayerController.file(videoFile);
          await controller.initialize();
          duration = controller.value.duration;
          await controller.dispose();
        } catch (_) {
          // If decoder runs out of memory or fails on device, proceed with picked file
        }

        if (duration != null && duration.inSeconds > (maxDurationSeconds + 1)) {
          if (context.mounted) {
            _showDurationExceededDialog(
              context,
              durationSeconds: duration.inSeconds,
              maxSeconds: maxDurationSeconds,
            );
          }
          return null;
        }

        return picked;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to process video: $e'),
              backgroundColor: AppColor.error,
            ),
          );
        }
        return null;
      }
    }
    return null;
  }

  static void _showDurationExceededDialog(
    BuildContext context, {
    required int durationSeconds,
    required int maxSeconds,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Video Too Long',
          style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        content: Text(
          'Selected video is $durationSeconds seconds. Profile video must be $maxSeconds seconds or shorter.',
          style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK', style: AppTypography.labelLarge.copyWith(color: AppColor.primaryBlue, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(color: AppColor.lightBorder, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Text(
              'Profile Introduction Video',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500, color: AppColor.lightTextPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Maximum duration: $maxDurationSeconds seconds',
              style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextTertiary, fontSize: 11),
            ),
            const SizedBox(height: 16),
            _buildTile(context, Icons.videocam_outlined, 'Record Video', 'Record up to 30s using camera', ImageSource.camera),
            const SizedBox(height: 8),
            _buildTile(context, Icons.video_library_outlined, 'Choose from Gallery', 'Select an existing video', ImageSource.gallery),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title, String subtitle, ImageSource source) {
    return ListTile(
      onTap: () => Navigator.of(context).pop(source),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColor.lightBorder),
      ),
      tileColor: AppColor.lightSurfaceSubtle,
      leading: Icon(icon, color: AppColor.primaryBlue, size: 22),
      title: Text(title, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500, color: AppColor.lightTextPrimary)),
      subtitle: Text(subtitle, style: AppTypography.bodySmall.copyWith(fontSize: 10.5, color: AppColor.lightTextTertiary)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: AppColor.lightTextTertiary),
    );
  }
}
