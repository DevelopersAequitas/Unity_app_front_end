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

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSendOtp(String channel) {
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
      AuthRequestOtpSubmitted(_emailController.text, channel: channel),
    );
  }

  void _onCreateAccount() {
    Navigator.of(context).pushNamed(AppRoutes.register);
  }

  void _onStateChanged(BuildContext context, AuthState state) {
    if (state is AuthOtpSentSuccess) {
      AppSnackBar.showSuccess(context, state.message);
      Navigator.of(context).pushNamed(
        AppRoutes.verifyOtp,
        arguments: {'email': state.email, 'channel': state.channel},
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
                      const LoginTitleSection(),
                      const SizedBox(height: 24),
                      LoginFormSection(
                        emailController: _emailController,
                        isLoading: isLoading,
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
