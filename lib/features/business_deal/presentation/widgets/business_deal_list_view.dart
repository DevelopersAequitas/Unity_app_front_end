import 'package:flutter/material.dart';
import '../../domain/entities/business_deal_entity.dart';
import 'business_deal_card.dart';

class BusinessDealListView extends StatelessWidget {
  final List<BusinessDealEntity> deals;
  final RefreshCallback onRefresh;
  final String tabType;
  final ScrollController? scrollController;
  final bool isLoadingMore;

  const BusinessDealListView({
    super.key,
    required this.deals,
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
        itemCount: deals.length + extraItem,
        itemBuilder: (context, index) {
          if (index < deals.length) {
            return BusinessDealCard(
              deal: deals[index],
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
