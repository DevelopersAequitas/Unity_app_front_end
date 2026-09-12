import 'package:flutter/material.dart';
import '../../../../core/widgets/primary_pill_button.dart';

class VerifyOtpActionSection extends StatelessWidget {
  final VoidCallback onVerify;
  final bool isLoading;

  const VerifyOtpActionSection({
    super.key,
    required this.onVerify,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryPillButton(
      label: 'Verify & Continue',
      isLoading: isLoading,
      onPressed: onVerify,
    );
  }
}
