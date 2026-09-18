import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/business_deal_entity.dart';
import 'business_deal_share_helper.dart';

class BusinessDealOptionsSheet extends StatelessWidget {
  final BusinessDealEntity deal;
  final String? currentUserName;
  final String tabType;

  const BusinessDealOptionsSheet({
    super.key,
    required this.deal,
    this.currentUserName,
    this.tabType = 'received',
  });

  static Future<void> show(
    BuildContext context, {
    required BusinessDealEntity deal,
    String? currentUserName,
    String tabType = 'received',
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.transparent,
      builder: (_) => BusinessDealOptionsSheet(
        deal: deal,
        currentUserName: currentUserName,
        tabType: tabType,
      ),
    );
  }

  void _onShare(BuildContext context) {
    Navigator.pop(context);
    BusinessDealShareHelper.shareBusinessDeal(
      deal: deal,
      currentUserName: currentUserName,
      tabType: tabType,
    );
  }

  void _onViewProfile(BuildContext context) {
    Navigator.pop(context);
    final peerId = deal.fromUserId ?? deal.toUserId;
    if (peerId != null && peerId.isNotEmpty) {
      Navigator.pushNamed(context, AppRoutes.peerProfile, arguments: peerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.lightSurface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),

            // Option 1: Share Business Deal
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.share_outlined,
                  size: 18,
                  color: AppColor.primaryBlue,
                ),
              ),
              title: Text(
                'Share Business Deal',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              subtitle: Text(
                'Share deal details and link with network',
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 11,
                  color: AppColor.lightTextTertiary,
                ),
              ),
              onTap: () => _onShare(context),
            ),

            // Option 2: View Peer Profile
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.lightSurfaceSubtle,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 18,
                  color: AppColor.lightTextSecondary,
                ),
              ),
              title: Text(
                'View Profile',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              subtitle: Text(
                deal.peerName,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 11,
                  color: AppColor.lightTextTertiary,
                ),
              ),
              onTap: () => _onViewProfile(context),
            ),
          ],
        ),
      ),
    );
  }
}
