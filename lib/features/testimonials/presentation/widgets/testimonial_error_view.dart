import 'package:flutter/material.dart';
import '../../../../core/widgets/app_error_view.dart';

class TestimonialErrorView extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const TestimonialErrorView({
    super.key,
    this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorView(
      title: 'Unable to Load Testimonials',
      message: message,
      onRetry: onRetry,
      screenName: 'Testimonials',
    );
  }
}
