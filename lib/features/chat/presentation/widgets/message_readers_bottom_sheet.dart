import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/message_reader_entity.dart';

class MessageReadersBottomSheet extends StatelessWidget {
  final List<MessageReaderEntity> readers;
  final bool isLoading;

  const MessageReadersBottomSheet({
    super.key,
    required this.readers,
    this.isLoading = false,
  });

  String _formatTime(DateTime? dt) => AppDateFormatter.formatChatTime(dt);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'Read Receipts (${readers.length})',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColor.darkTextPrimary
                      : AppColor.lightTextPrimary,
                ),
              ),
            ),
            const Divider(height: 16),
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (readers.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                    'No read receipts yet.',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColor.darkTextSecondary
                          : AppColor.lightTextSecondary,
                    ),
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: readers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final r = readers[index];
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              AppColor.primaryBlue.withValues(alpha: 0.15),
                          backgroundImage: (r.profilePhotoUrl != null &&
                                  r.profilePhotoUrl!.isNotEmpty)
                              ? NetworkImage(r.profilePhotoUrl!)
                              : null,
                          child: (r.profilePhotoUrl == null ||
                                  r.profilePhotoUrl!.isEmpty)
                              ? Text(
                                  r.initials,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.primaryBlue,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.name,
                                style: AppTypography.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColor.darkTextPrimary
                                      : AppColor.lightTextPrimary,
                                ),
                              ),
                              if (r.companyName != null &&
                                  r.companyName!.isNotEmpty)
                                Text(
                                  r.companyName!,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isDark
                                        ? AppColor.darkTextSecondary
                                        : AppColor.lightTextSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (r.readAt != null)
                          Text(
                            _formatTime(r.readAt),
                            style: AppTypography.labelSmall.copyWith(
                              color: isDark
                                  ? AppColor.darkTextSecondary
                                  : AppColor.lightTextSecondary,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
