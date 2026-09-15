import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_closed_category_entity.dart';
import '../../../domain/entities/circle_entity.dart';
import '../../../domain/entities/circle_open_category_entity.dart';
import '../../../domain/usecases/get_circle_closed_categories_usecase.dart';
import '../../../domain/usecases/get_circle_open_categories_usecase.dart';
import '../circle_icon_helper.dart';

class CircleDetailCategoryStatus extends StatefulWidget {
  final CircleEntity circle;

  const CircleDetailCategoryStatus({super.key, required this.circle});

  @override
  State<CircleDetailCategoryStatus> createState() => _CircleDetailCategoryStatusState();
}

class _CircleDetailCategoryStatusState extends State<CircleDetailCategoryStatus> {
  List<CircleOpenCategoryEntity> _openCategories = [];
  List<CircleClosedCategoryEntity> _closedCategories = [];
  bool _isLoading = true;
  int _totalOpenCount = 0;
  int _totalClosedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCategoryData();
  }

  Future<void> _loadCategoryData() async {
    try {
      final openUseCase = context.read<GetCircleOpenCategoriesUseCase>();
      final closedUseCase = context.read<GetCircleClosedCategoriesUseCase>();

      final results = await Future.wait([
        openUseCase(widget.circle.id).catchError((_) => <CircleOpenCategoryEntity>[]),
        closedUseCase(widget.circle.id).catchError((_) => <CircleClosedCategoryEntity>[]),
      ]);

      if (!mounted) return;

      final openList = results[0] as List<CircleOpenCategoryEntity>;
      final closedList = results[1] as List<CircleClosedCategoryEntity>;

      int openCount = 0;
      for (final root in openList) {
        openCount += root.openLeafCount;
      }

      setState(() {
        _openCategories = openList;
        _closedCategories = closedList;
        _totalOpenCount = openCount;
        _totalClosedCount = closedList.length;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToCategories(int initialTabIndex) {
    Navigator.pushNamed(
      context,
      AppRoutes.circleCategories,
      arguments: {
        'circle': widget.circle,
        'initialTab': initialTabIndex,
        'openCategories': _openCategories,
        'closedCategories': _closedCategories,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : Colors.white;
    final borderColor = isDark ? AppColor.darkBorder : const Color(0xFFE5E7EB);
    final config = CircleIconHelper.getCategoryConfig(
      widget.circle.category,
      widget.circle.circleKey,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: config.tintColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.category_outlined,
                          size: 14,
                          color: config.tintColor,
                        ),
                      ),
                    ),

                    const SizedBox(width: 7),
                    Text(
                      'Category Availability',
                      style: AppTypography.titleSmall.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => _navigateToCategories(0),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View all',
                          style: AppTypography.labelSmall.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 10,
                          color: AppColor.primaryBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Two Interactive Stat Tiles (Open vs Closed)
            if (_isLoading)
              SizedBox(
                height: 58,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColor.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Checking categories...',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColor.darkTextSecondary : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Row(
                children: [
                  // Open Categories Card
                  Expanded(
                    child: _buildCategoryCard(
                      context: context,
                      title: 'Open Categories',
                      count: _totalOpenCount,
                      subtitle: 'Available to join',
                      icon: Icons.lock_open_rounded,
                      accentColor: AppColor.primaryBlue,
                      bgColor: isDark
                          ? AppColor.primaryBlue.withValues(alpha: 0.12)
                          : const Color(0xFFEFF6FF),
                      borderColor: isDark
                          ? AppColor.primaryBlue.withValues(alpha: 0.25)
                          : const Color(0xFFDBEAFE),
                      onTap: () => _navigateToCategories(0),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Closed Categories Card
                  Expanded(
                    child: _buildCategoryCard(
                      context: context,
                      title: 'Closed Categories',
                      count: _totalClosedCount,
                      subtitle: 'Occupied by peers',
                      icon: Icons.lock_outline_rounded,
                      accentColor: const Color(0xFFD97706),
                      bgColor: isDark
                          ? const Color(0xFFD97706).withValues(alpha: 0.12)
                          : const Color(0xFFFFFBEB),
                      borderColor: isDark
                          ? const Color(0xFFD97706).withValues(alpha: 0.25)
                          : const Color(0xFFFDE68A),
                      onTap: () => _navigateToCategories(1),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required int count,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required Color bgColor,
    required Color borderColor,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurfaceSubtle : bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 13, color: accentColor),
                      const SizedBox(width: 4),
                      Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 14,
                    color: isDark ? AppColor.darkTextDisabled : const Color(0xFF9CA3AF),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 9.5,
                  color: isDark ? AppColor.darkTextSecondary : const Color(0xFF6B7280),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
