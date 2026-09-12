import 'package:flutter/material.dart';
import '../../../../core/widgets/globe_background.dart';
import '../../../../core/widgets/primary_pill_button.dart';

class WelcomeFooter extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomeFooter({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const Positioned.fill(child: GlobeBackground(bottomOffset: 60)),
        Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: PrimaryPillButton(
            label: 'Get Started',
            onPressed: onGetStarted,
            showArrow: true,
          ),
        ),
      ],
    );
  }
}
