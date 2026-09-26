import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../features/peers/domain/entities/peer_entity.dart';

class AskMatchPeerHeader extends StatelessWidget {
  final PeerEntity peer;

  const AskMatchPeerHeader({super.key, required this.peer});

  @override
  Widget build(BuildContext context) {
    final hasCompany = (peer.designation != null && peer.designation!.isNotEmpty) ||
        (peer.companyName != null && peer.companyName!.isNotEmpty);
    final hasCity = peer.city != null && peer.city!.isNotEmpty;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.peerProfile,
          arguments: peer,
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppAvatar(
            imageUrl: peer.profilePhotoUrl,
            name: peer.displayName,
            size: 42,
            showOnlineBadge: true,
            isOnline: peer.isOnline,
            isPro: peer.isPro,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        peer.displayName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: AppColor.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (peer.isVerified) ...[
                      const SizedBox(width: 3),
                      const Icon(Icons.verified_rounded, size: 14, color: AppColor.primaryBlue),
                    ],
                    if (peer.isPro) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          gradient: AppColor.brandGradient,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (hasCity) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 11, color: AppColor.lightTextSecondary),
                      const SizedBox(width: 2.5),
                      Expanded(
                        child: Text(
                          peer.city!.trim(),
                          style: const TextStyle(fontSize: 11, color: AppColor.lightTextSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (hasCompany) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.business_center_rounded, size: 11, color: AppColor.lightTextSecondary),
                      const SizedBox(width: 2.5),
                      Expanded(
                        child: Text(
                          [
                            if (peer.designation != null && peer.designation!.isNotEmpty) peer.designation!.trim(),
                            if (peer.companyName != null && peer.companyName!.isNotEmpty) peer.companyName!.trim(),
                          ].join(' · '),
                          style: const TextStyle(fontSize: 11, color: AppColor.lightTextSecondary),
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
          if (peer.lifeImpactedCount != null && peer.lifeImpactedCount! > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: AppColor.lightSurfaceMuted,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColor.lightBorder, width: 0.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_rounded, size: 12, color: AppColor.primaryBlue),
                  const SizedBox(width: 3),
                  Text(
                    '${peer.lifeImpactedCount}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
