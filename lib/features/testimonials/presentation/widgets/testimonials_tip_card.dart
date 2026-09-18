import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/testimonials_event.dart';

class TestimonialsTipCard extends StatelessWidget {
  final TestimonialTab tab;

  const TestimonialsTipCard({
    super.key,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    final isReceived = tab == TestimonialTab.received;
    final icon = isReceived
        ? Icons.camera_alt_outlined
        : Icons.send_outlined;
    final message = isReceived
        ? 'People who appreciate your work make the journey meaningful.'
        : "You've taken time to appreciate others. Keep spreading positivity.";
    final accentColor = isReceived
        ? AppColor.primaryBlue
        : const Color(0xFF6366F1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: accentColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColor.lightTextSecondary,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
