import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback onEditPhoto;
  final VoidCallback onEditCover;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    required this.onEditPhoto,
    required this.onEditCover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Cover Photo with Overlapping Avatar
          SizedBox(
            height: 140,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Cover Image
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: profile.coverPhotoUrl != null && profile.coverPhotoUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: profile.coverPhotoUrl!,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => Container(color: AppColor.lightSurfaceSubtle),
                            errorWidget: (_, _, _) => _buildDefaultCover(),
                          )
                        : _buildDefaultCover(),
                  ),
                ),

                // Cover Edit Button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onEditCover,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        size: 16,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ),

                // Overlapping Avatar
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -36,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColor.white,
                            shape: BoxShape.circle,
                          ),
                          child: AppAvatar(
                            imageUrl: profile.profilePhotoUrl,
                            name: profile.displayName,
                            size: 76,
                            showOnlineBadge: false,
                          ),
                        ),
                        // Photo Edit Badge
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: onEditPhoto,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                gradient: AppColor.brandGradient,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColor.white, width: 1.5),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 12,
                                color: AppColor.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 42),

          // User Info Details
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Name & Verified Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        profile.displayName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColor.lightTextPrimary,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
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

                // Designation • Company
                if (profile.designation != null || profile.companyName != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    [
                      if (profile.designation != null && profile.designation!.isNotEmpty)
                        profile.designation!,
                      if (profile.companyName != null && profile.companyName!.isNotEmpty)
                        profile.companyName!,
                    ].join(' • '),
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColor.lightTextSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],

                // Location
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 12,
                      color: AppColor.lightTextSecondary,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        profile.formattedLocation,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColor.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Membership Status Chip
                if (profile.membershipStatusLabel != null &&
                    profile.membershipStatusLabel!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFD8B4FE),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.workspace_premium_rounded,
                          size: 13,
                          color: Color(0xFF7E22CE),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          profile.membershipStatusLabel!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7E22CE),
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.primaryBlue.withValues(alpha: 0.85),
            AppColor.primaryPink.withValues(alpha: 0.75),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.landscape_rounded,
          size: 36,
          color: AppColor.white.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
