import 'package:flutter/material.dart';

class HighlightsBottomBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const HighlightsBottomBanner({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/end_screen_image.png',
            width: double.infinity,
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/end_screen_image.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
