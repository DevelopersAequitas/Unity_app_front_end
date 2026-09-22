import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/intro_video_entity.dart';
import 'shorts_action_avatar.dart';

class ShortsSideActions extends StatelessWidget {
  final IntroVideoEntity video;
  final bool isMuted;
  final VoidCallback onToggleMute;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleBookmark;
  final VoidCallback onToggleFollow;

  const ShortsSideActions({
    super.key,
    required this.video,
    required this.isMuted,
    required this.onToggleMute,
    required this.onToggleLike,
    required this.onToggleBookmark,
    required this.onToggleFollow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShortsActionAvatar(video: video, onToggleFollow: onToggleFollow),
        const SizedBox(height: 16),
        _buildActionButton(
          icon: video.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: video.isLiked ? const Color(0xFFEF4444) : Colors.white,
          label: video.likesCount > 0 ? '${video.likesCount}' : 'Like',
          onTap: onToggleLike,
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          icon: video.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          color: video.isBookmarked ? AppColor.warning : Colors.white,
          label: 'Save',
          onTap: onToggleBookmark,
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          icon: isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
          color: Colors.white,
          label: isMuted ? 'Mute' : 'Sound',
          onTap: onToggleMute,
        ),
        const SizedBox(height: 16),
        _buildImpactCounter(),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28, shadows: const [Shadow(color: Colors.black54, blurRadius: 4)]),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w400,
              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCounter() {
    return Column(
      children: [
        const Icon(Icons.person_rounded, color: AppColor.success, size: 24),
        const SizedBox(height: 2),
        Text(
          '${video.lifeImpactedCount}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
          ),
        ),
        Text(
          'Impact',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 9.5,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
