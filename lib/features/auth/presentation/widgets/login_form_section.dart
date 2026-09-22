import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_pill_button.dart';
import 'login_phone_input.dart';
import 'otp_channel_selector.dart';

class LoginFormSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String selectedChannel;
  final String dialCode;
  final String flag;
  final bool isLoading;
  final ValueChanged<String> onChannelChanged;
  final ValueChanged<({String dialCode, String flag})> onCountryChanged;
  final VoidCallback onSendOtp;
  final VoidCallback onCreateAccount;

  const LoginFormSection({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.selectedChannel,
    required this.dialCode,
    required this.flag,
    required this.isLoading,
    required this.onChannelChanged,
    required this.onCountryChanged,
    required this.onSendOtp,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final isWhatsapp = selectedChannel == 'whatsapp';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isWhatsapp)
          LoginPhoneInput(
            controller: phoneController,
            dialCode: dialCode,
            flag: flag,
            onCountryChanged: onCountryChanged,
            onSubmitted: onSendOtp,
          )
        else
          AppTextField(
            controller: emailController,
            hintText: 'Email address',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSendOtp(),
            prefixIcon: Icon(
              Icons.mail_outline_rounded,
              size: 20,
              color: secondaryTextColor,
            ),
          ),
        const SizedBox(height: 16),
        OtpChannelSelector(
          selectedChannel: selectedChannel,
          onChannelChanged: onChannelChanged,
        ),
        const SizedBox(height: 24),
        PrimaryPillButton(
          label: 'Send OTP',
          isLoading: isLoading,
          onPressed: onSendOtp,
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
              onTap: onCreateAccount,
              behavior: HitTestBehavior.opaque,
              child: Text(
                'Create an account',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColor.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
