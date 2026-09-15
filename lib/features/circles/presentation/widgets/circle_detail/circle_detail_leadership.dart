import 'package:flutter/material.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_avatar.dart';
import '../../../domain/entities/circle_entity.dart';
import '../../../domain/entities/circle_leader_entity.dart';

class CircleDetailLeadership extends StatelessWidget {
  final CircleEntity circle;

  const CircleDetailLeadership({super.key, required this.circle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : Colors.white;
    final borderColor = isDark
        ? AppColor.darkBorder
        : const Color(0xFFE5E7EB);

    final circleLeaders = circle.circleLeaders;
    final regionalLeaders = circle.regionalLeaders;

    final hasStructuredLeaders = circleLeaders.isNotEmpty || regionalLeaders.isNotEmpty;
    final fallbackLeaders = !hasStructuredLeaders ? circle.leadership : const <CircleLeaderEntity>[];

    if (!hasStructuredLeaders && fallbackLeaders.isEmpty) {
      return const SizedBox.shrink();
    }

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
            // Section Header
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Icon(Icons.workspace_premium_outlined, size: 14, color: AppColor.primaryBlue),
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  'Circle Leadership & Mentors',
                  style: AppTypography.titleSmall.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 1. Circle Leaders (First)
            if (circleLeaders.isNotEmpty) ...[
              _buildSectionSubheader(
                title: 'Circle Leaders',
                count: circleLeaders.length,
                isDark: isDark,
                icon: Icons.stars_rounded,
                accentColor: AppColor.primaryBlue,
              ),
              const SizedBox(height: 6),
              _buildLeaderHorizontalList(context, circleLeaders, isDark),
              if (regionalLeaders.isNotEmpty) const SizedBox(height: 10),
            ],

            // 2. Regional Leaders (Second)
            if (regionalLeaders.isNotEmpty) ...[
              _buildSectionSubheader(
                title: 'Regional Leaders',
                count: regionalLeaders.length,
                isDark: isDark,
                icon: Icons.public_rounded,
                accentColor: const Color(0xFFD97706),
              ),
              const SizedBox(height: 6),
              _buildLeaderHorizontalList(context, regionalLeaders, isDark),
            ],

            // 3. Fallback if unstructured
            if (!hasStructuredLeaders && fallbackLeaders.isNotEmpty) ...[
              _buildLeaderHorizontalList(context, fallbackLeaders, isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionSubheader({
    required String title,
    required int count,
    required bool isDark,
    required IconData icon,
    required Color accentColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 12, color: accentColor),
        const SizedBox(width: 4),
        Text(
          title,
          style: AppTypography.labelSmall.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColor.darkTextSecondary : const Color(0xFF4B5563),
          ),
        ),
        const SizedBox(width: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$count',
            style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w500, color: accentColor),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderHorizontalList(
    BuildContext context,
    List<CircleLeaderEntity> leaders,
    bool isDark,
  ) {
    return SizedBox(
      height: 78,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: leaders.length,
        itemBuilder: (context, index) {
          final leader = leaders[index];
          return _buildCompactLeaderCard(context, leader, isDark);
        },
      ),
    );
  }

  Widget _buildCompactLeaderCard(
    BuildContext context,
    CircleLeaderEntity leader,
    bool isDark,
  ) {
    final isCircleLeader = leader.leaderType == 'circle';
    final roleColor = isCircleLeader ? AppColor.primaryBlue : const Color(0xFFD97706);
    final roleBg = isCircleLeader
        ? (isDark ? AppColor.primaryBlue.withValues(alpha: 0.12) : const Color(0xFFEFF6FF))
        : (isDark ? const Color(0xFFD97706).withValues(alpha: 0.12) : const Color(0xFFFFFBEB));
    final roleBorder = isCircleLeader
        ? (isDark ? AppColor.primaryBlue.withValues(alpha: 0.25) : const Color(0xFFDBEAFE))
        : (isDark ? const Color(0xFFD97706).withValues(alpha: 0.25) : const Color(0xFFFDE68A));

    final hasCompany = leader.companyName != null && leader.companyName!.trim().isNotEmpty;
    final hasRegion = leader.region != null && leader.region!.trim().isNotEmpty;
    final metaText = [
      if (hasCompany) leader.companyName!.trim(),
      if (hasRegion) leader.region!.trim(),
    ].join(' • ');

    return Container(
      width: 215,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : const Color(0xFFE5E7EB),
          width: 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: leader.id.isNotEmpty
              ? () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.peerProfile,
                    arguments: leader.id,
                  );
                }
            : null,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. Role name on TOP (Subtle pill badge, no green gradient)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: roleBg,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: roleBorder, width: 0.6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCircleLeader ? Icons.stars_rounded : Icons.public_rounded,
                        size: 9.5,
                        color: roleColor,
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          leader.effectiveRole,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: roleColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                // 2. Profile details: Avatar + Name + Company/Region
                Row(
                  children: [
                    AppAvatar(
                      imageUrl: leader.avatarUrl,
                      name: leader.name,
                      size: 28,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            leader.name,
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (metaText.isNotEmpty)
                            Text(
                              metaText,
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


