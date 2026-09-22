import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/intro_video_entity.dart';

class ShortsActionAvatar extends StatelessWidget {
  final IntroVideoEntity video;
  final VoidCallback onToggleFollow;

  const ShortsActionAvatar({
    super.key,
    required this.video,
    required this.onToggleFollow,
  });

  void _openProfile(BuildContext context) {
    if (video.connectionStatus == 'self') {
      Navigator.pushNamed(context, AppRoutes.profile);
    } else {
      Navigator.pushNamed(context, AppRoutes.peerProfile, arguments: video.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = video.profilePhotoUrl != null && video.profilePhotoUrl!.isNotEmpty;
    return GestureDetector(
      onTap: () => _openProfile(context),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColor.brandGradient,
            ),
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.grey.shade800,
              backgroundImage: hasPhoto ? CachedNetworkImageProvider(video.profilePhotoUrl!) : null,
              child: !hasPhoto
                  ? Text(
                      video.displayName.isNotEmpty ? video.displayName[0].toUpperCase() : 'P',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    )
                  : null,
            ),
          ),
          if (video.connectionStatus != 'self' && !video.isFollowing)
            Positioned(
              bottom: -6,
              child: GestureDetector(
                onTap: onToggleFollow,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    gradient: AppColor.brandGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
