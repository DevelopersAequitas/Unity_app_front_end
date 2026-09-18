import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class LeaderboardSkeleton extends StatefulWidget {
  const LeaderboardSkeleton({super.key});

  @override
  State<LeaderboardSkeleton> createState() => _LeaderboardSkeletonState();
}

class _LeaderboardSkeletonState extends State<LeaderboardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shimmer = 0.35 + (_controller.value * 0.45);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // ── Podium Skeleton ──
              Container(
                height: 200,
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.lightBorder),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: _buildPodiumSkeletonColumn(shimmer, 130)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildPodiumSkeletonColumn(shimmer, 165)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildPodiumSkeletonColumn(shimmer, 130)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── List Rows Skeleton ──
              ...List.generate(
                5,
                (index) => Container(
                  height: 64,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.lightBorder.withValues(alpha: 0.6)),
                  ),
                  child: Row(
                    children: [
                      // Rank pill
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.lightBorder.withValues(alpha: shimmer),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Avatar circle
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.lightBorder.withValues(alpha: shimmer),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Name & subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColor.lightBorder.withValues(alpha: shimmer),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 80,
                              height: 10,
                              decoration: BoxDecoration(
                                color: AppColor.lightBorder.withValues(alpha: shimmer),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Coin badge
                      Container(
                        width: 50,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColor.lightBorder.withValues(alpha: shimmer),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPodiumSkeletonColumn(double shimmer, double height) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColor.lightSurfaceSubtle.withValues(alpha: shimmer),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.lightBorder.withValues(alpha: shimmer),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 60,
            height: 10,
            decoration: BoxDecoration(
              color: AppColor.lightBorder.withValues(alpha: shimmer),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 40,
            height: 8,
            decoration: BoxDecoration(
              color: AppColor.lightBorder.withValues(alpha: shimmer),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
