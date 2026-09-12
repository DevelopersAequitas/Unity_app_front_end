import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/widgets/globe_background.dart';
import '../../../../core/widgets/peers_logo.dart';
import '../../../../core/widgets/primary_pill_button.dart';
import '../../../../core/widgets/responsive_container.dart';
import '../widgets/welcome_content.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBackground,
      body: ResponsiveContainer(
        child: Stack(
          children: [
            const Positioned.fill(child: GlobeBackground(bottomOffset: 70)),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    const PeersLogo(iconSize: 64, showText: false),
                    const SizedBox(height: 8),
                    const WelcomeContent(),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 48),
                      child: PrimaryPillButton(
                        label: 'Get Started',
                        onPressed: () => _navigateToLogin(context),
                        showArrow: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
