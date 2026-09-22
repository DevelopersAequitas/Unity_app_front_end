import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/services/video_cache_service.dart';
import '../../domain/entities/intro_video_entity.dart';
import 'shorts_overlay_info.dart';
import 'shorts_side_actions.dart';
import 'shorts_video_player_view.dart';

class ShortsVideoCard extends StatefulWidget {
  final IntroVideoEntity video;
  final bool isActive;
  final bool isMuted;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleBookmark;
  final VoidCallback onToggleFollow;

  const ShortsVideoCard({
    super.key,
    required this.video,
    required this.isActive,
    required this.isMuted,
    required this.onToggleMute,
    required this.onToggleLike,
    required this.onToggleBookmark,
    required this.onToggleFollow,
  });

  @override
  State<ShortsVideoCard> createState() => _ShortsVideoCardState();
}

class _ShortsVideoCardState extends State<ShortsVideoCard> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _showPlayPauseIcon = false;
  bool _showHeartAnimation = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final url = widget.video.introVideoUrl;
    if (url.isEmpty) return;
    try {
      final cachedFile = await VideoCacheService().getCachedVideoFile(url);
      VideoPlayerController controller;

      if (cachedFile != null && await cachedFile.exists()) {
        controller = VideoPlayerController.file(cachedFile);
      } else {
        // Trigger background caching for future visits and replay
        VideoCacheService().preloadVideo(url);
        controller = VideoPlayerController.networkUrl(Uri.parse(url));
      }

      _controller = controller;
      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      controller.setLooping(true);
      controller.setVolume(widget.isMuted ? 0.0 : 1.0);
      setState(() => _isInitialized = true);
      if (widget.isActive) controller.play();
    } catch (_) {}
  }

  @override
  void didUpdateWidget(covariant ShortsVideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller == null || !_isInitialized) return;
    if (oldWidget.isActive != widget.isActive) {
      widget.isActive ? _controller!.play() : _controller!.pause();
    }
    if (oldWidget.isMuted != widget.isMuted) {
      _controller!.setVolume(widget.isMuted ? 0.0 : 1.0);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null || !_isInitialized) return;
    setState(() {
      _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
      _showPlayPauseIcon = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _showPlayPauseIcon = false);
    });
  }

  void _onDoubleTapLike() {
    if (!widget.video.isLiked) {
      widget.onToggleLike();
    }
    setState(() => _showHeartAnimation = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showHeartAnimation = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ShortsVideoPlayerView(
          controller: _controller,
          isInitialized: _isInitialized,
          showPlayPauseIcon: _showPlayPauseIcon,
          showHeartAnimation: _showHeartAnimation,
          onTap: _togglePlayPause,
          onDoubleTap: _onDoubleTapLike,
        ),
        Positioned(
          left: 16,
          right: 76,
          bottom: 24,
          child: ShortsOverlayInfo(video: widget.video),
        ),
        Positioned(
          right: 12,
          bottom: 24,
          child: ShortsSideActions(
            video: widget.video,
            isMuted: widget.isMuted,
            onToggleMute: widget.onToggleMute,
            onToggleLike: widget.onToggleLike,
            onToggleBookmark: widget.onToggleBookmark,
            onToggleFollow: widget.onToggleFollow,
          ),
        ),
      ],
    );
  }
}
