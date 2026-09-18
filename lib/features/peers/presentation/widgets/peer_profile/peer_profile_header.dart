import 'package:flutter/material.dart';
import 'package:unity_app/core/constants/app_environment.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/widgets/app_avatar.dart';
import 'package:unity_app/core/widgets/app_gradient_text.dart';
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
        (profile.isOtherCategory ? profile.otherCategoryName : null) ??
        profile.businessSubCategory ??
        profile.businessCategory ??
        profile.mainBusinessCategory ??
        profile.businessType ??
        profile.otherCategoryName ??
        (profile.categories.isNotEmpty
            ? (profile.categories.first.level4 ??
                profile.categories.first.level3 ??
                profile.categories.first.level2 ??
                profile.categories.first.level1)
            : null);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 154,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 114,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1D4ED8).withValues(alpha: 0.15),
                          const Color(0xFFE11D48).withValues(alpha: 0.12),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      image: (profile.coverPhotoUrl != null &&
                              profile.coverPhotoUrl!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(profile.coverPhotoUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (profile.coverPhotoUrl == null ||
                            profile.coverPhotoUrl!.isEmpty)
                        ? Center(
                            child: Opacity(
                              opacity: 0.85,
                              child: Image.asset(
                                'assets/images/icon-bg.png',
                                width: 54,
                                height: 54,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (hasVideo) ...[
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => IntroVideoPlayerDialog.show(
                              context,
                              videoUrl: videoUrl,
                              title: profile.displayName,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColor.brandGradient,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.primaryPink.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.play_circle_fill_rounded,
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
                        ),
                        const SizedBox(width: 8),
                      ],
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
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
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 4,
                  bottom: 2,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: AppAvatar(
                      imageUrl: profile.profilePhotoUrl,
                      name: profile.displayName,
                      size: 68,
                      showOnlineBadge: true,
                      isOnline: profile.isOnline,
                      isPro: profile.isPro,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Flexible(
                child: Text(
                  profile.displayName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: AppColor.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
              if (profile.isPro) ...[
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1.5,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColor.brandGradient,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w500,
                      color: AppColor.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.business_center_outlined,
                size: 13,
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
            const SizedBox(height: 4),
            Row(
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      AppColor.brandGradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: const Icon(
                    Icons.sell_outlined,
                    size: 13,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: AppGradientText(
                    categoryText,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 13,
                color: AppColor.lightTextSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  profile.formattedLocation,
                  style: const TextStyle(
                    fontSize: 11.5,
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
