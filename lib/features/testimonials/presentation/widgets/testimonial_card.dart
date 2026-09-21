import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../domain/entities/testimonial_entity.dart';
import 'testimonial_detail_sheet.dart';
import 'testimonial_options_sheet.dart';

String _formatDateTime(String? raw) => AppDateFormatter.formatDateTime(raw);

class TestimonialCard extends StatelessWidget {
  final TestimonialEntity testimonial;
  final String tabType;

  const TestimonialCard({
    super.key,
    required this.testimonial,
    this.tabType = 'received',
  });

  void _onPeerTap(BuildContext context) {
    final peerId =
        testimonial.fromUserId ?? testimonial.toUserId;
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

    TestimonialOptionsSheet.show(
      context,
      testimonial: testimonial,
      currentUserName: currentUserName,
      tabType: tabType,
    );
  }

  void _openDetailSheet(BuildContext context, String dateStr) {
    String? currentUserName;
    try {
      currentUserName = context.read<ProfileBloc>().state.profile?.displayName;
    } catch (_) {}

    TestimonialDetailSheet.show(
      context,
      testimonial: testimonial,
      currentUserName: currentUserName,
      tabType: tabType,
      dateStr: dateStr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = _formatDateTime(testimonial.createdAt);
    final designation = testimonial.peerDesignation?.trim() ?? '';
    final company = testimonial.peerCompany?.trim() ?? '';
    final city = (testimonial.city ?? testimonial.peerLocation)?.trim() ?? '';
    final category = testimonial.category?.trim() ?? '';
    final hasMedia =
        testimonial.media.isNotEmpty && testimonial.media.first.url != null;
    // final rating = testimonial.rating?.round() ?? 5;
    final content = testimonial.content.trim();
    final isLongText = content.length > 80;

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
                  style: TextStyle(
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
                  imageUrl: testimonial.peerPhotoUrl,
                  name: testimonial.peerName,
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
                              testimonial.peerName.toUpperCase(),
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

                      // 5. Stars (Disabled: no backend rating support currently)
                      // const SizedBox(height: 3),
                      // Row(
                      //   children: List.generate(5, (index) {
                      //     final isFilled = index < rating;
                      //     return Padding(
                      //       padding: const EdgeInsets.only(right: 2),
                      //       child: Icon(
                      //         isFilled
                      //             ? Icons.star_rounded
                      //             : Icons.star_outline_rounded,
                      //         size: 13,
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
          const SizedBox(height: 6),

          // ── Row 3: Testimonial Quote + Media Thumbnail ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '“$content”',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: AppColor.lightTextPrimary.withValues(alpha: 0.88),
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isLongText) ...[
                      const SizedBox(height: 3),
                      GestureDetector(
                        onTap: () => _openDetailSheet(context, dateStr),
                        child: Text(
                          'Read more',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasMedia) ...[
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _openDetailSheet(context, dateStr),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColor.lightBorder,
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: testimonial.media.first.url!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          width: 56,
                          height: 56,
                          color: AppColor.lightSurfaceSubtle,
                        ),
                        errorWidget: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
