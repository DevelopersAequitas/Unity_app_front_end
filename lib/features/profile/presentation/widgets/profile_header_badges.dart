import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileHeaderBadges extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileHeaderBadges({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final mainCat =
        profile.mainBusinessCategory ??
        profile.businessType ??
        profile.businessCategory ??
        (profile.categories.isNotEmpty
            ? profile.categories.first.level1
            : null);

    final subCat =
        (profile.isOtherCategory ? profile.otherCategoryName : null) ??
        profile.businessSubCategory ??
        profile.otherCategoryName ??
        (profile.categories.isNotEmpty
            ? profile.categories.first.level4
            : null);

    final circleName =
        profile.activeCircle?.name ??
        (profile.categories.isNotEmpty
            ? profile.categories.first.circleName
            : null);
    final introduced = profile.introducedByUser;
    final peerId = profile.peerId;

    return Column(
      children: [
        if ((mainCat != null && mainCat.isNotEmpty) ||
            (subCat != null && subCat.isNotEmpty)) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              if (mainCat != null && mainCat.isNotEmpty)
                Expanded(
                  child: _buildCategoryCard(
                    mainCat,
                    Icons.category_outlined,
                    AppColor.primaryBlue,
                    AppColor.primaryBlue.withValues(alpha: 0.08),
                  ),
                ),
              if (mainCat != null &&
                  mainCat.isNotEmpty &&
                  subCat != null &&
                  subCat.isNotEmpty &&
                  subCat != mainCat)
                const SizedBox(width: 8),
              if (subCat != null && subCat.isNotEmpty && subCat != mainCat)
                Expanded(
                  child: _buildCategoryCard(
                    subCat,
                    Icons.subdirectory_arrow_right_rounded,
                    AppColor.lightTextSecondary,
                    AppColor.lightSurfaceSubtle,
                    hasBorder: true,
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (circleName != null && circleName.isNotEmpty)
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.groups_2_outlined,
                      size: 13,
                      color: Color(0xFF0D9488),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        circleName,
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0D9488),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            else if (peerId != null && peerId.isNotEmpty)
              Text(
                'Peer ID: $peerId',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 10.5,
                  color: AppColor.lightTextTertiary,
                ),
              ),
            if (introduced != null && introduced.name.isNotEmpty) ...[
              const SizedBox(width: 8),
              _buildIntroducedBy(introduced),
            ] else if (circleName != null &&
                peerId != null &&
                peerId.isNotEmpty) ...[
              // const SizedBox(width: 8),
              // Text('ID: $peerId', style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColor.lightTextTertiary)),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryCard(
    String text,
    IconData icon,
    Color color,
    Color bg, {
    bool hasBorder = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: hasBorder ? Border.all(color: AppColor.lightBorder) : null,
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroducedBy(IntroducedByUserEntity introduced) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
            size: 12,
            color: AppColor.lightTextTertiary,
          ),
        const SizedBox(width: 4),
        Text(
          'By ${introduced.name}',
          style: AppTypography.labelSmall.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColor.lightTextSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
