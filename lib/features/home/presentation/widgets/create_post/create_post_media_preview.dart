import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class CreatePostMediaPreview extends StatelessWidget {
  final File file;
  final String mediaType;
  final VideoPlayerController? videoPlayerController;
  final Duration? videoDuration;
  final bool isSubmitting;
  final bool isDark;
  final VoidCallback onRemove;
  final VoidCallback? onToggleVideoPlayback;

  const CreatePostMediaPreview({
    super.key,
    required this.file,
    required this.mediaType,
    required this.videoPlayerController,
    required this.videoDuration,
    required this.isSubmitting,
    required this.isDark,
    required this.onRemove,
    this.onToggleVideoPlayback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 300),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (mediaType == 'image')
            Image.file(
              file,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          else if (videoPlayerController != null && videoPlayerController!.value.isInitialized)
            GestureDetector(
              onTap: onToggleVideoPlayback,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: videoPlayerController!.value.aspectRatio > 0
                        ? videoPlayerController!.value.aspectRatio
                        : 16 / 9,
                    child: VideoPlayer(videoPlayerController!),
                  ),
                  if (!videoPlayerController!.value.isPlaying)
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                ],
              ),
            )
          else
            Container(
              height: 180,
              color: Colors.black87,
              child: const Center(
                child: Icon(
                  Icons.videocam_rounded,
                  color: Colors.white70,
                  size: 40,
                ),
              ),
            ),

          // Duration Badge
          if (mediaType == 'video' && videoDuration != null)
            Positioned(
              bottom: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.videocam_rounded, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      '${videoDuration!.inMinutes}:${(videoDuration!.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Delete Button
          Positioned(
            top: 10,
            right: 10,
            child: InkWell(
              onTap: isSubmitting ? null : onRemove,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
