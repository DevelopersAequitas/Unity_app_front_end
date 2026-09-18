import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/theme/app_typography.dart';
import '../p2p_meeting_creative_card.dart';

class P2pCreativePreviewSection extends StatelessWidget {
  final GlobalKey cardKey;
  final String myName;
  final String? myCity;
  final String? myCompanyName;
  final String? myCategory;
  final String? myAvatarUrl;
  final String peerName;
  final String? peerCity;
  final String? peerCompanyName;
  final String? peerCategory;
  final String? peerAvatarUrl;
  final String? templateBackgroundUrl;

  const P2pCreativePreviewSection({
    super.key,
    required this.cardKey,
    required this.myName,
    this.myCity,
    this.myCompanyName,
    this.myCategory,
    this.myAvatarUrl,
    required this.peerName,
    this.peerCity,
    this.peerCompanyName,
    this.peerCategory,
    this.peerAvatarUrl,
    this.templateBackgroundUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.auto_awesome_outlined,
              size: 15,
              color: AppColor.primaryBlue,
            ),
            const SizedBox(width: 6),
            Text(
              'Dynamic Meeting Creative',
              style: AppTypography.titleSmall.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColor.lightTextPrimary,
              ),
            ),
            const Spacer(),
            Text(
              'Auto Generated',
              style: AppTypography.labelSmall.copyWith(
                fontSize: 10.5,
                color: AppColor.lightTextTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColor.lightBorder, width: 0.9),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: RepaintBoundary(
              key: cardKey,
              child: P2PMeetingCreativeCard(
                myName: myName,
                myCity: myCity,
                myCompanyName: myCompanyName,
                myCategory: myCategory,
                myAvatarUrl: myAvatarUrl,
                peerName: peerName,
                peerCity: peerCity,
                peerCompanyName: peerCompanyName,
                peerCategory: peerCategory,
                peerAvatarUrl: peerAvatarUrl,
                templateBackgroundUrl: templateBackgroundUrl,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
