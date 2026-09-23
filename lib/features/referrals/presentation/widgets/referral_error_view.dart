import 'package:flutter/material.dart';
import '../../../../core/widgets/app_error_view.dart';

class ReferralErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const ReferralErrorView({
    super.key,
    this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorView(
      title: 'Unable to Load Referrals',
      message: message,
      onRetry: onRetry,
      screenName: 'Referrals',
    );
  }
}
