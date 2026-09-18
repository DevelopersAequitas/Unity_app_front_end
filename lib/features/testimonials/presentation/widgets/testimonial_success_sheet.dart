import 'package:flutter/material.dart';
import '../../../../core/widgets/common_reward_sheet.dart';

/// Testimonial-specific wrapper for [CommonRewardSheet].
class TestimonialSuccessSheet extends StatelessWidget {
  final int? coinsEarned;
  final int? impactEarned;
  final VoidCallback onDone;
  final VoidCallback onAddAnother;

  const TestimonialSuccessSheet({
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
      title: 'Testimonial Shared!',
      subtitle: 'Your words can make a real difference.',
      coinsEarned: coinsEarned,
      impactEarned: impactEarned,
      primaryButtonText: 'Back to Testimonials',
      secondaryButtonText: 'Add Another',
      onPrimaryTap: onDone,
      onSecondaryTap: onAddAnother,
      showSkyline: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonRewardSheet(
      title: 'Testimonial Shared!',
      subtitle: 'Your words can make a real difference.',
      coinsEarned: coinsEarned,
      impactEarned: impactEarned,
      primaryButtonText: 'Back to Testimonials',
      secondaryButtonText: 'Add Another',
      onPrimaryTap: onDone,
      onSecondaryTap: onAddAnother,
      showSkyline: true,
    );
  }
}
