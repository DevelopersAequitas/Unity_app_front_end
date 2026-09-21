import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/chat_message_entity.dart';

class QuotedMessageBubble extends StatelessWidget {
  final ChatMessageEntity replyMessage;
  final bool isMine;

  const QuotedMessageBubble({
    super.key,
    required this.replyMessage,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final senderTitle =
        replyMessage.sender?.displayName ?? (replyMessage.isMine ? 'You' : 'Peer');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMine
            ? Colors.black.withValues(alpha: 0.08)
            : (isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: isMine ? AppColor.primaryBlue : AppColor.primaryPink,
            width: 3.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            senderTitle,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isMine ? AppColor.primaryBlue : AppColor.primaryPink,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            replyMessage.content.isNotEmpty
                ? replyMessage.content
                : (replyMessage.attachments.isNotEmpty ? '📎 Attachment' : 'Message'),
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11,
              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
