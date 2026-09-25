import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../domain/entities/business_deal_entity.dart';
import 'business_deal_share_helper.dart';

class BusinessDealDetailSheet extends StatelessWidget {
  final BusinessDealEntity deal;
  final String? currentUserName;
  final String tabType;
  final String dateStr;

  const BusinessDealDetailSheet({
    super.key,
    required this.deal,
    this.currentUserName,
    this.tabType = 'received',
    required this.dateStr,
  });

  static Future<void> show(
    BuildContext context, {
    required BusinessDealEntity deal,
    String? currentUserName,
    String tabType = 'received',
    required String dateStr,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      builder: (_) => BusinessDealDetailSheet(
        deal: deal,
        currentUserName: currentUserName,
        tabType: tabType,
        dateStr: dateStr,
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

  void _openImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 3.5,
                boundaryMargin: EdgeInsets.zero,
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Container(
                    padding: const EdgeInsets.all(24),
                    color: Colors.white,
                    child: const Text('Failed to load image'),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black54,
                radius: 16,
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _onPeerTap(BuildContext context) {
    Navigator.pop(context);
    final peerId = deal.fromUserId ?? deal.toUserId;
    if (peerId != null && peerId.isNotEmpty) {
      Navigator.pushNamed(context, AppRoutes.peerProfile, arguments: peerId);
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} Lakh';
    }
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))'),
          (m) => '${m[1]},',
        );
    return '₹$formatted';
  }

  @override
  Widget build(BuildContext context) {
    final designation = deal.peerDesignation?.trim() ?? '';
    final company = deal.peerCompany?.trim() ?? '';
    final city = (deal.city ?? deal.peerLocation)?.trim() ?? '';
    final category = deal.category?.trim() ?? '';
    final comment = deal.comment?.trim() ?? '';
    final isNew = deal.isNewBusiness;

    final subLine = [
      if (designation.isNotEmpty) designation,
      if (company.isNotEmpty) company,
    ].join(' · ');

    return Material(
      color: AppColor.lightSurface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          16 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Header Row: Date & Time + Share icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateStr,
                  style: const TextStyle(
                    color: AppColor.lightTextTertiary,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: AppColor.primaryBlue,
                  ),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: () => _onShare(context),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Peer Row
                    GestureDetector(
                      onTap: () => _onPeerTap(context),
                      behavior: HitTestBehavior.opaque,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppAvatar(
                            imageUrl: deal.peerPhotoUrl,
                            name: deal.peerName,
                            size: 46,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Name + PRO badge
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        deal.peerName.toUpperCase(),
                                        style:
                                            AppTypography.titleMedium.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          letterSpacing: 0.3,
                                          color: AppColor.lightTextPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (deal.isPro) ...[
                                      const SizedBox(width: 5),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 1.5,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: AppColor.brandGradient,
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                  ],
                                ),

                                // 2. City
                                if (city.isNotEmpty) ...[
                                  const SizedBox(height: 1),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        size: 11,
                                        color: AppColor.lightTextTertiary,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        city,
                                        style:
                                            AppTypography.labelSmall.copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.lightTextTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],

                                // 3. Designation · Company
                                if (subLine.isNotEmpty) ...[
                                  const SizedBox(height: 1),
                                  Text(
                                    subLine,
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.lightTextSecondary,
                                    ),
                                  ),
                                ],

                                // 4. Category
                                if (category.isNotEmpty) ...[
                                  const SizedBox(height: 1),
                                  AppGradientText(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Deal Amount & Type Showcase Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF10B981).withValues(alpha: 0.08),
                            AppColor.primaryBlue.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'DEAL VALUE',
                                style: AppTypography.labelSmall.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF059669),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isNew
                                      ? const Color(0xFF10B981)
                                          .withValues(alpha: 0.15)
                                      : const Color(0xFF6366F1)
                                          .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  deal.businessTypeLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isNew
                                        ? const Color(0xFF059669)
                                        : const Color(0xFF4F46E5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatCurrency(deal.dealAmount),
                            style: AppTypography.titleLarge.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: AppColor.lightTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: AppColor.lightTextTertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Closed on: ${deal.dealDate}',
                                style: AppTypography.labelSmall.copyWith(
                                  fontSize: 11.5,
                                  color: AppColor.lightTextTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    if (comment.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Notes & Comments',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColor.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColor.lightSurfaceSubtle,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '“$comment”',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: AppColor.lightTextPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],

                    if (deal.mediaUrls.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Media / Creative Attachment',
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColor.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: deal.mediaUrls.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (ctx, idx) {
                            final url = deal.mediaUrls[idx];
                            return GestureDetector(
                              onTap: () => _openImagePreview(context, url),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: AppColor.lightBackground,
                                    border:
                                        Border.all(color: AppColor.lightBorder),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        url,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Center(
                                          child: Icon(
                                            Icons.broken_image_outlined,
                                            color: AppColor.lightTextTertiary,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 4,
                                        right: 4,
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.fullscreen_rounded,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Primary Share Button
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () => _onShare(context),
                icon: const Icon(Icons.share_outlined, size: 16),
                label: const Text(
                  'Share Business Deal',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: AppColor.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
