import 'package:flutter/material.dart';

class AskTypesSkeleton extends StatelessWidget {
  const AskTypesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : const Color(0xFFF1F5F9);

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.28,
      ),
      itemCount: 8,
      itemBuilder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: placeholderColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black12,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Container(
                width: 100,
                height: 14,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white10 : Colors.black12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
