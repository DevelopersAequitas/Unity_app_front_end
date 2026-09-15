import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_join_request_entity.dart';
import 'timeline_step_item.dart';

class JoinRequestTimeline extends StatelessWidget {
  final CircleJoinRequestEntity? request;

  const JoinRequestTimeline({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    final isPro = request?.isPro ?? false;
    final cdApproved = request?.isCdApproved ?? false;
    final cdRejected = request?.cdRejectedAt != null ||
        request?.cdApprovalStatus == 'rejected' ||
        (request?.status.toLowerCase().contains('rejected_by_cd') ?? false);
    final cdPending = !cdApproved && !cdRejected;

    final idApproved = request?.isIdApproved ?? false;
    final idRejected = request?.idRejectedAt != null ||
        request?.idApprovalStatus == 'rejected' ||
        (request?.status.toLowerCase().contains('rejected_by_id') ?? false);
    final idPending = cdApproved && !idApproved && !idRejected;

    final isPaid = request?.isPaid ?? false;
    final isFeeActive = cdApproved && idApproved && !isPaid && !cdRejected && !idRejected;
    final isApproved = request?.isApproved ?? false;

    String cdSub = 'Waiting for review';
    if (cdApproved) {
      cdSub = request?.cdApprovedBy != null ? 'Approved by ${request!.cdApprovedBy}' : 'Approved by Circle Director';
    } else if (cdRejected) {
      cdSub = request?.cdRejectedBy != null ? 'Rejected by ${request!.cdRejectedBy}' : 'Rejected';
    } else if (cdPending) {
      cdSub = 'Under review by Circle Director';
    }

    String idSub = 'Waiting for CD approval';
    if (idApproved) {
      idSub = request?.idApprovedBy != null ? 'Approved by ${request!.idApprovedBy}' : 'Approved by Industry Director';
    } else if (idRejected) {
      idSub = request?.idRejectedBy != null ? 'Rejected by ${request!.idRejectedBy}' : 'Rejected';
    } else if (idPending) {
      idSub = 'Under review by Industry Director';
    }

    String proSub = 'Pending director approvals';
    if (isPro) {
      proSub = 'Verified Pro Member';
    } else if (cdRejected || idRejected) {
      proSub = 'Application closed';
    } else if (idApproved || cdApproved) {
      proSub = 'Pro Membership required before fee payment';
    }

    String feeSub = 'Pending prior approvals';
    if (isPaid) {
      feeSub = 'Fee payment completed';
    } else if (cdRejected || idRejected) {
      feeSub = 'Application closed';
    } else if (!isPro && (idApproved || cdApproved)) {
      feeSub = 'Requires active Pro Membership';
    } else if (request?.paymentUrl != null && request!.paymentUrl!.isNotEmpty) {
      feeSub = 'Payment link ready — tap below to pay';
    } else if (isFeeActive) {
      feeSub = 'Payment verification in progress';
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Application Progress',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w500,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 12),
          const TimelineStepItem(
            title: 'Request Submitted',
            subtitle: 'Application sent successfully',
            status: 'completed',
            icon: Icons.send_rounded,
          ),
          TimelineStepItem(
            title: 'Circle Director Approval',
            subtitle: cdSub,
            status: cdApproved ? 'completed' : cdRejected ? 'rejected' : cdPending ? 'in_progress' : 'inactive',
            icon: Icons.assignment_ind_outlined,
          ),
          TimelineStepItem(
            title: 'Industry Director Approval',
            subtitle: idSub,
            status: idApproved ? 'completed' : idRejected ? 'rejected' : idPending ? 'in_progress' : 'inactive',
            icon: Icons.business_outlined,
          ),
          TimelineStepItem(
            title: 'Pro Membership Status',
            subtitle: proSub,
            status: isPro
                ? 'completed'
                : (cdRejected || idRejected)
                    ? 'inactive'
                    : (idApproved || cdApproved)
                        ? 'in_progress'
                        : 'inactive',
            icon: isPro ? Icons.workspace_premium_rounded : Icons.workspace_premium_outlined,
          ),
          TimelineStepItem(
            title: 'Circle Fee Payment',
            subtitle: feeSub,
            status: isPaid
                ? 'completed'
                : (cdRejected || idRejected)
                    ? 'inactive'
                    : (isPro && isFeeActive)
                        ? 'in_progress'
                        : 'inactive',
            icon: Icons.payment_outlined,
          ),
          TimelineStepItem(
            title: 'Circle Activated',
            subtitle: isApproved ? 'Welcome to the circle!' : 'Final activation step',
            status: isApproved ? 'completed' : 'inactive',
            icon: Icons.check_circle_outline_rounded,
            isLast: true,
          ),
        ],
      ),
    );
  }
}
