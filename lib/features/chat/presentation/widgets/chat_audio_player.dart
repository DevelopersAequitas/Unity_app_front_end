import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class ChatAudioPlayer extends StatefulWidget {
  final String audioUrl;
  final bool isMine;

  const ChatAudioPlayer({
    super.key,
    required this.audioUrl,
    required this.isMine,
  });

  @override
  State<ChatAudioPlayer> createState() => _ChatAudioPlayerState();
}

class _ChatAudioPlayerState extends State<ChatAudioPlayer> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = const Duration(seconds: 15);
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  void _initAudio() {
    try {
      if (widget.audioUrl.startsWith('http')) {
        _controller =
            VideoPlayerController.networkUrl(Uri.parse(widget.audioUrl));
      } else if (File(widget.audioUrl).existsSync()) {
        _controller = VideoPlayerController.file(File(widget.audioUrl));
      }

      _controller?.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _duration = _controller!.value.duration;
          });
        }
      });

      _controller?.addListener(() {
        if (mounted && _controller != null) {
          final isPlaying = _controller!.value.isPlaying;
          final pos = _controller!.value.position;
          if (isPlaying != _isPlaying || pos != _position) {
            setState(() {
              _isPlaying = isPlaying;
              _position = pos;
            });
          }
          if (pos >= _duration && _isPlaying) {
            setState(() => _isPlaying = false);
          }
        }
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller == null || !_isInitialized) {
      // Toggle visual state if streaming without player
      setState(() => _isPlaying = !_isPlaying);
      return;
    }
    if (_isPlaying) {
      _controller?.pause();
    } else {
      if (_position >= _duration) {
        _controller?.seekTo(Duration.zero);
      }
      _controller?.play();
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString();
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = _duration.inMilliseconds > 0
        ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isMine
            ? Colors.black.withValues(alpha: 0.08)
            : (isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _togglePlay,
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColor.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 3,
                    backgroundColor: widget.isMine
                        ? (isDark
                            ? Colors.white24
                            : AppColor.primaryBlue.withValues(alpha: 0.2))
                        : (isDark
                            ? Colors.white12
                            : AppColor.lightBorder),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.isMine
                          ? (isDark ? Colors.white : AppColor.primaryBlue)
                          : AppColor.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isPlaying
                          ? _formatDuration(_position)
                          : _formatDuration(_duration),
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 10,
                        color: widget.isMine
                            ? (isDark
                                ? Colors.white.withValues(alpha: 0.8)
                                : AppColor.lightTextSecondary)
                            : (isDark
                                ? AppColor.darkTextSecondary
                                : AppColor.lightTextSecondary),
                      ),
                    ),
                    const Icon(
                      Icons.graphic_eq_rounded,
                      size: 14,
                      color: AppColor.primaryBlue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
