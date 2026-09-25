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
  final VoidCallback? onDoubleTap;

  const TimelineMediaViewer({
    super.key,
    required this.media,
    this.autoPlay = true,
    this.onDoubleTap,
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

    if (fraction >= 0.6) {
      if (_controller == null && !_isInitializing && !_videoError) {
        _initVideo();
      } else if (_controller != null && _videoReady && widget.autoPlay && !_controller!.value.isPlaying) {
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
      onDoubleTap: widget.onDoubleTap,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 480),
        child: ClipRect(
          clipBehavior: Clip.hardEdge,
          child: AspectRatio(
            aspectRatio: 4 / 5,
            child: widget.media.isVideo ? _buildVideo() : _buildImage(),
          ),
        ),
      ),
    );

    if (widget.media.isVideo) {
      return VisibilityDetector(
        key: Key('timeline_video_${widget.media.url}'),
        onVisibilityChanged: (info) =>
            _handleVisibilityChange(info.visibleFraction),
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
    if (!_videoReady || _controller == null || _videoError) {
      return _buildVideoPlaceholder();
    }

    final videoSize = _controller!.value.size;
    final hasValidSize = videoSize.width > 0 && videoSize.height > 0;

    return ClipRect(
      clipBehavior: Clip.hardEdge,
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Center(
              child: hasValidSize
                  ? FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: videoSize.width,
                        height: videoSize.height,
                        child: VideoPlayer(_controller!),
                      ),
                    )
                  : AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio > 0
                          ? _controller!.value.aspectRatio
                          : 4 / 5,
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
                child: const Icon(
                  Icons.volume_off_rounded,
                  size: 16,
                  color: Colors.white,
                ),
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
                    Icon(
                      Icons.play_circle_outline_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
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
        ),
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: AppColor.brandGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 0.8,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.videocam_outlined, size: 14, color: Colors.white),
                  SizedBox(width: 5),
                  Text(
                    'Watch Video',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingBox() {
    return Container(
      color: const Color(0xFF1E222D),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColor.primaryBlue,
          ),
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
