import 'package:flutter/material.dart';
import 'package:unity_app/core/widgets/common_reward_sheet.dart';

/// P2P Meeting-specific wrapper for [CommonRewardSheet].
class P2pSuccessSheet extends StatelessWidget {
  final int? coinsEarned;
  final int? impactEarned;
  final VoidCallback onDone;

  const P2pSuccessSheet({
    super.key,
    this.coinsEarned,
    this.impactEarned,
    required this.onDone,
  });

  static Future<void> show(
    BuildContext context, {
    int? coinsEarned,
    int? impactEarned,
    required VoidCallback onDone,
  }) {
    return CommonRewardSheet.show(
      context,
      title: 'P2P Meeting Logged!',
      subtitle: 'Building deeper bonds and empowering fellow peers.',
      coinsEarned: coinsEarned ?? 3000,
      impactEarned: impactEarned ?? 1,
      primaryButtonText: 'Back to P2P Meetings',
      secondaryButtonText: null,
      onPrimaryTap: onDone,
      onSecondaryTap: null,
      showSkyline: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonRewardSheet(
      title: 'P2P Meeting Logged!',
      subtitle: 'Building deeper bonds and empowering fellow peers.',
      coinsEarned: coinsEarned ?? 3000,
      impactEarned: impactEarned ?? 1,
      primaryButtonText: 'Back to P2P Meetings',
      secondaryButtonText: null,
      onPrimaryTap: onDone,
      onSecondaryTap: null,
      showSkyline: true,
    );
  }
}
