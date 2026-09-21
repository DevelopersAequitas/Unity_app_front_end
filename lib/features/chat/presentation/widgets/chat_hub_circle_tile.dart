import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../circles/domain/entities/circle_entity.dart';

class ChatHubCircleTile extends StatelessWidget {
  final CircleEntity circle;
  final VoidCallback onOpenChat;
  final VoidCallback? onOpenLeadershipChat;

  const ChatHubCircleTile({
    super.key,
    required this.circle,
    required this.onOpenChat,
    this.onOpenLeadershipChat,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onOpenChat,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColor.primaryBlue.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.primaryBlue.withValues(alpha: 0.25),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.groups_rounded,
                  color: AppColor.primaryBlue,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    circle.name,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColor.darkTextPrimary
                          : AppColor.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${circle.membersCount} members • Tap to open circle chat',
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
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColor.lightTextSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
