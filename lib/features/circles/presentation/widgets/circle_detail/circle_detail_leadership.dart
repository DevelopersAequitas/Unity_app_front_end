import 'package:flutter/material.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_avatar.dart';
import '../../../domain/entities/circle_entity.dart';
import '../../../domain/entities/circle_leader_entity.dart';
import '../circle_icon_helper.dart';

class CircleDetailLeadership extends StatelessWidget {
  final CircleEntity circle;

  const CircleDetailLeadership({super.key, required this.circle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = CircleIconHelper.getCategoryConfig(circle.category, circle.circleKey);
    final cardBg = isDark ? AppColor.darkSurface : Colors.white;
    final borderColor = isDark
        ? AppColor.darkBorder
        : config.tintColor.withValues(alpha: 0.18);

    final circleLeaders = circle.circleLeaders;
    final regionalLeaders = circle.regionalLeaders;

    // If both empty, fallback to leadership
    final hasStructuredLeaders = circleLeaders.isNotEmpty || regionalLeaders.isNotEmpty;
    final fallbackLeaders = !hasStructuredLeaders ? circle.leadership : const <CircleLeaderEntity>[];

    if (!hasStructuredLeaders && fallbackLeaders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: AppColor.brandGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.workspace_premium_outlined, size: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Circle Leadership & Mentors',
                  style: AppTypography.titleSmall.copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 1. Circle Leaders (First)
            if (circleLeaders.isNotEmpty) ...[
              _buildSectionSubheader(
                title: 'Circle Leaders',
                count: circleLeaders.length,
                isDark: isDark,
                icon: Icons.star_rounded,
                accentColor: AppColor.primaryBlue,
              ),
              const SizedBox(height: 8),
              ...circleLeaders.map((leader) => _buildLeaderRow(context, leader, isDark, config)),
              if (regionalLeaders.isNotEmpty) const SizedBox(height: 12),
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
              const SizedBox(height: 8),
              ...regionalLeaders.map((leader) => _buildLeaderRow(context, leader, isDark, config)),
            ],

            // 3. Fallback if unstructured
            if (!hasStructuredLeaders && fallbackLeaders.isNotEmpty) ...[
              ...fallbackLeaders.map((leader) => _buildLeaderRow(context, leader, isDark, config)),
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
        Icon(icon, size: 14, color: accentColor),
        const SizedBox(width: 4),
        Text(
          title,
          style: AppTypography.labelSmall.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColor.darkTextSecondary : const Color(0xFF4B5563),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$count',
            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w500, color: accentColor),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderRow(
    BuildContext context,
    CircleLeaderEntity leader,
    bool isDark,
    CircleIconConfig config,
  ) {
    final roleName = leader.effectiveRole;
    final hasCompany = leader.companyName != null && leader.companyName!.isNotEmpty;
    final hasRegion = leader.region != null && leader.region!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurfaceSubtle : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : config.tintColor.withValues(alpha: 0.15),
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
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Role name on TOP
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        config.tintColor.withValues(alpha: 0.12),
                        config.bgTint,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: config.tintColor.withValues(alpha: 0.25),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        leader.leaderType == 'circle' ? Icons.stars_rounded : Icons.public_rounded,
                        size: 11,
                        color: config.tintColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        roleName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: config.tintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // 2. Profile Details: Avatar + Name + Company + City/Region
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppAvatar(
                      imageUrl: leader.avatarUrl,
                      name: leader.name,
                      size: 44,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leader.name,
                            style: AppTypography.titleSmall.copyWith(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (hasCompany) ...[
                            const SizedBox(height: 2),
                            Text(
                              leader.companyName!,
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 11.5,
                                color: isDark ? AppColor.darkTextSecondary : const Color(0xFF4B5563),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (hasRegion) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 11.5,
                                  color: AppColor.primaryBlue,
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    leader.region!,
                                    style: AppTypography.labelSmall.copyWith(
                                      fontSize: 10.5,
                                      color: isDark ? AppColor.darkTextSecondary : const Color(0xFF6B7280),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (leader.id.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: isDark ? AppColor.darkTextDisabled : const Color(0xFF9CA3AF),
                      ),
                    ],
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

