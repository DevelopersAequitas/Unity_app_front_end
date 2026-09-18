import 'package:flutter/material.dart';
import '../../domain/entities/referral_entity.dart';
import 'referral_card.dart';

class ReferralListView extends StatelessWidget {
  final List<ReferralEntity> referrals;
  final RefreshCallback onRefresh;
  final String tabType;
  final ScrollController? scrollController;
  final bool isLoadingMore;

  const ReferralListView({
    super.key,
    required this.referrals,
    required this.onRefresh,
    this.tabType = 'received',
    this.scrollController,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    final extraItem = isLoadingMore ? 1 : 0;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 96),
        itemCount: referrals.length + extraItem,
        itemBuilder: (context, index) {
          if (index < referrals.length) {
            return ReferralCard(
              referral: referrals[index],
              tabType: tabType,
            );
          }
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      ),
    );
  }
}
