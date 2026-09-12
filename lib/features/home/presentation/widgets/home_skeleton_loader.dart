import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class HomeSkeletonLoader extends StatefulWidget {
  const HomeSkeletonLoader({super.key});

  @override
  State<HomeSkeletonLoader> createState() => _HomeSkeletonLoaderState();
}

class _HomeSkeletonLoaderState extends State<HomeSkeletonLoader>
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
    _opacityAnim = Tween<double>(begin: 0.3, end: 0.7).animate(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildBlock(height: 72, color: blockColor, radius: 16)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildBlock(height: 72, color: blockColor, radius: 16)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildBlock(height: 24, width: 140, color: blockColor, radius: 6),
                const SizedBox(height: 8),
                _buildBlock(height: 84, color: blockColor, radius: 12),
                const SizedBox(height: 20),
                _buildPostSkeleton(blockColor, isDark),
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
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _buildPostSkeleton(Color blockColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              _buildBlock(height: 36, width: 36, color: blockColor, radius: 18),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBlock(height: 14, width: 100, color: blockColor, radius: 4),
                  const SizedBox(height: 4),
                  _buildBlock(height: 10, width: 60, color: blockColor, radius: 4),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildBlock(height: 14, width: double.infinity, color: blockColor, radius: 4),
          const SizedBox(height: 6),
          _buildBlock(height: 14, width: 220, color: blockColor, radius: 4),
          const SizedBox(height: 12),
          _buildBlock(height: 140, width: double.infinity, color: blockColor, radius: 12),
        ],
      ),
    );
  }
}
