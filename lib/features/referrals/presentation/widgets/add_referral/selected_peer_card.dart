import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_avatar.dart';
import '../../../../peers/domain/entities/peer_entity.dart';

class SelectedPeerCard extends StatelessWidget {
  final PeerEntity? peer;
  final VoidCallback onTapSelect;
  final VoidCallback onClear;

  const SelectedPeerCard({
    super.key,
    required this.peer,
    required this.onTapSelect,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Given To (Peer Member) *',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColor.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        if (peer == null)
          InkWell(
            onTap: onTapSelect,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColor.lightSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.lightBorder),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person_search_outlined,
                    size: 20,
                    color: AppColor.primaryBlue,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search & select a peer for this referral',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColor.lightTextTertiary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppColor.lightTextTertiary,
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.lightBorder),
            ),
            child: Row(
              children: [
                AppAvatar(
                  imageUrl: peer!.profilePhotoUrl,
                  name: peer!.displayName,
                  size: 48,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        peer!.displayName,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.5,
                          color: AppColor.lightTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (peer!.designation != null &&
                          peer!.designation!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            [
                              peer!.designation!,
                              if (peer!.companyName != null &&
                                  peer!.companyName!.isNotEmpty)
                                peer!.companyName!,
                            ].join(' at '),
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11.5,
                              color: AppColor.lightTextTertiary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: AppColor.lightTextTertiary,
                  ),
                  onPressed: onClear,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
