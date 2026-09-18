import 'package:flutter/material.dart';
import '../../../../core/widgets/common_reward_sheet.dart';

/// Business Deal specific wrapper for [CommonRewardSheet].
class BusinessDealSuccessSheet extends StatelessWidget {
  final int? coinsEarned;
  final int? impactEarned;
  final VoidCallback onDone;
  final VoidCallback onAddAnother;

  const BusinessDealSuccessSheet({
    super.key,
    this.coinsEarned,
    this.impactEarned,
    required this.onDone,
    required this.onAddAnother,
  });

  static Future<void> show(
    BuildContext context, {
    int? coinsEarned,
    int? impactEarned,
    required VoidCallback onDone,
    required VoidCallback onAddAnother,
  }) {
    return CommonRewardSheet.show(
      context,
      title: 'Business Deal Recorded!',
      subtitle: 'Great business fosters stronger community growth.',
      coinsEarned: coinsEarned,
      impactEarned: impactEarned,
      primaryButtonText: 'Back to Deals',
      secondaryButtonText: 'Add Another Deal',
      onPrimaryTap: onDone,
      onSecondaryTap: onAddAnother,
      showSkyline: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonRewardSheet(
      title: 'Business Deal Recorded!',
      subtitle: 'Great business fosters stronger community growth.',
      coinsEarned: coinsEarned,
      impactEarned: impactEarned,
      primaryButtonText: 'Back to Deals',
      secondaryButtonText: 'Add Another Deal',
      onPrimaryTap: onDone,
      onSecondaryTap: onAddAnother,
      showSkyline: true,
    );
  }
}
