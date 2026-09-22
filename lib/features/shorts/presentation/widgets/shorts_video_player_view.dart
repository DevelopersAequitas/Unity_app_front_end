import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShortsVideoPlayerView extends StatelessWidget {
  final VideoPlayerController? controller;
  final bool isInitialized;
  final bool showPlayPauseIcon;
  final bool showHeartAnimation;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const ShortsVideoPlayerView({
    super.key,
    required this.controller,
    required this.isInitialized,
    required this.showPlayPauseIcon,
    required this.showHeartAnimation,
    required this.onTap,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GestureDetector(
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            color: Colors.black,
            child: isInitialized && controller != null
                ? Center(
                    child: AspectRatio(
                      aspectRatio: controller!.value.aspectRatio,
                      child: VideoPlayer(controller!),
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  ),
          ),
        ),
        if (showHeartAnimation)
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.2, end: 1.2),
              duration: const Duration(milliseconds: 350),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFEF4444),
                    size: 96,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 16)],
                  ),
                );
              },
            ),
          ),
        if (showPlayPauseIcon && controller != null && !showHeartAnimation)
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller!.value.isPlaying ? Icons.play_arrow_rounded : Icons.pause_rounded,
                color: Colors.white,
                size: 42,
              ),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 220,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.9)],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
