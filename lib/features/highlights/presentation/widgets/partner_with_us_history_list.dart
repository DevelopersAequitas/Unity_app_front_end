import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/partner_with_us_entity.dart';

class PartnerWithUsHistoryList extends StatelessWidget {
  final List<PartnerWithUsEntity> submissions;
  final bool isLoading;

  const PartnerWithUsHistoryList({
    super.key,
    required this.submissions,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (submissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.handshake_outlined,
              size: 48,
              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              'No Partnership Applications Yet',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your submitted proposals will appear here.',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w400,
                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: submissions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = submissions[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.brandOrCompanyName.isNotEmpty ? item.brandOrCompanyName : item.fullName,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.status ?? 'Pending Review',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColor.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${item.industry} • ${item.city}',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                ),
              ),
              if (item.partnershipGoal.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  'Goal: ${item.partnershipGoal}',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
