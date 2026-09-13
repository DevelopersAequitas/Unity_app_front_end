import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/circle_category_entity.dart';
import 'category_grid_section.dart';

class JoinCircleView extends StatelessWidget {
  final List<CircleCategoryEntity> industryCategories;
  final List<CircleCategoryEntity> interestCategories;
  final ValueChanged<CircleCategoryEntity> onCategoryTap;

  const JoinCircleView({
    super.key,
    required this.industryCategories,
    required this.interestCategories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasIndustry = industryCategories.isNotEmpty;
    final hasInterest = interestCategories.isNotEmpty;

    if (!hasIndustry && !hasInterest) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Text(
              'No circle categories found',
              style: TextStyle(color: AppColor.lightTextSecondary),
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        if (hasIndustry) ...[
          const SizedBox(height: 8),
          CategoryGridSection(
            title: 'Industry Specific Circles (${industryCategories.length})',
            subtitle: 'Connect with professionals in your industry',
            icon: Icons.domain_outlined,
            iconColor: AppColor.primaryBlue,
            categories: industryCategories,
            onCategoryTap: onCategoryTap,
            onViewAllTap: () {},
          ),
        ],
        if (hasInterest) ...[
          const SizedBox(height: 20),
          CategoryGridSection(
            title: 'Interest Specific Circles (${interestCategories.length})',
            subtitle: 'Explore communities based on your interests',
            icon: Icons.groups_outlined,
            iconColor: AppColor.primaryPink,
            categories: interestCategories,
            onCategoryTap: onCategoryTap,
            onViewAllTap: () {},
          ),
        ],
        const SizedBox(height: 24),
      ]),
    );
  }
}
