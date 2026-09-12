import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class VerifyOtpResendSection extends StatefulWidget {
  final VoidCallback onResend;
  final bool isResending;

  const VerifyOtpResendSection({
    super.key,
    required this.onResend,
    this.isResending = false,
  });

  @override
  State<VerifyOtpResendSection> createState() => _VerifyOtpResendSectionState();
}

class _VerifyOtpResendSectionState extends State<VerifyOtpResendSection> {
  static const List<int> _intervals = [30, 60, 120, 300];
  int _attemptIndex = 0;
  int _remainingSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer(30);
  }

  void _startTimer(int seconds) {
    _timer?.cancel();
    setState(() => _remainingSeconds = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds > 1) {
        setState(() => _remainingSeconds--);
      } else {
        setState(() => _remainingSeconds = 0);
        timer.cancel();
      }
    });
  }

  void _handleResend() {
    if (_remainingSeconds > 0 || widget.isResending) return;
    widget.onResend();
    final nextIdx = (_attemptIndex + 1).clamp(0, _intervals.length - 1);
    _attemptIndex = nextIdx;
    _startTimer(_intervals[_attemptIndex]);
  }

  String _formatTime(int totalSecs) {
    final mins = totalSecs ~/ 60;
    final secs = totalSecs % 60;
    return '${mins.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    final canResend = _remainingSeconds == 0 && !widget.isResending;

    return Center(
      child: Column(
        children: [
          Text(
            "Didn't receive the code?",
            style: AppTypography.bodySmall.copyWith(color: secondaryTextColor),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: canResend ? _handleResend : null,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                canResend
                    ? 'Resend OTP'
                    : 'Resend code in ${_formatTime(_remainingSeconds)}',
                style: AppTypography.bodyMedium.copyWith(
                  color: canResend
                      ? AppColor.primaryBlue
                      : secondaryTextColor.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
