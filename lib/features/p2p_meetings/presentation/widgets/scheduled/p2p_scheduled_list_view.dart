import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/features/p2p_meetings/domain/entities/p2p_meeting_request_entity.dart';
import 'package:unity_app/features/p2p_meetings/domain/entities/p2p_reschedule_request_entity.dart';
import 'package:unity_app/features/p2p_meetings/domain/entities/reschedule_p2p_meeting_params.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/common/p2p_empty_state.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/scheduled/p2p_request_card.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/scheduled/p2p_reschedule_card.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/scheduled/p2p_reschedule_modal.dart';

class P2pScheduledListView extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<P2pMeetingRequestEntity> requests;
  final List<P2pRescheduleRequestEntity> reschedules;
  final int subTabIndex; // 0: Received, 1: Sent, 2: Reschedules
  final Future<void> Function() onRefresh;
  final ValueChanged<String> onAccept;
  final ValueChanged<String> onReject;
  final ValueChanged<String> onCancel;
  final ValueChanged<RescheduleP2pMeetingParams> onReschedule;
  final ValueChanged<String> onApproveReschedule;
  final ValueChanged<String> onRejectReschedule;

  const P2pScheduledListView({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.requests,
    required this.reschedules,
    required this.subTabIndex,
    required this.onRefresh,
    required this.onAccept,
    required this.onReject,
    required this.onCancel,
    required this.onReschedule,
    required this.onApproveReschedule,
    required this.onRejectReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final isReschedulesTab = subTabIndex == 2;

    if (isLoading && (isReschedulesTab ? reschedules.isEmpty : requests.isEmpty)) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryBlue),
      );
    }

    if (isReschedulesTab) {
      if (reschedules.isEmpty) {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 90),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: const P2pEmptyState(
                  title: 'No Pending Reschedules',
                  subtitle: 'When peers request a new time or venue, they will appear here.',
                  icon: Icons.schedule_outlined,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
          itemCount: reschedules.length,
          itemBuilder: (context, index) {
            final res = reschedules[index];
            return P2pRescheduleCard(
              reschedule: res,
              onApprove: () => onApproveReschedule(res.id),
              onReject: () => onRejectReschedule(res.id),
            );
          },
        ),
      );
    }

    if (requests.isEmpty) {
      final isInbox = subTabIndex == 0;
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 90),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: P2pEmptyState(
                title: isInbox ? 'No Meeting Invites' : 'No Sent Meeting Invites',
                subtitle: isInbox
                    ? 'Incoming 1-to-1 meeting requests from peers will show here.'
                    : 'Schedule a future 1-to-1 meeting with any peer member.',
                icon: Icons.calendar_month_outlined,
              ),
            ),
          ],
        ),
      );
    }

    final isInbox = subTabIndex == 0;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 90),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final req = requests[index];
          return P2pRequestCard(
            request: req,
            isInbox: isInbox,
            onAccept: () => onAccept(req.id),
            onReject: () => onReject(req.id),
            onCancel: () => onCancel(req.id),
            onReschedule: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: AppColor.transparent,
                builder: (_) => P2pRescheduleModal(
                  requestId: req.id,
                  currentPlace: req.place ?? '',
                  onSubmit: onReschedule,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
