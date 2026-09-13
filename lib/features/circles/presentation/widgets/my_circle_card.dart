import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/circle_entity.dart';
import 'circle_icon_helper.dart';

class MyCircleCard extends StatelessWidget {
  final CircleEntity circle;
  final VoidCallback onTap;

  const MyCircleCard({
    super.key,
    required this.circle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : Colors.white;
    final config = CircleIconHelper.getCategoryConfig(circle.category, circle.circleKey);
    final borderColor = isDark
        ? AppColor.darkBorder
        : config.tintColor.withValues(alpha: 0.25);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, config, isDark),
                const SizedBox(height: 12),
                _buildStatsRow(isDark),
                const SizedBox(height: 10),
                Divider(
                  height: 1,
                  thickness: 0.8,
                  color: isDark ? AppColor.darkBorder : const Color(0xFFF3F4F6),
                ),
                const SizedBox(height: 10),
                _buildBottomRow(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CircleIconConfig config, bool isDark) {
    final hasLogo = circle.logoUrl != null && circle.logoUrl!.trim().isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: config.bgTint,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColor.darkBorder : config.tintColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: hasLogo
                ? Image.network(
                    circle.logoUrl!,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(config.icon, size: 24, color: config.tintColor),
                    ),
                  )
                : Center(
                    child: Icon(config.icon, size: 24, color: config.tintColor),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      circle.name,
                      style: AppTypography.titleSmall.copyWith(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  _buildStatusBadge(circle.membershipStatus),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.more_vert_rounded,
                    size: 18,
                    color: isDark ? AppColor.darkTextSecondary : const Color(0xFF9CA3AF),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              if (circle.category != null && circle.category!.isNotEmpty)
                Text(
                  circle.category!,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11.5,
                    color: isDark ? AppColor.darkTextSecondary : const Color(0xFF6B7280),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (circle.formattedLocation.isNotEmpty) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 11.5,
                      color: AppColor.primaryBlue,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        circle.formattedLocation,
                        style: AppTypography.labelSmall.copyWith(
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final isPending = status.toLowerCase() == 'pending' || status.toLowerCase() == 'requested';
    final bg = isPending ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7);
    final text = isPending ? const Color(0xFFD97706) : const Color(0xFF16A34A);
    final label = isPending ? 'Pending' : 'Active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: text),
      ),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    final metaColor = isDark ? AppColor.darkTextSecondary : const Color(0xFF6B7280);
    final rankText = circle.rank != null && circle.rank!.isNotEmpty
        ? circle.rank!
        : (circle.stage != null && circle.stage!.isNotEmpty ? circle.stage! : 'Gold');

    return Row(
      children: [
        // Members
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColor.primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.people_outline_rounded, size: 13, color: AppColor.primaryBlue),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${circle.membersCount}',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                ),
                Text(
                  'Members',
                  style: TextStyle(fontSize: 9.5, color: metaColor),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),

        // Meetings
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.calendar_today_outlined, size: 13, color: Color(0xFF0284C7)),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  circle.meetingFrequency,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                ),
                Text(
                  'Meetings',
                  style: TextStyle(fontSize: 9.5, color: metaColor),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),

        // Rank
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.workspace_premium_outlined, size: 13, color: Color(0xFFD97706)),
            ),
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  rankText,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                ),
                Text(
                  'Rank',
                  style: TextStyle(fontSize: 9.5, color: metaColor),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomRow(bool isDark) {
    final nextMeetingText = circle.nextMeeting?.formattedDateTime ?? '25 Sep, 6:30 PM';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAvatarStack(isDark),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Next Meeting',
                      style: TextStyle(
                        fontSize: 9.5,
                        color: isDark ? AppColor.darkTextDisabled : const Color(0xFF9CA3AF),
                      ),
                    ),
                    Text(
                      nextMeetingText,
                      style: AppTypography.labelSmall.copyWith(
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
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: isDark ? AppColor.darkTextSecondary : const Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarStack(bool isDark) {
    final count = circle.membersCount > 4 ? circle.membersCount - 4 : 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < 4; i++)
          Align(
            widthFactor: 0.65,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColor.darkSurface : Colors.white,
                  width: 2,
                ),
                color: const Color(0xFFDBEAFE),
              ),
              child: const Icon(Icons.person_rounded, size: 14, color: AppColor.primaryBlue),
            ),
          ),
        if (count > 0)
          Align(
            widthFactor: 0.65,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColor.darkSurface : Colors.white,
                  width: 1.5,
                ),
              ),
              child: Text(
                '+$count',
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                  color: AppColor.primaryBlue,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
