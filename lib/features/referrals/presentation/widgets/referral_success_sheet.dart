import 'package:flutter/material.dart';
import '../../../../core/widgets/common_reward_sheet.dart';

/// Referral specific wrapper for [CommonRewardSheet].
class ReferralSuccessSheet extends StatelessWidget {
  final int? coinsEarned;
  final int? impactEarned;
  final VoidCallback onDone;
  final VoidCallback onAddAnother;

  const ReferralSuccessSheet({
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
      title: 'Referral Shared Successfully!',
      subtitle: 'Sharing business leads empowers fellow peers to grow.',
      coinsEarned: coinsEarned,
      impactEarned: impactEarned,
      primaryButtonText: 'Back to Referrals',
      secondaryButtonText: 'Give Another Referral',
      onPrimaryTap: onDone,
      onSecondaryTap: onAddAnother,
      showSkyline: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonRewardSheet(
      title: 'Referral Shared Successfully!',
      subtitle: 'Sharing business leads empowers fellow peers to grow.',
      coinsEarned: coinsEarned,
      impactEarned: impactEarned,
      primaryButtonText: 'Back to Referrals',
      secondaryButtonText: 'Give Another Referral',
      onPrimaryTap: onDone,
      onSecondaryTap: onAddAnother,
      showSkyline: true,
    );
  }
}
