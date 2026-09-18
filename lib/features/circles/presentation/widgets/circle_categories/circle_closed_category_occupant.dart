import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/widgets/app_avatar.dart';
import '../../../../../core/widgets/app_gradient_text.dart';
import '../../../../peers/domain/entities/peer_entity.dart';

class CircleClosedCategoryOccupant extends StatelessWidget {
  final PeerEntity peer;
  final bool isCurrentUser;
  final bool isDark;
  final Color secondaryText;

  const CircleClosedCategoryOccupant({
    super.key,
    required this.peer,
    required this.isCurrentUser,
    required this.isDark,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAvatar(
          imageUrl: peer.profilePhotoUrl,
          name: peer.displayName,
          size: 32,
          showOnlineBadge: true,
          isOnline: peer.isOnline,
          isPro: peer.isPro,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      peer.displayName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColor.darkTextPrimary
                            : AppColor.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (peer.isVerified) ...[
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.verified_rounded,
                      size: 13,
                      color: AppColor.primaryBlue,
                    ),
                  ],
                  if (peer.isPro) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1.5,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColor.brandGradient,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: AppColor.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                  if (isCurrentUser) ...[
                    const SizedBox(width: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColor.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'YOU',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w500,
                          color: AppColor.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if ((peer.designation != null &&
                      peer.designation!.trim().isNotEmpty) ||
                  (peer.companyName != null &&
                      peer.companyName!.trim().isNotEmpty)) ...[
                const SizedBox(height: 1.5),
                Row(
                  children: [
                    Icon(
                      Icons.business_center_rounded,
                      size: 9.5,
                      color: secondaryText,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        [
                          if (peer.designation != null &&
                              peer.designation!.trim().isNotEmpty)
                            peer.designation!.trim(),
                          if (peer.companyName != null &&
                              peer.companyName!.trim().isNotEmpty)
                            peer.companyName!.trim(),
                        ].join(' · '),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if ((peer.city != null && peer.city!.trim().isNotEmpty) ||
                  (peer.category != null &&
                      peer.category!.trim().isNotEmpty)) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (peer.city != null &&
                        peer.city!.trim().isNotEmpty) ...[
                      Icon(
                        Icons.location_on_rounded,
                        size: 10,
                        color: secondaryText,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        peer.city!.trim(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: secondaryText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (peer.city != null &&
                        peer.city!.trim().isNotEmpty &&
                        peer.category != null &&
                        peer.category!.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          '·',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: secondaryText,
                          ),
                        ),
                      ),
                    if (peer.category != null &&
                        peer.category!.trim().isNotEmpty)
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColor.darkSurfaceSubtle
                                : AppColor.badgeBlueBg,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: AppColor.primaryBlue
                                  .withValues(alpha: 0.15),
                              width: 0.6,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) =>
                                    AppColor.brandGradient.createShader(
                                  Rect.fromLTWH(
                                      0, 0, bounds.width, bounds.height),
                                ),
                                child: const Icon(
                                  Icons.sell_outlined,
                                  size: 8,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Flexible(
                                child: AppGradientText(
                                  peer.category!.trim(),
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (peer.lifeImpactedCount != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColor.darkSurfaceSubtle
                  : AppColor.lightSurfaceMuted,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: (isDark ? AppColor.darkBorder : AppColor.lightBorder)
                    .withValues(alpha: 0.8),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColor.brandGradient.createShader(bounds),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 12,
                    color: AppColor.white,
                  ),
                ),
                const SizedBox(width: 4),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColor.brandGradient.createShader(bounds),
                  child: Text(
                    '${peer.lifeImpactedCount}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
