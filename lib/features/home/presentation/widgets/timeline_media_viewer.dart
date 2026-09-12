import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../core/screens/media_preview_screen.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/timeline_media_entity.dart';

/// In-feed media widget that renders a 4:5 image or an Instagram-style
/// auto-playing muted inline video.
///
/// Video playback behavior:
/// - Lazy: Only initializes and plays when the video is >= 60% visible on screen.
/// - Auto-pauses immediately when scrolled away (< 40% visible) or when the tab is inactive.
/// - Releases resources cleanly to prevent main-thread jank and dropped frames.
class TimelineMediaViewer extends StatefulWidget {
  final TimelineMediaEntity media;
  final bool autoPlay;

  const TimelineMediaViewer({
    super.key,
    required this.media,
    this.autoPlay = true,
  });

  @override
  State<TimelineMediaViewer> createState() => _TimelineMediaViewerState();
}

class _TimelineMediaViewerState extends State<TimelineMediaViewer> {
  VideoPlayerController? _controller;
  bool _isInitializing = false;
  bool _videoReady = false;
  bool _videoError = false;
  double _visibleFraction = 0.0;

  @override
  void initState() {
    super.initState();
    // Do NOT initialize ExoPlayer eagerly in initState.
    // Wait until VisibilityDetector reports that this item is in the viewport!
  }

  @override
  void didUpdateWidget(covariant TimelineMediaViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoPlay != widget.autoPlay) {
      if (!widget.autoPlay) {
        _controller?.pause();
      } else if (_visibleFraction >= 0.6) {
        _handleVisibilityChange(_visibleFraction);
      }
    }
  }

  void _handleVisibilityChange(double fraction) {
    _visibleFraction = fraction;
    if (!mounted || !widget.media.isVideo) return;

    if (fraction >= 0.6 && widget.autoPlay) {
      if (_controller == null && !_isInitializing && !_videoError) {
        _initVideo();
      } else if (_controller != null && _videoReady && !_controller!.value.isPlaying) {
        _controller!.play();
      }
    } else if (fraction < 0.4) {
      if (_controller != null && _controller!.value.isPlaying) {
        _controller!.pause();
      }
    }
  }

  Future<void> _initVideo() async {
    if (_isInitializing || _controller != null) return;
    _isInitializing = true;
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.media.url),
      );
      _controller = controller;
      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      controller.setLooping(true);
      controller.setVolume(0); // muted in feed
      
      if (_visibleFraction >= 0.6 && widget.autoPlay) {
        controller.play();
      }
      if (mounted) {
        setState(() {
          _videoReady = true;
          _isInitializing = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _videoError = true;
          _isInitializing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  void _openPreview() {
    _controller?.pause();
    MediaPreviewScreen.show(
      context,
      media: widget.media,
      heroTag: widget.media.url,
    ).then((_) {
      if (widget.media.isVideo && widget.autoPlay && _visibleFraction >= 0.6) {
        _controller?.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaContent = GestureDetector(
      onTap: _openPreview,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 4 / 5,
          child: widget.media.isVideo ? _buildVideo() : _buildImage(),
        ),
      ),
    );

    if (widget.media.isVideo) {
      return VisibilityDetector(
        key: Key('timeline_video_${widget.media.url}'),
        onVisibilityChanged: (info) => _handleVisibilityChange(info.visibleFraction),
        child: mediaContent,
      );
    }

    return mediaContent;
  }

  Widget _buildImage() {
    return Hero(
      tag: widget.media.url,
      child: CachedNetworkImage(
        imageUrl: widget.media.url,
        fit: BoxFit.cover,
        memCacheWidth: 720,
        placeholder: (_, _) => _loadingBox(),
        errorWidget: (_, _, _) => _errorBox(),
      ),
    );
  }

  Widget _buildVideo() {
    if (_videoError) return _errorBox();

    if (!_videoReady || _controller == null) {
      return _loadingBox();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.size.width,
            height: _controller!.value.size.height,
            child: VideoPlayer(_controller!),
          ),
        ),
        // Play icon hint overlay (muted indicator)
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.volume_off_rounded, size: 16, color: Colors.white),
          ),
        ),
        // Tap-to-expand hint
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_circle_outline_rounded, size: 14, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'Tap to watch',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _loadingBox() {
    return Container(
      color: const Color(0xFF1E222D),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColor.primaryBlue,
        ),
      ),
    );
  }

  Widget _errorBox() {
    return Container(
      color: AppColor.darkBorder.withValues(alpha: 0.2),
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 40,
          color: AppColor.lightTextDisabled,
        ),
      ),
    );
  }
}
