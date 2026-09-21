import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../domain/entities/chat_conversation_entity.dart';

class ChatHubConversationTile extends StatelessWidget {
  final ChatConversationEntity conversation;
  final VoidCallback onTap;

  const ChatHubConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) {
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$h:$m $ampm';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dt.weekday - 1];
    }
    return '${dt.day}/${dt.month}/${dt.year.toString().substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final otherUser = conversation.otherUser;
    final displayName = otherUser?.displayName ?? 'Peer Member';
    final photoUrl = otherUser?.profilePhotoUrl;
    final lastMsg = conversation.lastMessage;
    final unread = conversation.unreadCount;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            AppAvatar(
              imageUrl: photoUrl,
              name: displayName,
              size: 46,
              showOnlineBadge: true,
              isOnline: otherUser?.isOnline ?? false,
              isPro: otherUser?.isPro ?? false,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                displayName,
                                style: AppTypography.bodyLarge.copyWith(
                                  fontWeight: unread > 0
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  color: isDark
                                      ? AppColor.darkTextPrimary
                                      : AppColor.lightTextPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (otherUser?.isVerified == true) ...[
                              const SizedBox(width: 3),
                              const Icon(
                                Icons.verified_rounded,
                                size: 13,
                                color: AppColor.primaryBlue,
                              ),
                            ],
                            if (otherUser?.isPro == true) ...[
                              const SizedBox(width: 3),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColor.brandGradient,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: const Text(
                                  'PRO',
                                  style: TextStyle(
                                    fontSize: 7.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        _formatTime(
                            lastMsg?.createdAt ?? conversation.lastMessageAt),
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: unread > 0
                              ? AppColor.primaryBlue
                              : (isDark
                                  ? AppColor.darkTextSecondary
                                  : AppColor.lightTextSecondary),
                          fontWeight:
                              unread > 0 ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMsg?.content.isNotEmpty == true
                              ? lastMsg!.content
                              : 'Tap to open chat',
                          style: AppTypography.bodySmall.copyWith(
                            color: unread > 0
                                ? (isDark
                                    ? AppColor.darkTextPrimary
                                    : AppColor.lightTextPrimary)
                                : (isDark
                                    ? AppColor.darkTextSecondary
                                    : AppColor.lightTextSecondary),
                            fontWeight:
                                unread > 0 ? FontWeight.w500 : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unread > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColor.primaryBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unread > 99 ? '99+' : '$unread',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
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
    );
  }
}
