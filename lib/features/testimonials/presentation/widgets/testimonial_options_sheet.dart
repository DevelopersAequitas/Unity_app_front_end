import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/testimonial_entity.dart';
import 'testimonial_share_helper.dart';

class TestimonialOptionsSheet extends StatelessWidget {
  final TestimonialEntity testimonial;
  final String? currentUserName;
  final String tabType;

  const TestimonialOptionsSheet({
    super.key,
    required this.testimonial,
    this.currentUserName,
    this.tabType = 'received',
  });

  static Future<void> show(
    BuildContext context, {
    required TestimonialEntity testimonial,
    String? currentUserName,
    String tabType = 'received',
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.transparent,
      builder: (_) => TestimonialOptionsSheet(
        testimonial: testimonial,
        currentUserName: currentUserName,
        tabType: tabType,
      ),
    );
  }

  void _onShare(BuildContext context) {
    Navigator.pop(context);
    TestimonialShareHelper.shareTestimonial(
      testimonial: testimonial,
      currentUserName: currentUserName,
      tabType: tabType,
    );
  }

  void _onViewProfile(BuildContext context) {
    Navigator.pop(context);
    final peerId = testimonial.fromUserId ?? testimonial.toUserId;
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

            // Option 1: Share Testimonial
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
                'Share Testimonial',
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColor.lightTextPrimary,
                ),
              ),
              subtitle: Text(
                testimonial.media.isNotEmpty
                    ? 'Share testimonial quote with image & link'
                    : 'Share testimonial quote with link',
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
                testimonial.peerName,
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
