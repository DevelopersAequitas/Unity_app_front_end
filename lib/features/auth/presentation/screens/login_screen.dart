import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/auth_ambient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form_section.dart';
import '../widgets/login_header.dart';
import '../widgets/login_title_section.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  String _selectedChannel = 'email';
  String _selectedDialCode = '+91';
  String _selectedFlag = '🇮🇳';

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSendOtp() {
    FocusScope.of(context).unfocus();
    if (_selectedChannel == 'whatsapp') {
      final rawDigits = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
      final code = _selectedDialCode.startsWith('+')
          ? _selectedDialCode
          : '+$_selectedDialCode';
      final fullPhone = '$code$rawDigits';
      context.read<AuthBloc>().add(
            AuthRequestOtpSubmitted(fullPhone, channel: 'whatsapp'),
          );
    } else {
      context.read<AuthBloc>().add(
            AuthRequestOtpSubmitted(_emailController.text.trim(), channel: 'email'),
          );
    }
  }

  void _onCreateAccount() {
    Navigator.of(context).pushNamed(AppRoutes.register);
  }

  void _onStateChanged(BuildContext context, AuthState state) {
    if (state is AuthOtpSentSuccess) {
      AppSnackBar.showSuccess(context, state.message);
      Navigator.of(context).pushNamed(
        AppRoutes.verifyOtp,
        arguments: {
          'identifier': state.identifier,
          'email': state.identifier,
          'channel': state.channel,
        },
      );
    } else if (state is AuthError) {
      AppSnackBar.showError(context, state.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          body: AuthAmbientBackground(
            child: SafeArea(
              child: ResponsiveContainer(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      LoginHeader(
                        onBack: Navigator.of(context).canPop()
                            ? () => Navigator.of(context).pop()
                            : null,
                      ),
                      const SizedBox(height: 16),
                      LoginTitleSection(channel: _selectedChannel),
                      const SizedBox(height: 24),
                      LoginFormSection(
                        emailController: _emailController,
                        phoneController: _phoneController,
                        selectedChannel: _selectedChannel,
                        dialCode: _selectedDialCode,
                        flag: _selectedFlag,
                        isLoading: isLoading,
                        onChannelChanged: (ch) =>
                            setState(() => _selectedChannel = ch),
                        onCountryChanged: (c) => setState(() {
                          _selectedDialCode = c.dialCode;
                          _selectedFlag = c.flag;
                        }),
                        onSendOtp: _onSendOtp,
                        onCreateAccount: _onCreateAccount,
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
