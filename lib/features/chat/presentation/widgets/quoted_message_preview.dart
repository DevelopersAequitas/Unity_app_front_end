import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/chat_message_entity.dart';

class QuotedMessagePreview extends StatelessWidget {
  final ChatMessageEntity quotedMessage;
  final VoidCallback onClose;

  const QuotedMessagePreview({
    super.key,
    required this.quotedMessage,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final senderName = quotedMessage.sender?.displayName ??
        (quotedMessage.isMine ? 'You' : 'Peer');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
          left: const BorderSide(
            color: AppColor.primaryBlue,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Replying to $senderName',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColor.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  quotedMessage.content.isNotEmpty
                      ? quotedMessage.content
                      : (quotedMessage.attachments.isNotEmpty
                          ? '📎 Attachment'
                          : 'Message'),
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColor.darkTextSecondary
                        : AppColor.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            color: isDark
                ? AppColor.darkTextSecondary
                : AppColor.lightTextSecondary,
            onPressed: onClose,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}
