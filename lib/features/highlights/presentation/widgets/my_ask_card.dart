import 'package:flutter/material.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/post_ask_entity.dart';

class MyAskCard extends StatelessWidget {
  final PostAskEntity ask;
  final VoidCallback? onComplete;

  const MyAskCard({super.key, required this.ask, this.onComplete});

  String _formatDate(DateTime? date) => AppDateFormatter.format(date);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOpen = ask.isOpen;
    final formattedDate = _formatDate(ask.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _badge(ask.category, AppColor.primaryBlue, AppColor.primaryBlue.withValues(alpha: 0.1)),
              const Spacer(),
              _badge(
                isOpen ? 'OPEN' : 'COMPLETED',
                isOpen ? AppColor.warning : AppColor.success,
                (isOpen ? AppColor.warning : AppColor.success).withValues(alpha: 0.12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            ask.subject,
            style: AppTypography.titleSmall.copyWith(
              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (ask.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              ask.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
          if (ask.mediaUrl != null && ask.mediaUrl!.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ask.mediaUrl!.startsWith('http')
                    ? ask.mediaUrl!
                    : '${ApiEndpoints.baseUrl}/files/${ask.mediaUrl}',
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ],
          const SizedBox(height: 10),
          _buildMetaRow(isDark, formattedDate),
          if (isOpen && onComplete != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: OutlinedButton.icon(
                onPressed: onComplete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.success,
                  side: BorderSide(color: AppColor.success.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.zero,
                ),
                icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                label: Text(
                  'Mark as Completed',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColor.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _badge(String text, Color textColor, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: AppTypography.labelSmall.copyWith(color: textColor, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildMetaRow(bool isDark, String formattedDate) {
    final textColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final location = [ask.cityName, ask.regionLabel].where((s) => s.isNotEmpty).join(', ');
    return Row(
      children: [
        if (location.isNotEmpty) ...[
          Icon(Icons.location_on_outlined, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(location, style: AppTypography.labelSmall.copyWith(color: textColor, fontWeight: FontWeight.w400)),
          const SizedBox(width: 12),
        ],
        if (formattedDate.isNotEmpty) ...[
          Icon(Icons.calendar_today_outlined, size: 12, color: textColor),
          const SizedBox(width: 4),
          Text(formattedDate, style: AppTypography.labelSmall.copyWith(color: textColor, fontWeight: FontWeight.w400)),
        ],
      ],
    );
  }
}
