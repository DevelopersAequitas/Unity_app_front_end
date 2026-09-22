import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_environment.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/milestone_entity.dart';

class BadgeDetailCard extends StatelessWidget {
  final BadgeDetailEntity badge;

  const BadgeDetailCard({super.key, required this.badge});

  static String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  void _openDetails(BuildContext context, bool isEarned, String? dateStr) {
    final shareMessage =
        'Honored to achieve the "${badge.title}" Recognition Badge on ${AppEnvironment.appName}! 🌟\n\n'
        '"Peers are Partners in Business and Friends in Life."\n\n'
        'Connect with us: https://${AppEnvironment.appDomain}\n\n'
        '#PeersGlobal #UnityApp #CommunityOfCollaboration';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColor.lightSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColor.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: isEarned ? AppColor.brandGradient : null,
                color: isEarned ? null : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isEarned ? [
                  BoxShadow(
                    color: AppColor.primaryBlue.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ] : null,
              ),
              child: badge.badgeImageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        badge.badgeImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.workspace_premium_rounded,
                          color: isEarned ? Colors.white : Colors.grey,
                          size: 36,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.workspace_premium_rounded,
                      color: isEarned ? Colors.white : Colors.grey,
                      size: 36,
                    ),
            ),
            const SizedBox(height: 12),
            Text(
              badge.title,
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: isEarned ? const Color(0xFFECFDF5) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isEarned ? 'EARNED BADGE' : 'LOCKED BADGE',
                style: AppTypography.labelSmall.copyWith(
                  color: isEarned ? const Color(0xFF047857) : AppColor.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (badge.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                badge.description,
                style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.lightSurfaceMuted,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColor.lightBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Progress', style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary)),
                  Text(
                    '${badge.achievedCount} / ${badge.requiredCount}',
                    style: AppTypography.bodySmall.copyWith(color: AppColor.primaryBlue, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            if (dateStr != null) ...[
              const SizedBox(height: 8),
              Text('Earned: $dateStr', style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary, fontSize: 11)),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                if (isEarned) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => SharePlus.instance.share(ShareParams(text: shareMessage)),
                      icon: const Icon(Icons.share_rounded, size: 16),
                      label: const Text('Share Badge'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.primaryBlue,
                        side: const BorderSide(color: AppColor.primaryBlue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColor.lightTextSecondary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEarned = badge.status.toLowerCase() == 'earned';
    final dateStr = badge.earnedAt != null ? _formatDate(badge.earnedAt!) : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEarned ? AppColor.primaryBlue.withValues(alpha: 0.3) : AppColor.lightBorder,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _openDetails(context, isEarned, dateStr),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isEarned ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: badge.badgeImageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            badge.badgeImageUrl,
                            width: 46,
                            height: 46,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.workspace_premium_rounded,
                              color: isEarned ? AppColor.primaryBlue : Colors.grey,
                              size: 24,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.workspace_premium_rounded,
                          color: isEarned ? AppColor.primaryBlue : Colors.grey,
                          size: 24,
                        ),
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
                            child: Text(
                              badge.title,
                              style: AppTypography.titleSmall.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColor.lightTextPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: isEarned ? const Color(0xFFECFDF5) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isEarned ? 'EARNED' : 'LOCKED',
                              style: AppTypography.labelSmall.copyWith(
                                fontSize: 10,
                                color: isEarned ? const Color(0xFF047857) : AppColor.lightTextSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (badge.description.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          badge.description,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColor.lightTextSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress: ${badge.achievedCount} / ${badge.requiredCount}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColor.primaryBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                          if (dateStr != null)
                            Text(
                              dateStr,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColor.lightTextSecondary,
                                fontSize: 10,
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
        ),
      ),
    );
  }
}
