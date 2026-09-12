import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileMediaTab extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileMediaTab({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final mediaList = profile.media;
    final hasVideo = profile.profileVideoUrl != null && profile.profileVideoUrl!.isNotEmpty;
    final hasMedia = mediaList.isNotEmpty || hasVideo;

    if (!hasMedia) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl, horizontal: AppSpacing.lg),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColor.backgroundSubtle,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.perm_media_outlined,
                size: 36,
                color: AppColor.textTertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No media uploaded yet',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Upload photos, portfolio items and your profile video to stand out.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColor.textTertiary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Video Section if present
          if (hasVideo) ...[
            Text(
              'Profile Video',
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.black,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColor.borderSubtle),
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
                  Container(
                    color: Colors.black.withValues(alpha: 0.35),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColor.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 32,
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Media items grid
          if (mediaList.isNotEmpty) ...[
            Text(
              'Portfolio & Media (${mediaList.length})',
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1,
              ),
              itemCount: mediaList.length,
              itemBuilder: (context, index) {
                final item = mediaList[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: item.url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColor.backgroundSubtle,
                          child: const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 1.5),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColor.backgroundSubtle,
                          child: const Icon(Icons.broken_image_outlined, size: 20, color: AppColor.textTertiary),
                        ),
                      ),
                      if (item.type == 'video')
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.play_circle_fill,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
