import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../domain/entities/testimonial_entity.dart';
import 'testimonial_share_helper.dart';

class TestimonialDetailSheet extends StatelessWidget {
  final TestimonialEntity testimonial;
  final String? currentUserName;
  final String tabType;
  final String dateStr;

  const TestimonialDetailSheet({
    super.key,
    required this.testimonial,
    this.currentUserName,
    this.tabType = 'received',
    required this.dateStr,
  });

  static Future<void> show(
    BuildContext context, {
    required TestimonialEntity testimonial,
    String? currentUserName,
    String tabType = 'received',
    required String dateStr,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColor.transparent,
      builder: (_) => TestimonialDetailSheet(
        testimonial: testimonial,
        currentUserName: currentUserName,
        tabType: tabType,
        dateStr: dateStr,
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

  void _onPeerTap(BuildContext context) {
    Navigator.pop(context);
    final peerId = testimonial.fromUserId ?? testimonial.toUserId;
    if (peerId != null && peerId.isNotEmpty) {
      Navigator.pushNamed(context, AppRoutes.peerProfile, arguments: peerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final designation = testimonial.peerDesignation?.trim() ?? '';
    final company = testimonial.peerCompany?.trim() ?? '';
    final city = (testimonial.city ?? testimonial.peerLocation)?.trim() ?? '';
    final category = testimonial.category?.trim() ?? '';
    final hasMedia =
        testimonial.media.isNotEmpty && testimonial.media.first.url != null;
    // final rating = testimonial.rating?.round() ?? 5;
    final content = testimonial.content.trim();

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
                style: TextStyle(
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
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
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
                          imageUrl: testimonial.peerPhotoUrl,
                          name: testimonial.peerName,
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
                                      testimonial.peerName.toUpperCase(),
                                      style: AppTypography.titleMedium.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        letterSpacing: 0.3,
                                        color: AppColor.lightTextPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (testimonial.isPro) ...[
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

                              // 2. City directly below peer name
                              if (city.isNotEmpty) ...[
                                const SizedBox(height: 1),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 11,
                                      color: AppColor.lightTextTertiary,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      city,
                                      style: AppTypography.labelSmall.copyWith(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.lightTextTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              // Designation · Company
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

                              // Category
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

                              // Stars (Disabled: no backend rating support currently)
                              // const SizedBox(height: 4),
                              // Row(
                              //   children: List.generate(5, (index) {
                              //     final isFilled = index < rating;
                              //     return Padding(
                              //       padding: const EdgeInsets.only(right: 2),
                              //       child: Icon(
                              //         isFilled
                              //             ? Icons.star_rounded
                              //             : Icons.star_outline_rounded,
                              //         size: 14,
                              //         color: isFilled
                              //             ? const Color(0xFFF59E0B)
                              //             : AppColor.lightBorder,
                              //       ),
                              //     );
                              //   }),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Full Testimonial Message
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColor.lightSurfaceSubtle,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '“$content”',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: AppColor.lightTextPrimary,
                        height: 1.5,
                      ),
                    ),
                  ),

                  // Media Image Preview if attached
                  if (hasMedia) ...[
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: testimonial.media.first.url!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          height: 200,
                          color: AppColor.lightSurfaceSubtle,
                        ),
                        errorWidget: (_, _, _) => const SizedBox.shrink(),
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
                'Share Testimonial',
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
