import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class GalleryAlbumCard extends StatelessWidget {
  final String title;
  final String count;
  final String coverUrl;
  final VoidCallback onTap;

  const GalleryAlbumCard({
    super.key,
    required this.title,
    required this.count,
    required this.coverUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColor.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: AppColor.lightSurfaceSubtle,
                child: coverUrl.isNotEmpty
                    ? Image.network(
                        coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_outlined, color: AppColor.lightTextDisabled),
                      )
                    : const Icon(Icons.image_outlined, color: AppColor.lightTextDisabled),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColor.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$count Photos',
                    style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
