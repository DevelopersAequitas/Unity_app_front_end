import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_pill_button.dart';
import 'otp_channel_selector.dart';

class LoginFormSection extends StatefulWidget {
  final TextEditingController emailController;
  final bool isLoading;
  final void Function(String channel) onSendOtp;
  final VoidCallback onCreateAccount;

  const LoginFormSection({
    super.key,
    required this.emailController,
    required this.isLoading,
    required this.onSendOtp,
    required this.onCreateAccount,
  });

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
  String _selectedChannel = 'email';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: widget.emailController,
          hintText: 'Email address',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => widget.onSendOtp(_selectedChannel),
          prefixIcon: Icon(
            Icons.mail_outline_rounded,
            size: 20,
            color: secondaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        OtpChannelSelector(
          selectedChannel: _selectedChannel,
          onChannelChanged: (ch) => setState(() => _selectedChannel = ch),
        ),
        const SizedBox(height: 24),
        PrimaryPillButton(
          label: 'Send OTP',
          isLoading: widget.isLoading,
          onPressed: () => widget.onSendOtp(_selectedChannel),
          showArrow: true,
        ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'New to Peers Global? ',
              style: AppTypography.bodyMedium.copyWith(
                color: secondaryTextColor,
              ),
            ),
            GestureDetector(
              onTap: widget.onCreateAccount,
              behavior: HitTestBehavior.opaque,
              child: Text(
                'Create an account',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColor.primaryBlue,
                  fontWeight: FontWeight.w500,
                  decorationColor: AppColor.primaryBlue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
