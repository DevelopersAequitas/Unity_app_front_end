import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/referral_entity.dart';
import '../../domain/entities/referral_status_entity.dart';

class ReferralStatusUpdateSheet extends StatelessWidget {
  final ReferralEntity referral;
  final List<ReferralStatusEntity> availableStatuses;
  final Function(int statusId, String statusName) onStatusSelected;

  const ReferralStatusUpdateSheet({
    super.key,
    required this.referral,
    required this.availableStatuses,
    required this.onStatusSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required ReferralEntity referral,
    required List<ReferralStatusEntity> availableStatuses,
    required Function(int statusId, String statusName) onStatusSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.transparent,
      isScrollControlled: true,
      builder: (_) => ReferralStatusUpdateSheet(
        referral: referral,
        availableStatuses: availableStatuses,
        onStatusSelected: onStatusSelected,
      ),
    );
  }

  IconData _getStatusIcon(String name) {
    switch (name.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_top_rounded;
      case 'contacted':
        return Icons.phone_in_talk_rounded;
      case 'got business':
        return Icons.verified_rounded;
      case 'not qualified':
        return Icons.cancel_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  Color _getStatusColor(String name) {
    switch (name.toLowerCase()) {
      case 'pending':
        return const Color(0xFFD97706);
      case 'contacted':
        return const Color(0xFF2563EB);
      case 'got business':
        return const Color(0xFF059669);
      case 'not qualified':
        return const Color(0xFFDC2626);
      default:
        return AppColor.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Update Referral Status',
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 17,
              color: AppColor.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'For "${referral.referralOf}"',
            style: AppTypography.bodySmall.copyWith(
              color: AppColor.lightTextTertiary,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 16),

          ...availableStatuses.map((status) {
            final isSelected = status.id == referral.statusId ||
                status.name.toLowerCase() == referral.statusName.toLowerCase();
            final color = _getStatusColor(status.name);
            final icon = _getStatusIcon(status.name);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: isSelected
                    ? color.withValues(alpha: 0.08)
                    : AppColor.lightSurfaceSubtle,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onStatusSelected(status.id, status.name);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? color.withValues(alpha: 0.4)
                            : AppColor.lightBorder,
                        width: isSelected ? 1.2 : 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, size: 18, color: color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            status.name,
                            style: AppTypography.titleMedium.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? color
                                  : AppColor.lightTextPrimary,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: color,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
