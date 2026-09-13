import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_entity.dart';
import '../circle_icon_helper.dart';

class CircleDetailMeetingCards extends StatelessWidget {
  final CircleEntity circle;

  const CircleDetailMeetingCards({super.key, required this.circle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = CircleIconHelper.getCategoryConfig(circle.category, circle.circleKey);
    final cardBg = isDark ? AppColor.darkSurface : Colors.white;
    final borderColor = isDark
        ? AppColor.darkBorder
        : config.tintColor.withValues(alpha: 0.18);

    final meeting = circle.nextMeeting;
    final nextDate = meeting?.formattedDateTime ?? 'Scheduled Monthly';
    final location = meeting?.location ?? circle.city ?? 'Ahmedabad';
    final mode = meeting?.mode ?? circle.meetingMode;
    final freq = circle.meetingFrequency;
    final isOffline = mode.toLowerCase() == 'offline';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: AppColor.brandGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(Icons.event_available_rounded, size: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Meetings & Events',
                      style: AppTypography.titleSmall.copyWith(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: isOffline
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isOffline ? Icons.location_on_outlined : Icons.videocam_outlined,
                        size: 11,
                        color: isOffline ? const Color(0xFF059669) : AppColor.primaryBlue,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        mode,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isOffline ? const Color(0xFF059669) : AppColor.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Next Meeting Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    config.bgTint,
                    isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF9FAFB),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColor.darkBorder : config.tintColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: config.tintColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(Icons.calendar_month_rounded, size: 20, color: config.tintColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upcoming Meeting',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: config.tintColor,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          nextDate,
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.pin_drop_outlined,
                              size: 11,
                              color: isDark ? AppColor.darkTextSecondary : const Color(0xFF6B7280),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                location,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: isDark ? AppColor.darkTextSecondary : const Color(0xFF6B7280),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Frequency and schedule details
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? AppColor.darkBorder : const Color(0xFFF3F4F6),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.update_rounded, size: 14, color: AppColor.primaryPink),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cadence',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  color: isDark ? AppColor.darkTextDisabled : const Color(0xFF9CA3AF),
                                ),
                              ),
                              Text(
                                freq,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? AppColor.darkBorder : const Color(0xFFF3F4F6),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_outlined, size: 14, color: Color(0xFFD97706)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stage',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  color: isDark ? AppColor.darkTextDisabled : const Color(0xFF9CA3AF),
                                ),
                              ),
                              Text(
                                circle.stage ?? 'Active Circle',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

