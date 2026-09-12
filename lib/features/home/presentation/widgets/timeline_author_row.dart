import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/timeline_author_entity.dart';

String _formatTime(String raw) {
  try {
    final dt = DateTime.parse(raw).toLocal();
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  } catch (_) {
    return raw;
  }
}

class TimelineAuthorRow extends StatelessWidget {
  final TimelineAuthorEntity? author;
  final String createdAt;
  final VoidCallback? onMoreTap;

  const TimelineAuthorRow({
    super.key,
    required this.author,
    required this.createdAt,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final name = author?.displayName ?? 'Peers Member';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';
    final photoUrl = author?.profilePhotoUrl;
    final isVerified = author?.isVerified ?? false;

    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColor.primaryBlue.withValues(alpha: 0.1),
          backgroundImage: photoUrl != null && photoUrl.isNotEmpty
              ? NetworkImage(photoUrl)
              : null,
          child: (photoUrl == null || photoUrl.isEmpty)
              ? Text(
                  initial,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColor.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      name,
                      style: AppTypography.titleMedium.copyWith(
                        color: primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: AppColor.primaryBlue,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                _formatTime(createdAt),
                style: AppTypography.bodySmall.copyWith(
                  color: secondaryTextColor,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        if (onMoreTap != null)
          IconButton(
            icon: Icon(
              Icons.more_horiz_rounded,
              size: 20,
              color: secondaryTextColor,
            ),
            onPressed: onMoreTap,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
      ],
    );
  }
}
