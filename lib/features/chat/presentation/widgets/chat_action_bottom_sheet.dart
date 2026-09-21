import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatActionBottomSheet extends StatelessWidget {
  final ChatMessageEntity message;
  final VoidCallback onReply;
  final VoidCallback? onViewReads;
  final VoidCallback onDeleteForMe;
  final VoidCallback? onDeleteForEveryone;

  const ChatActionBottomSheet({
    super.key,
    required this.message,
    required this.onReply,
    this.onViewReads,
    required this.onDeleteForMe,
    this.onDeleteForEveryone,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            _ActionTile(
              icon: Icons.reply_rounded,
              title: 'Reply',
              onTap: () {
                Navigator.pop(context);
                onReply();
              },
            ),
            if (message.content.isNotEmpty)
              _ActionTile(
                icon: Icons.copy_rounded,
                title: 'Copy Text',
                onTap: () {
                  Clipboard.setData(ClipboardData(text: message.content));
                  Navigator.pop(context);
                  AppSnackBar.showSuccess(context, 'Copied to clipboard');
                },
              ),
            if (onViewReads != null)
              _ActionTile(
                icon: Icons.done_all_rounded,
                title: 'Read by (${message.readCount})',
                onTap: () {
                  Navigator.pop(context);
                  onViewReads!();
                },
              ),
            _ActionTile(
              icon: Icons.delete_outline_rounded,
              title: 'Delete for me',
              onTap: () {
                Navigator.pop(context);
                onDeleteForMe();
              },
            ),
            if (message.isMine && onDeleteForEveryone != null)
              _ActionTile(
                icon: Icons.delete_forever_rounded,
                title: 'Delete for everyone',
                textColor: AppColor.primaryPink,
                iconColor: AppColor.primaryPink,
                onTap: () {
                  Navigator.pop(context);
                  onDeleteForEveryone!();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: Icon(
        icon,
        size: 20,
        color: iconColor ??
            (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary),
      ),
      title: Text(
        title,
        style: AppTypography.bodyLarge.copyWith(
          color: textColor ??
              (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary),
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }
}
