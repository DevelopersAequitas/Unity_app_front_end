import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/features/p2p_meetings/domain/entities/p2p_meeting_entity.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/common/p2p_empty_state.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/completed/p2p_completed_card.dart';
import 'package:unity_app/features/p2p_meetings/presentation/widgets/completed/p2p_completed_detail_sheet.dart';

class P2pCompletedListView extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final List<P2pMeetingEntity> items;
  final Future<void> Function() onRefresh;
  final bool isInitiatedByMe;

  const P2pCompletedListView({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.items,
    required this.onRefresh,
    required this.isInitiatedByMe,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryBlue),
      );
    }

    if (errorMessage != null && items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage!,
                style: const TextStyle(
                  color: AppColor.error,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onRefresh,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 90),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: P2pEmptyState(
                title: isInitiatedByMe
                    ? 'No Meetings Initiated by You'
                    : 'No Peer Initiated Meetings',
                subtitle: isInitiatedByMe
                    ? 'Log your completed 1-to-1 meetings to earn coins & impact points.'
                    : 'Meetings logged by your peers with you will appear here.',
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
        itemCount: items.length,
        itemBuilder: (context, index) {
          final meeting = items[index];
          return P2pCompletedCard(
            meeting: meeting,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: AppColor.transparent,
                builder: (_) => P2pCompletedDetailSheet(meeting: meeting),
              );
            },
          );
        },
      ),
    );
  }
}
