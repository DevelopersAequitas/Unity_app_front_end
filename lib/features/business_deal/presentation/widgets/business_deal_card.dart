import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/business_deal_entity.dart';
import 'business_deal_detail_sheet.dart';
import 'business_deal_options_sheet.dart';

String _formatDateTime(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  try {
    final dt = DateTime.parse(raw).toLocal();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} · $hour:$minute $ampm';
  } catch (_) {
    return raw;
  }
}

class BusinessDealCard extends StatelessWidget {
  final BusinessDealEntity deal;
  final String tabType;

  const BusinessDealCard({
    super.key,
    required this.deal,
    this.tabType = 'received',
  });

  void _onPeerTap(BuildContext context) {
    final peerId = deal.fromUserId ?? deal.toUserId;
    if (peerId != null && peerId.isNotEmpty) {
      Navigator.pushNamed(
        context,
        AppRoutes.peerProfile,
        arguments: peerId,
      );
    }
  }

  void _showOptions(BuildContext context) {
    String? currentUserName;
    try {
      currentUserName = context.read<ProfileBloc>().state.profile?.displayName;
    } catch (_) {}

    BusinessDealOptionsSheet.show(
      context,
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
              child: InteractiveViewer(
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

  void _openDetailSheet(BuildContext context, String dateStr) {
    String? currentUserName;
    try {
      currentUserName = context.read<ProfileBloc>().state.profile?.displayName;
    } catch (_) {}

    BusinessDealDetailSheet.show(
      context,
      deal: deal,
      currentUserName: currentUserName,
      tabType: tabType,
      dateStr: dateStr,
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    }
    final formatted = amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d+?)(?=(\d\d)+(\d)(?!\d))'),
          (m) => '${m[1]},',
        );
    return '₹$formatted';
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDateTime(deal.createdAt);
    final designation = deal.peerDesignation?.trim() ?? '';
    final company = deal.peerCompany?.trim() ?? '';
    final city = (deal.city ?? deal.peerLocation)?.trim() ?? '';
    final category = deal.category?.trim() ?? '';
    final comment = (deal.comment ?? '').trim();
    final isLongText = comment.length > 80;
    final isNew = deal.isNewBusiness;
    final hasMedia = deal.mediaUrls.isNotEmpty;

    final subLine = [
      if (designation.isNotEmpty) designation,
      if (company.isNotEmpty) company,
    ].join(' · ');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.lightBorder, width: 0.9),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row 1: Timestamp + Three Dots Menu ──
          Row(
            children: [
              Expanded(
                child: Text(
                  dateStr,
                  style: const TextStyle(
                    color: AppColor.lightTextTertiary,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showOptions(context),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, bottom: 2),
                  child: Icon(
                    Icons.more_horiz_rounded,
                    size: 18,
                    color: AppColor.lightTextTertiary.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          // ── Row 2: Avatar + Peer Info ──
          GestureDetector(
            onTap: () => _onPeerTap(context),
            behavior: HitTestBehavior.opaque,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAvatar(
                  imageUrl: deal.peerPhotoUrl,
                  name: deal.peerName,
                  size: 42,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Name in UPPERCASE + PRO badge
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              deal.peerName.toUpperCase(),
                              style: AppTypography.titleMedium.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
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
                        ],
                      ),

                      // 2. City
                      if (city.isNotEmpty) ...[
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 10.5,
                              color: AppColor.lightTextTertiary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              city,
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 10.5,
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
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColor.lightTextSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      // 4. Category
                      if (category.isNotEmpty) ...[
                        const SizedBox(height: 1),
                        AppGradientText(
                          category,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── Row 3: Deal Amount & Type Banner ──
          GestureDetector(
            onTap: () => _openDetailSheet(context, dateStr),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.currency_rupee_rounded,
                        size: 16,
                        color: Color(0xFF059669),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _formatAmount(deal.dealAmount),
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF059669),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isNew
                              ? const Color(0xFF10B981).withValues(alpha: 0.15)
                              : const Color(0xFF6366F1).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          deal.businessTypeLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isNew
                                ? const Color(0xFF059669)
                                : const Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                      if (deal.dealDate.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          deal.dealDate,
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 10,
                            color: AppColor.lightTextTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Row 4: Deal Comment / Notes & Media if present ──
          if (comment.isNotEmpty || hasMedia) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (comment.isNotEmpty)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _openDetailSheet(context, dateStr),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '“$comment”',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColor.lightTextPrimary
                                  .withValues(alpha: 0.88),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (isLongText) ...[
                            const SizedBox(height: 2),
                            Text(
                              'Read more',
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColor.primaryBlue,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                if (hasMedia && comment.isNotEmpty) const SizedBox(width: 10),
                if (hasMedia)
                  GestureDetector(
                    onTap: () =>
                        _openImagePreview(context, deal.mediaUrls.first),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: AppColor.lightBackground,
                          border: Border.all(
                              color: AppColor.lightBorder, width: 0.8),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              deal.mediaUrls.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 20,
                                  color: AppColor.lightTextTertiary,
                                ),
                              ),
                            ),
                            if (deal.mediaUrls.length > 1)
                              Positioned(
                                bottom: 3,
                                right: 3,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '+${deal.mediaUrls.length - 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
