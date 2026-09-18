import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class LifeImpactHeroCard extends StatelessWidget {
  final int totalScore;

  const LifeImpactHeroCard({super.key, required this.totalScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.primaryBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                'LIVES IMPACTED SCORE',
                style: AppTypography.labelSmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '$totalScore',
            style: AppTypography.displayLarge.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            'Direct & community lives transformed',
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
