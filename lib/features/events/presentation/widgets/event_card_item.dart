import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/event_entity.dart';

class EventCardItem extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onTap;

  const EventCardItem({
    super.key,
    required this.event,
    required this.onTap,
  });

  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColor.primaryBlue : AppColor.primaryBlue;
    final dt = event.startAt;

    final dayStr = dt != null ? dt.day.toString().padLeft(2, '0') : '—';
    final monthStr = dt != null ? _months[dt.month - 1] : 'EVENT';

    final timeStr = (event.displayTime != null && event.displayTime!.isNotEmpty)
        ? event.displayTime!
        : (dt != null ? AppDateFormatter.formatDateTime(dt) : '');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Calendar Badge
              SizedBox(
                width: 36,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dayStr,
                      style: AppTypography.titleMedium.copyWith(
                        color: primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      monthStr,
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Thumbnail Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 54,
                  height: 54,
                  color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
                  child: event.imageUrl != null && event.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: event.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) => const Icon(Icons.event_outlined, size: 22),
                        )
                      : const Icon(Icons.event_outlined, size: 22),
                ),
              ),
              const SizedBox(width: 10),

              // Event Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium.copyWith(
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                    if (timeStr.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 11, color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              timeStr,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (event.location != null && event.location!.trim().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 11, color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location!.trim(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    // Chips Row
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children: [
                        if (event.userRegistration?.isRegistered == true ||
                            event.userRegistration?.status == 'registered' ||
                            event.userRegistration?.status == 'confirmed')
                          _buildChip(
                            'REGISTERED',
                            const Color(0xFF059669),
                          )
                        else if (event.userRegistration?.status == 'requested' ||
                            event.userRegistration?.status == 'pending' ||
                            event.userRegistration?.status == 'pending_approval')
                          _buildChip(
                            'PENDING APPROVAL',
                            const Color(0xFFD97706),
                          ),
                        if (event.eventCategory.trim().isNotEmpty)
                          _buildChip(
                            event.eventCategory.replaceAll('_', ' ').toUpperCase(),
                            primary,
                          ),
                        if (event.mode.trim().isNotEmpty)
                          _buildChip(
                            event.isInPerson ? 'IN-PERSON' : 'ONLINE',
                            AppColor.success,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
