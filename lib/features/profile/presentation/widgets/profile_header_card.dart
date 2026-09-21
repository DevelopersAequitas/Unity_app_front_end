import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_environment.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../domain/entities/profile_entity.dart';
import 'intro_video_player_dialog.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback onEditPhoto;
  final VoidCallback onEditCover;
  final VoidCallback onEditProfile;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    required this.onEditPhoto,
    required this.onEditCover,
    required this.onEditProfile,
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
    final categoryText =
        (profile.isOtherCategory ? profile.otherCategoryName : null) ??
        profile.businessSubCategory ??
        profile.businessCategory ??
        profile.mainBusinessCategory ??
        profile.otherCategoryName ??
        (profile.categories.isNotEmpty
            ? (profile.categories.first.level4 ??
                profile.categories.first.level3 ??
                profile.categories.first.level2 ??
                profile.categories.first.level1)
            : null);

    final workList = [
      if (profile.designation != null && profile.designation!.isNotEmpty)
        profile.designation!,
      if (profile.companyName != null && profile.companyName!.isNotEmpty)
        profile.companyName!,
    ];
    final workText = workList.join(' • ');

    final cityName =
        profile.city?.name ?? profile.city?.formattedLocation ?? '';
    final stateName = profile.state ?? '';
    final countryRaw = profile.country ?? '';
    final countryCode = countryRaw.toLowerCase() == 'india'
        ? 'India'
        : countryRaw;

    final locationParts = [
      if (cityName.isNotEmpty) cityName,
      if (stateName.isNotEmpty) stateName,
      if (countryCode.isNotEmpty) countryCode,
    ];
    final location = locationParts.isNotEmpty
        ? locationParts.join(', ')
        : profile.formattedLocation;

    final introduced = profile.introducedByUser;
    final timezone = profile.timezone;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 148,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 110,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child:
                        profile.coverPhotoUrl != null &&
                            profile.coverPhotoUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: profile.coverPhotoUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, _) =>
                                Container(color: AppColor.lightSurfaceSubtle),
                            errorWidget: (_, _, _) => _buildDefaultCover(),
                          )
                        : _buildDefaultCover(),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onEditCover,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: AppColor.brandGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 72,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: AppAvatar(
                          imageUrl: profile.profilePhotoUrl,
                          name: profile.displayName,
                          size: 68,
                          showOnlineBadge: false,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: onEditPhoto,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              gradient: AppColor.brandGradient,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.primaryPink.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 14,
                  bottom: 2,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_effectiveVideoUrl != null) ...[
                        _buildIntroVideoBtn(context),
                        const SizedBox(width: 6),
                      ],
                      _buildEditProfileBtn(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.displayName.toUpperCase(),
                        style: AppTypography.titleMedium.copyWith(
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
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColor.brandGradient,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: AppColor.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (workText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.business_center_outlined,
                        size: 13,
                        color: AppColor.lightTextTertiary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          workText,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 12.5,
                            color: AppColor.lightTextSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (categoryText != null && categoryText.isNotEmpty) ...[
                  const SizedBox(height: 5),
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
                      Flexible(
                        child: AppGradientText(
                          categoryText,
                          style: AppTypography.labelSmall.copyWith(
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
                if (location.isNotEmpty ||
                    (timezone != null && timezone.isNotEmpty)) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (location.isNotEmpty) ...[
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: AppColor.lightTextTertiary,
                        ),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            location,
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11.5,
                              color: AppColor.lightTextTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      if (location.isNotEmpty &&
                          timezone != null &&
                          timezone.isNotEmpty) ...[
                        Text(
                          '  •  ',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColor.lightTextTertiary,
                          ),
                        ),
                      ],
                      if (timezone != null && timezone.isNotEmpty) ...[
                        const Icon(
                          Icons.schedule_outlined,
                          size: 12,
                          color: AppColor.lightTextTertiary,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          timezone,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColor.lightTextTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
                if (introduced != null && introduced.name.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (introduced.profilePhotoUrl != null &&
                          introduced.profilePhotoUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: introduced.profilePhotoUrl!,
                            width: 14,
                            height: 14,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        const Icon(
                          Icons.person_outline,
                          size: 13,
                          color: AppColor.lightTextTertiary,
                        ),
                      const SizedBox(width: 4),
                      Text(
                        'Introduced by ',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColor.lightTextTertiary,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          introduced.name,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColor.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroVideoBtn(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          IntroVideoPlayerDialog.show(
            context,
            videoUrl: _effectiveVideoUrl!,
            title: profile.displayName,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            gradient: AppColor.brandGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryPink.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 1.5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.play_circle_fill_rounded,
                size: 13,
                color: Colors.white,
              ),
              const SizedBox(width: 3.5),
              Text(
                'Intro Video',
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditProfileBtn(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onEditProfile,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColor.brandGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryPink.withValues(alpha: 0.15),
                blurRadius: 4,
                offset: const Offset(0, 1.5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(1),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 4.5,
            ),
            decoration: BoxDecoration(
              color: AppColor.lightSurface,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => AppColor.brandGradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.edit_outlined,
                    size: 12.5,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 3.5),
                  Text(
                    'Edit Profile',
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1D4ED8).withValues(alpha: 0.15),
            const Color(0xFFE11D48).withValues(alpha: 0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Opacity(
          opacity: 0.85,
          child: Image.asset(
            'assets/images/icon-bg.png',
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
