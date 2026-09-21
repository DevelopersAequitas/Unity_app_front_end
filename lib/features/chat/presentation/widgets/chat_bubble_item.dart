import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/chat_message_entity.dart';
import 'chat_attachment_viewer.dart';
import 'chat_audio_player.dart';
import 'quoted_message_bubble.dart';

class ChatBubbleItem extends StatelessWidget {
  final ChatMessageEntity message;
  final VoidCallback? onLongPress;
  final bool showSenderName;
  final bool isLeadership;

  const ChatBubbleItem({
    super.key,
    required this.message,
    this.onLongPress,
    this.showSenderName = false,
    this.isLeadership = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bubbleBg = isMine
        ? (isDark ? const Color(0xFF1E3A8A) : const Color(0xFFE0E7FF))
        : (isDark ? AppColor.darkSurfaceSubtle : Colors.white);

    final textColor = isMine
        ? (isDark ? Colors.white : const Color(0xFF1E293B))
        : (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary);

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          decoration: BoxDecoration(
            color: bubbleBg,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft: Radius.circular(isMine ? 14 : 2),
              bottomRight: Radius.circular(isMine ? 2 : 14),
            ),
            border: Border.all(
              color: isMine
                  ? Colors.transparent
                  : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isMine && showSenderName && message.sender != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    message.sender!.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isLeadership
                          ? AppColor.warning
                          : AppColor.primaryBlue,
                    ),
                  ),
                ),
              if (message.replyToMessage != null)
                QuotedMessageBubble(
                  replyMessage: message.replyToMessage!,
                  isMine: isMine,
                ),
              if (message.attachments.isNotEmpty)
                ...message.attachments.map((att) {
                  if (att.isImage) {
                    return GestureDetector(
                      onTap: () => ChatAttachmentViewer.show(
                        context,
                        attachment: att,
                        title: message.sender?.displayName ?? 'Image View',
                      ),
                       child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        constraints: const BoxConstraints(maxHeight: 220),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: att.url.startsWith('http')
                              ? CachedNetworkImage(
                                  imageUrl: att.url,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    height: 140,
                                    color: Colors.black12,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColor.primaryBlue,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.broken_image_rounded,
                                    size: 40,
                                  ),
                                )
                              : Image.file(
                                  File(att.url),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                    Icons.broken_image_rounded,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                    );
                  }
                  if (att.isAudio) {
                    return ChatAudioPlayer(
                      audioUrl: att.url,
                      isMine: isMine,
                    );
                  }
                  if (att.isVideo) {
                    return GestureDetector(
                      onTap: () => ChatAttachmentViewer.show(
                        context,
                        attachment: att,
                        title: message.sender?.displayName ?? 'Video View',
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 44,
                          ),
                        ),
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () => ChatAttachmentViewer.show(
                      context,
                      attachment: att,
                      title: message.sender?.displayName ?? 'Attachment',
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isMine
                            ? Colors.black.withValues(alpha: 0.08)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.insert_drive_file_rounded,
                              size: 18, color: AppColor.primaryBlue),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              att.fileName ?? 'Attachment File',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.download_rounded, size: 16),
                        ],
                      ),
                    ),
                  );
                }),
              // Show text content only when it's a real caption — not the
              // auto-generated placeholder ("Photo", "Video", "Voice note", etc.)
              // that is set when sending media with no caption.
              if (message.content.isNotEmpty && _shouldShowCaption(message))
                Padding(
                  padding: message.attachments.isNotEmpty
                      ? const EdgeInsets.only(top: 2)
                      : EdgeInsets.zero,
                  child: Text(
                    message.content,
                    style: AppTypography.bodyLarge.copyWith(
                      color: textColor,
                      height: 1.35,
                    ),
                  ),
                ),
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppDateFormatter.formatChatTime(message.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: isMine
                          ? (isDark
                              ? Colors.white.withValues(alpha: 0.7)
                              : AppColor.lightTextSecondary)
                          : (isDark
                              ? AppColor.darkTextSecondary
                              : AppColor.lightTextSecondary),
                    ),
                  ),
                  if (isMine) ...[
                    const SizedBox(width: 4),
                    Icon(
                      (message.isRead || message.readCount > 0)
                          ? Icons.done_all_rounded
                          : Icons.done_rounded,
                      size: 14,
                      color: (message.isRead || message.readCount > 0)
                          ? (isDark
                              ? const Color(0xFF38BDF8)
                              : const Color(0xFF0284C7))
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.6)
                              : AppColor.lightTextTertiary),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns false when the content is just an auto-generated placeholder
  /// label sent alongside a media attachment ("Photo", "Video", "Voice note",
  /// "Attachment"). Returns true for real user-typed captions.
  static const _mediaCaptions = {
    'photo',
    'video',
    'voice note',
    'attachment',
  };

  bool _shouldShowCaption(ChatMessageEntity msg) {
    if (msg.attachments.isEmpty) return true;
    final hasMedia = msg.attachments.any(
      (a) => a.isImage || a.isVideo || a.isAudio,
    );
    if (!hasMedia) return true;
    // Hide if the content is exactly one of the auto-generated labels
    return !_mediaCaptions.contains(msg.content.trim().toLowerCase());
  }
}
