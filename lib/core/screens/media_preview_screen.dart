import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_color.dart';
import '../../../features/home/domain/entities/timeline_media_entity.dart';

/// Full-screen preview for both images and videos.
///
/// For images: pinch-zoom + dismiss-on-swipe.
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

  @override
  void dispose() {
    _chewieController?.dispose();
    _vpController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: widget.media.isVideo ? _buildVideoPlayer() : _buildImageViewer(),
      ),
    );
  }

  Widget _buildImageViewer() {
    final tag = widget.heroTag ?? widget.media.url;
    return Hero(
      tag: tag,
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5.0,
        child: Image.network(
          widget.media.url,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Icon(
            Icons.broken_image_outlined,
            color: Colors.white38,
            size: 64,
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (!_videoReady || _chewieController == null) {
      return const CircularProgressIndicator(color: AppColor.primaryBlue);
    }
    return Chewie(controller: _chewieController!);
  }
}
