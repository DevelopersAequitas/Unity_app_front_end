import 'package:flutter/material.dart';
import '../../../../core/widgets/app_error_view.dart';

class LeaderboardErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const LeaderboardErrorView({
    super.key,
    required this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AppErrorView(
      title: 'Unable to Load Leaderboard',
      message: message,
      onRetry: onRetry,
      screenName: 'Leaderboard',
    );
  }
}
