import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_environment.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/profile_entity.dart';
import 'intro_video_player_dialog.dart';

class ProfileMediaTab extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileMediaTab({super.key, required this.profile});

  String? get _effectiveVideoUrl {
    if (profile.profileVideoUrl != null && profile.profileVideoUrl!.trim().isNotEmpty) {
      return profile.profileVideoUrl!.trim();
    }
    if (profile.profileVideoId != null && profile.profileVideoId!.trim().isNotEmpty) {
      return '${AppEnvironment.baseUrl}/files/${profile.profileVideoId!.trim()}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final mediaList = profile.media;
    final videoUrl = _effectiveVideoUrl;
    final hasVideo = videoUrl != null && videoUrl.isNotEmpty;

    if (!hasVideo && mediaList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            const Icon(Icons.perm_media_outlined, size: 36, color: AppColor.lightTextTertiary),
            const SizedBox(height: 8),
            Text(
              'No media uploaded yet',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColor.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Upload photos, portfolio items and video to stand out.',
              style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextTertiary, fontSize: 11.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasVideo) ...[
          Text(
            'Profile Video',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: AppColor.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              IntroVideoPlayerDialog.show(
                context,
                videoUrl: videoUrl,
                title: profile.displayName,
              );
            },
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.lightBorder),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (profile.coverPhotoUrl != null && profile.coverPhotoUrl!.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: profile.coverPhotoUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  Container(color: Colors.black.withValues(alpha: 0.35)),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColor.brandGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primaryPink.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.play_arrow_rounded, size: 28, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (mediaList.isNotEmpty) ...[
          Text(
            'Portfolio & Media (${mediaList.length})',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: AppColor.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: mediaList.length,
            itemBuilder: (_, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: mediaList[index].url,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(color: AppColor.lightSurfaceSubtle),
                  errorWidget: (_, _, _) => Container(
                    color: AppColor.lightSurfaceSubtle,
                    child: const Icon(Icons.broken_image_outlined, size: 20, color: AppColor.lightTextTertiary),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
