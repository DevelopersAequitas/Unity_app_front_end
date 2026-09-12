import 'package:flutter/material.dart';
import 'package:unity_app/core/constants/app_environment.dart';

import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/widgets/app_avatar.dart';
import 'package:unity_app/features/profile/domain/entities/profile_entity.dart';
import 'package:unity_app/features/profile/presentation/widgets/intro_video_player_dialog.dart';

class PeerProfileHeader extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback onBookmarkToggle;

  const PeerProfileHeader({
    super.key,
    required this.profile,
    required this.onBookmarkToggle,
  });

  String? get _effectiveVideoUrl {
    if (profile.profileVideoUrl != null &&
        profile.profileVideoUrl!.trim().isNotEmpty) {
      return profile.profileVideoUrl!.trim();
    }
    if (profile.profileVideoId != null &&
        profile.profileVideoId!.trim().isNotEmpty) {
      return '${AppEnvironment.baseUrl}/files/${profile.profileVideoId!.trim()}';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final videoUrl = _effectiveVideoUrl;
    final hasVideo = videoUrl != null && videoUrl.isNotEmpty;
    final categoryText =
        profile.businessSubCategory ??
        profile.businessCategory ??
        profile.businessType;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceMuted,
                  borderRadius: BorderRadius.circular(16),
                  image:
                      (profile.coverPhotoUrl != null &&
                          profile.coverPhotoUrl!.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(profile.coverPhotoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: -40,
                right: 12,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasVideo) ...[
                      InkWell(
                        onTap: () => IntroVideoPlayerDialog.show(
                          context,
                          videoUrl: videoUrl,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColor.brandGradient,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_circle_fill,
                                size: 15,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Intro Video',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    InkWell(
                      onTap: onBookmarkToggle,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColor.lightSurface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColor.lightBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          profile.isBookmark
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: profile.isBookmark
                              ? AppColor.primaryPink
                              : AppColor.lightTextSecondary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -32,
                left: 12,
                child: AppAvatar(
                  imageUrl: profile.profilePhotoUrl,
                  name: profile.displayName,
                  size: 72,
                  showOnlineBadge: true,
                  isOnline: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Text(
                profile.displayName.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              if (profile.isVerified) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: AppColor.primaryBlue,
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.business_center_outlined,
                size: 14,
                color: AppColor.lightTextSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  [
                    'Member',
                    if (profile.companyName != null &&
                        profile.companyName!.isNotEmpty)
                      profile.companyName!,
                    if (profile.designation != null &&
                        profile.designation!.isNotEmpty)
                      profile.designation!,
                  ].join(' • '),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (categoryText != null && categoryText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: AppColor.brandGradient,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sell_outlined,
                    size: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    categoryText,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColor.lightTextSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  profile.formattedLocation,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColor.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
