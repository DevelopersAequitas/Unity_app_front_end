import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_type_helper.dart';

class NotificationItemCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationItemCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUnread = !notification.isRead;
    final cardBg = isDark
        ? (isUnread ? AppColor.darkSurfaceSubtle : AppColor.darkSurface)
        : (isUnread ? const Color(0xFFF9FAFF) : AppColor.lightSurface);
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final titleColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final bodyColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextMuted;
    final badgeConfig = NotificationTypeHelper.getBadgeConfig(
      notification.type,
      notification.category,
    );

    return Semantics(
      label:
          '${notification.title}. ${notification.body}. ${NotificationTypeHelper.formatTimeAgo(notification.createdAt)}',
      button: true,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isUnread
                ? AppColor.primaryBlue.withValues(alpha: 0.2)
                : borderColor,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isUnread) ...[
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        color: AppColor.primaryPink,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                  _NotificationAvatar(
                    avatarUrl: notification.avatarUrl,
                    actorName: notification.actorName,
                    badgeConfig: badgeConfig,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          notification.title.isNotEmpty
                              ? notification.title
                              : 'Notification',
                          style: AppTypography.titleSmall.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: titleColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          notification.body.isNotEmpty
                              ? notification.body
                              : notification.message,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 12,
                            color: bodyColor,
                            height: 1.35,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        NotificationTypeHelper.formatTimeAgo(
                          notification.createdAt ?? notification.sentAt,
                        ),
                        style: AppTypography.labelSmall.copyWith(
                          fontSize: 10.5,
                          color: isDark
                              ? AppColor.darkTextSecondary
                              : AppColor.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: isDark
                            ? AppColor.darkTextSecondary
                            : AppColor.lightTextSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String? actorName;
  final NotificationBadgeConfig badgeConfig;

  const _NotificationAvatar({
    this.avatarUrl,
    this.actorName,
    required this.badgeConfig,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: badgeConfig.backgroundColor.withValues(alpha: 0.12),
            ),
            child: ClipOval(
              child: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: avatarUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => _fallbackContent(),
                    )
                  : _fallbackContent(),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: badgeConfig.backgroundColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Center(
                child: Icon(
                  badgeConfig.icon,
                  size: 10,
                  color: badgeConfig.iconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackContent() {
    final name = actorName?.trim();
    if (name != null && name.isNotEmpty) {
      return Center(
        child: Text(
          name[0].toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColor.primaryBlue,
          ),
        ),
      );
    }
    return Icon(
      badgeConfig.fallbackIcon,
      size: 22,
      color: badgeConfig.backgroundColor,
    );
  }
}
