import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/constants/app_environment.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class IntroVideoPlayerDialog extends StatefulWidget {
  final String videoUrl;
  final String? title;

  const IntroVideoPlayerDialog({
    super.key,
    required this.videoUrl,
    this.title,
  });

  static Future<void> show(
    BuildContext context, {
    required String videoUrl,
    String? title,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => IntroVideoPlayerDialog(
        videoUrl: videoUrl,
        title: title,
      ),
    );
  }

  @override
  State<IntroVideoPlayerDialog> createState() => _IntroVideoPlayerDialogState();
}

class _IntroVideoPlayerDialogState extends State<IntroVideoPlayerDialog> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      String effectiveUrl = widget.videoUrl.trim();
      if (!effectiveUrl.startsWith('http://') && !effectiveUrl.startsWith('https://')) {
        if (effectiveUrl.startsWith('/')) {
          effectiveUrl = '${AppEnvironment.baseUrl}$effectiveUrl';
        } else {
          effectiveUrl = '${AppEnvironment.baseUrl}/$effectiveUrl';
        }
      }
      final uri = Uri.parse(effectiveUrl);
      final controller = VideoPlayerController.networkUrl(uri);
      _videoPlayerController = controller;

      await controller.initialize();

      if (!mounted) return;

      final aspectRatio = controller.value.aspectRatio > 0
          ? controller.value.aspectRatio
          : (16 / 9);

      _chewieController = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: false,
        aspectRatio: aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColor.primaryBlue,
          handleColor: AppColor.primaryBlue,
          bufferedColor: AppColor.primaryBlue.withValues(alpha: 0.3),
          backgroundColor: Colors.grey.shade800,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load video. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleText = widget.title != null && widget.title!.isNotEmpty
        ? "${widget.title}'s Pitch Video"
        : 'Profile Introduction Video';

    final maxHeight = MediaQuery.of(context).size.height * 0.75;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: AppColor.lightSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColor.lightSurface,
                border: Border(bottom: BorderSide(color: AppColor.lightBorder)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.videocam_rounded,
                      size: 16,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      titleText,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.5,
                        color: AppColor.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppColor.lightTextSecondary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Video Player Body
            Flexible(
              child: Container(
                color: Colors.black,
                constraints: const BoxConstraints(minHeight: 200),
                child: _buildBody(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryBlue),
            ),
            SizedBox(height: 12),
            Text(
              'Loading intro video...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_hasError || _chewieController == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.redAccent,
                size: 36,
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage ?? 'Unable to play video',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _initializePlayer,
                icon: const Icon(Icons.refresh_rounded, size: 14, color: Colors.white),
                label: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white30),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Chewie(controller: _chewieController!),
    );
  }
}
