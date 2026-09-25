import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_color.dart';
import '../../../features/home/domain/entities/timeline_media_entity.dart';

/// Full-screen preview for both images and videos.
///
/// For images: full-screen pinch zoom + double-tap zoom across the entire display.
/// For videos: Chewie player (full controls, landscape support).
class MediaPreviewScreen extends StatefulWidget {
  final TimelineMediaEntity media;
  final String? heroTag;

  const MediaPreviewScreen({super.key, required this.media, this.heroTag});

  static Future<void> show(
    BuildContext context, {
    required TimelineMediaEntity media,
    String? heroTag,
  }) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, _, _) =>
            MediaPreviewScreen(media: media, heroTag: heroTag),
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  final TransformationController _transformationController =
      TransformationController();
  TapDownDetails? _doubleTapDetails;
  VideoPlayerController? _vpController;
  ChewieController? _chewieController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.media.isVideo) _initVideo();
  }

  Future<void> _initVideo() async {
    _vpController = VideoPlayerController.networkUrl(
      Uri.parse(widget.media.url),
    );
    await _vpController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _vpController!,
      autoPlay: true,
      looping: true,
      allowFullScreen: false,
      allowMuting: true,
      showControlsOnInitialize: true,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColor.primaryBlue,
        handleColor: AppColor.primaryBlue,
        bufferedColor: AppColor.primaryBlue.withValues(alpha: 0.3),
        backgroundColor: AppColor.darkBorder,
      ),
    );
    if (mounted) setState(() => _videoReady = true);
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails?.localPosition ?? Offset.zero;
      const double scale = 2.5;
      final x = -position.dx * (scale - 1.0);
      final y = -position.dy * (scale - 1.0);
      _transformationController.value = Matrix4.identity()
        ..translateByDouble(x, y, 0.0, 1.0)
        ..scaleByDouble(scale, scale, 1.0, 1.0);
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _chewieController?.dispose();
    _vpController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen media viewer
          Positioned.fill(
            child: widget.media.isVideo ? _buildVideoPlayer() : _buildImageViewer(),
          ),

          // Floating dismiss button in safe area
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageViewer() {
    final tag = widget.heroTag ?? widget.media.url;
    return GestureDetector(
      onDoubleTapDown: (details) => _doubleTapDetails = details,
      onDoubleTap: _handleDoubleTap,
      child: SizedBox.expand(
        child: InteractiveViewer(
          transformationController: _transformationController,
          clipBehavior: Clip.hardEdge,
          boundaryMargin: EdgeInsets.zero,
          minScale: 1.0,
          maxScale: 5.0,
          child: Hero(
            tag: tag,
            child: Center(
              child: CachedNetworkImage(
                imageUrl: widget.media.url,
                fit: BoxFit.contain,
                width: double.infinity,
                height: double.infinity,
                placeholder: (_, _) => const Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                ),
                errorWidget: (_, _, _) => const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white38,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (!_videoReady || _chewieController == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryBlue),
      );
    }
    return Center(
      child: Chewie(controller: _chewieController!),
    );
  }
}
