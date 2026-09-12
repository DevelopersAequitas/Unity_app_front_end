import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_avatar.dart';

class ProfileHeaderCover extends StatelessWidget {
  final String? coverUrl;
  final String? photoUrl;
  final String displayName;
  final VoidCallback onEditPhoto;
  final VoidCallback onEditCover;

  const ProfileHeaderCover({
    super.key,
    required this.coverUrl,
    required this.photoUrl,
    required this.displayName,
    required this.onEditPhoto,
    required this.onEditCover,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: coverUrl != null && coverUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: coverUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(color: AppColor.lightSurfaceSubtle),
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
                decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt_outlined, size: 16, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: -36,
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: AppAvatar(
                    imageUrl: photoUrl,
                    name: displayName,
                    size: 76,
                    showOnlineBadge: false,
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: onEditPhoto,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColor.primaryBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(Icons.camera_alt_outlined, size: 13, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      color: AppColor.primaryBlue.withValues(alpha: 0.12),
      child: const Center(
        child: Icon(Icons.landscape_outlined, size: 32, color: AppColor.primaryBlue),
      ),
    );
  }
}
