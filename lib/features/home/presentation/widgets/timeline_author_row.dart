import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../../../core/widgets/app_gradient_text.dart';
import '../../domain/entities/timeline_author_entity.dart';

String _formatTime(String raw) => AppDateFormatter.formatTimeAgo(raw);

class TimelineAuthorRow extends StatelessWidget {
  final TimelineAuthorEntity? author;
  final String createdAt;
  final VoidCallback? onMoreTap;
  final VoidCallback? onAuthorTap;

  const TimelineAuthorRow({
    super.key,
    required this.author,
    required this.createdAt,
    this.onMoreTap,
    this.onAuthorTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final name = author?.displayName ?? 'Peers Member';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';
    final photoUrl = author?.profilePhotoUrl;
    final isVerified = author?.isVerified ?? false;

    final designation = author?.designation;
    final companyName = author?.companyName;
    final category = author?.level4Category;

    final subLine = [
      if (designation != null && designation.isNotEmpty) designation,
      if (companyName != null && companyName.isNotEmpty) companyName,
    ].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Row 1: timestamp (left) + three-dots (right) ──
        Row(
          children: [
            Expanded(
              child: Text(
                _formatTime(createdAt),
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if (onMoreTap != null)
              GestureDetector(
                onTap: onMoreTap,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.more_horiz_rounded,
                    size: 18,
                    color: secondaryTextColor,
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 6),

        // ── Row 2: avatar + info column (tappable) ──
        GestureDetector(
          onTap: onAuthorTap,
          behavior: HitTestBehavior.opaque,
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColor.primaryBlue.withValues(alpha: 0.1),
              backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                  ? NetworkImage(photoUrl)
                  : null,
              child: (photoUrl == null || photoUrl.isEmpty)
                  ? Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColor.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),

            // Info column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name (UPPERCASE) + verified badge
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          name.toUpperCase(),
                          style: TextStyle(
                            color: primaryTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isVerified) ...[
                        const SizedBox(width: 4),
                        ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (bounds) =>
                              AppColor.brandGradient.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                          child: const Icon(
                            Icons.verified_rounded,
                            size: 12,
                          ),
                        ),
                        const SizedBox(width: 2),
                        AppGradientText(
                          'Verified',
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Designation · Company
                  if (subLine.isNotEmpty) ...[
                    const SizedBox(height: 1),
                    Text(
                      subLine,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Category (gradient text)
                  if (category != null && category.isNotEmpty) ...[
                    const SizedBox(height: 1),
                    AppGradientText(
                      category,
                      style: const TextStyle(
                        fontSize: 9.5,
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
          ), // end GestureDetector Row child
        ), // end GestureDetector
      ],
    );
  }
}
