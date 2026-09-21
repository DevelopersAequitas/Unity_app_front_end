import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/register_visitor_entity.dart';

class RegisterVisitorHistoryList extends StatelessWidget {
  final List<RegisterVisitorEntity> submissions;
  final bool isLoading;

  const RegisterVisitorHistoryList({
    super.key,
    required this.submissions,
    required this.isLoading,
  });

  String _formatDate(String raw) => AppDateFormatter.format(raw);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (submissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline_rounded, size: 48, color: secondaryColor),
            const SizedBox(height: 12),
            Text(
              'No Visitor Registrations Yet',
              style: AppTypography.titleMedium.copyWith(color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary),
            ),
            const SizedBox(height: 4),
            Text('Your registered visitors will appear here.', style: AppTypography.bodySmall.copyWith(color: secondaryColor)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: submissions.length,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = submissions[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.visitorFullName,
                      style: AppTypography.titleMedium.copyWith(color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.eventType.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(color: AppColor.primaryBlue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Event: ${item.eventName}', style: AppTypography.bodyMedium.copyWith(color: secondaryColor)),
              if (item.eventDate.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Date: ${AppDateFormatter.format(item.eventDate)}', style: AppTypography.bodySmall.copyWith(color: secondaryColor)),
              ],
              const SizedBox(height: 4),
              Text('Contact: ${item.visitorMobile}', style: AppTypography.bodySmall.copyWith(color: secondaryColor)),
              if (item.visitorCity.isNotEmpty || item.visitorBusiness.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('${item.visitorBusiness} ${item.visitorCity.isNotEmpty ? "• ${item.visitorCity}" : ""}'.trim(), style: AppTypography.bodySmall.copyWith(color: secondaryColor)),
              ],
              if (item.createdAt.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Submitted on ${_formatDate(item.createdAt)}', style: AppTypography.bodySmall.copyWith(color: secondaryColor, fontSize: 11)),
              ],
            ],
          ),
        );
      },
    );
  }
}
