import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/auth_ambient_background.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/verify_otp_action_section.dart';
import '../widgets/verify_otp_header.dart';
import '../widgets/verify_otp_input_section.dart';
import '../widgets/verify_otp_resend_section.dart';
import '../widgets/verify_otp_title_section.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String identifier;
  final String channel;

  const VerifyOtpScreen({
    super.key,
    required this.identifier,
    this.channel = 'email',
  });

  String get email => identifier;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (_) => TextEditingController());
    _focusNodes = List.generate(4, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentOtp => _controllers.map((c) => c.text).join();

  void _onVerify() {
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
          AuthVerifyOtpSubmitted(
            identifier: widget.identifier,
            channel: widget.channel,
            otp: _currentOtp,
          ),
        );
  }

  void _onResend() {
    context.read<AuthBloc>().add(
          AuthRequestOtpSubmitted(widget.identifier, channel: widget.channel),
        );
  }

  void _onStateChanged(BuildContext context, AuthState state) {
    if (state is AuthVerifySuccess) {
      AppSnackBar.showSuccess(context, state.message);
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    } else if (state is AuthOtpSentSuccess) {
      AppSnackBar.showSuccess(context, state.message);
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
                      VerifyOtpHeader(
                        onBack: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 16),
                      VerifyOtpTitleSection(
                        identifier: widget.identifier,
                        channel: widget.channel,
                      ),
                      const SizedBox(height: 32),
                      VerifyOtpInputSection(
                        controllers: _controllers,
                        focusNodes: _focusNodes,
                        onCompleted: (_) => _onVerify(),
                      ),
                      const SizedBox(height: 32),
                      VerifyOtpResendSection(
                        onResend: _onResend,
                        isResending: isLoading,
                      ),
                      const SizedBox(height: 48),
                      VerifyOtpActionSection(
                        onVerify: _onVerify,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 32),
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
