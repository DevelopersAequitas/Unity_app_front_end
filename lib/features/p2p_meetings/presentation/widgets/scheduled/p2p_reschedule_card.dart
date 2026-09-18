import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/theme/app_typography.dart';
import 'package:unity_app/features/p2p_meetings/domain/entities/p2p_reschedule_request_entity.dart';

class P2pRescheduleCard extends StatelessWidget {
  final P2pRescheduleRequestEntity reschedule;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const P2pRescheduleCard({
    super.key,
    required this.reschedule,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final requester = reschedule.requesterName ?? 'Peer';
    final newPlace = reschedule.newPlace?.trim() ?? '';
    final reason = reschedule.reason?.trim() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColor.lightBorder, width: 0.9),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.warning.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.schedule_outlined,
                  color: Color(0xFFD97706),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RESCHEDULE REQUEST',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        letterSpacing: 0.3,
                        color: AppColor.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$requester requested new time/venue',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 11,
                        color: AppColor.lightTextTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _TimeComparison(
            oldTime: reschedule.oldScheduledAt ?? '',
            newTime: reschedule.newScheduledAt ?? '',
          ),
          if (newPlace.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: AppColor.lightTextSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'New Place: $newPlace',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11.5,
                      color: AppColor.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
          if (reason.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Reason: “$reason”',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                color: AppColor.lightTextPrimary.withValues(alpha: 0.88),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColor.error, width: 0.8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                  ),
                  child: const Text(
                    'Decline',
                    style: TextStyle(
                      color: AppColor.error,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.success,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeComparison extends StatelessWidget {
  final String oldTime;
  final String newTime;

  const _TimeComparison({required this.oldTime, required this.newTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColor.lightBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Current: ',
                style: TextStyle(fontSize: 11, color: AppColor.lightTextTertiary),
              ),
              Text(
                oldTime,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColor.lightTextTertiary,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Text(
                'Proposed: ',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: AppColor.primaryBlue,
                ),
              ),
              Text(
                newTime,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: AppColor.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
