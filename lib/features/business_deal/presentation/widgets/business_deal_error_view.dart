import 'package:flutter/material.dart';
import '../../../../core/widgets/app_error_view.dart';

class BusinessDealErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const BusinessDealErrorView({
    super.key,
    this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorView(
      title: 'Unable to Load Business Deals',
      message: message,
      onRetry: onRetry,
      screenName: 'Business Deals',
    );
  }
}
