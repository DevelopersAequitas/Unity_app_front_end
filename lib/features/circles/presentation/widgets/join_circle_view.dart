import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/circle_category_entity.dart';
import '../../domain/entities/circle_join_request_entity.dart';
import 'category_grid_section.dart';

class JoinCircleView extends StatelessWidget {
  final List<CircleCategoryEntity> industryCategories;
  final List<CircleCategoryEntity> interestCategories;
  final CircleJoinRequestEntity? Function(CircleCategoryEntity category)?
      joinRequestResolver;
  final ValueChanged<CircleCategoryEntity> onCategoryTap;

  const JoinCircleView({
    super.key,
    required this.industryCategories,
    required this.interestCategories,
    this.joinRequestResolver,
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
          const SizedBox(height: 12),
          CategoryGridSection(
            title: 'Industry Specific Circles',
            icon: Icons.domain_rounded,
            iconColor: AppColor.primaryBlue,
            categories: industryCategories,
            joinRequestResolver: joinRequestResolver,
            onCategoryTap: onCategoryTap,
          ),
        ],
        if (hasInterest) ...[
          const SizedBox(height: 20),
          CategoryGridSection(
            title: 'Interest Specific Circles',
            icon: Icons.groups_rounded,
            iconColor: AppColor.primaryPink,
            categories: interestCategories,
            joinRequestResolver: joinRequestResolver,
            onCategoryTap: onCategoryTap,
          ),
        ],
        const SizedBox(height: 24),
      ]),
    );
  }
}
