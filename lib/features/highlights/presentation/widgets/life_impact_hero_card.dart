import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class LifeImpactHeroCard extends StatelessWidget {
  final int totalScore;
  final int activitiesCount;

  const LifeImpactHeroCard({
    super.key,
    required this.totalScore,
    this.activitiesCount = 0,
  });

  String _formatCompact(int number) {
    if (number >= 1000000000)
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    if (number >= 1000000) return '${(number / 1000000).toStringAsFixed(1)}M';
    if (number >= 1000) return '${(number / 1000).toStringAsFixed(1)}K';
    return number.toString();
  }

  String _formatFull(int number) {
    final str = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayScore = totalScore > 99999
        ? _formatCompact(totalScore)
        : _formatFull(totalScore);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF1E3A8A), Color(0xFF172554), Color(0xFF111827)]
              : const [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryBlue.withValues(alpha: isDark ? 0.22 : 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 0.5,
        ),
      ),
      child: Stack(
        children: [
          // Decorative background circle
          Positioned(
            right: -14,
            top: -14,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // LEFT: label + score
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pill label
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              color: Colors.white,
                              size: 11,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'LIFE IMPACT SCORE',
                              style: AppTypography.labelSmall.copyWith(
                                color: Colors.white,
                                letterSpacing: 0.5,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Big score
                      Text(
                        displayScore,
                        style: AppTypography.displayLarge.copyWith(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Lives transformed',
                        style: AppTypography.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                // Vertical divider
                // Container(
                //   width: 0.5,
                //   height: 56,
                //   color: Colors.white.withValues(alpha: 0.2),
                //   margin: const EdgeInsets.symmetric(horizontal: 16),
                // ),
                // RIGHT: stat column
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     _buildStatCol(
                //       icon: Icons.history_rounded,
                //       value: '$activitiesCount',
                //       label: 'Activities',
                //     ),
                //     const SizedBox(height: 10),
                //     _buildStatCol(
                //       icon: Icons.people_alt_rounded,
                //       value: displayScore,
                //       label: 'Total Lives',
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCol({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, color: Colors.white, size: 12),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTypography.titleSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 9,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
