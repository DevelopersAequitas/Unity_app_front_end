import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';

class PeerProfileSkeletonLoader extends StatefulWidget {
  const PeerProfileSkeletonLoader({super.key});

  @override
  State<PeerProfileSkeletonLoader> createState() =>
      _PeerProfileSkeletonLoaderState();
}

class _PeerProfileSkeletonLoaderState extends State<PeerProfileSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacityAnim = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final blockColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;

    return AnimatedBuilder(
      animation: _opacityAnim,
      builder: (context, _) {
        return Opacity(
          opacity: _opacityAnim.value,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                // Cover photo skeleton
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _buildBlock(height: 150, color: blockColor, radius: 16),
                    Positioned(
                      bottom: -32,
                      left: 12,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: blockColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColor.darkSurface
                                : AppColor.lightBackground,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 42),

                // Name & Subtitle
                _buildBlock(
                  height: 20,
                  width: 180,
                  color: blockColor,
                  radius: 6,
                ),
                const SizedBox(height: 8),
                _buildBlock(
                  height: 14,
                  width: 240,
                  color: blockColor,
                  radius: 4,
                ),
                const SizedBox(height: 14),

                // 3 Action Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: _buildBlock(
                        height: 34,
                        color: blockColor,
                        radius: 8,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildBlock(
                        height: 34,
                        color: blockColor,
                        radius: 8,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _buildBlock(
                        height: 34,
                        color: blockColor,
                        radius: 8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Stats row
                _buildBlock(height: 68, color: blockColor, radius: 14),
                const SizedBox(height: 12),

                // Contact card skeleton
                _buildBlock(height: 96, color: blockColor, radius: 14),
                const SizedBox(height: 12),

                // Business card skeleton
                _buildBlock(height: 110, color: blockColor, radius: 14),
                const SizedBox(height: 12),

                // Post item skeleton
                _buildPostSkeleton(blockColor, isDark),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBlock({
    required double height,
    double? width,
    required Color color,
    required double radius,
  }) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _buildPostSkeleton(Color blockColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: blockColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: blockColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBlock(
                    height: 12,
                    width: 120,
                    color: blockColor,
                    radius: 4,
                  ),
                  const SizedBox(height: 6),
                  _buildBlock(
                    height: 10,
                    width: 70,
                    color: blockColor,
                    radius: 3,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBlock(height: 14, color: blockColor, radius: 4),
          const SizedBox(height: 6),
          _buildBlock(height: 14, width: 200, color: blockColor, radius: 4),
          const SizedBox(height: 12),
          _buildBlock(height: 160, color: blockColor, radius: 12),
        ],
      ),
    );
  }
}
