import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/testimonial_entity.dart';

class TestimonialItemCard extends StatelessWidget {
  final TestimonialEntity testimonial;

  const TestimonialItemCard({
    super.key,
    required this.testimonial,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = AppDateFormatter.format(testimonial.createdAt, defaultValue: '');
    final hasMedia = testimonial.media.isNotEmpty && testimonial.media.first.url != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceSubtle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                imageUrl: testimonial.peerPhotoUrl,
                name: testimonial.peerName,
                size: 32,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.peerName,
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: AppColor.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (dateStr.isNotEmpty)
                      Text(
                        dateStr,
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: AppColor.lightTextTertiary,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.format_quote_outlined,
                size: 18,
                color: AppColor.lightTextTertiary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            testimonial.content,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: AppColor.lightTextSecondary,
              height: 1.4,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          if (hasMedia) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: testimonial.media.first.url!,
                height: 90,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 90,
                  color: AppColor.lightBorder,
                ),
                errorWidget: (context, url, error) => const SizedBox.shrink(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
