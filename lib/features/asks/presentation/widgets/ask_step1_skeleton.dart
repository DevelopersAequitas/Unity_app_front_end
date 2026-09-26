import 'package:flutter/material.dart';

class AskStep1Skeleton extends StatelessWidget {
  const AskStep1Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : const Color(0xFFF1F5F9);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 16,
            decoration: BoxDecoration(
              color: placeholderColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: placeholderColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 120,
            height: 16,
            decoration: BoxDecoration(
              color: placeholderColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: List.generate(
              6,
              (index) => Container(
                width: 90 + (index % 3) * 20,
                height: 38,
                decoration: BoxDecoration(
                  color: placeholderColor,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
