import 'package:flutter/material.dart';
import 'package:unity_app/core/router/app_router.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/features/circles/domain/entities/circle_closed_category_entity.dart';
import 'circle_closed_category_actions.dart';
import 'circle_closed_category_occupant.dart';

class CircleClosedCategoryCard extends StatelessWidget {
  final CircleClosedCategoryEntity item;
  final String? currentUserId;

  const CircleClosedCategoryCard({
    super.key,
    required this.item,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : Colors.white;
    final borderColor =
        isDark ? AppColor.darkBorder : const Color(0xFFE5E7EB);
    final secondaryText =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final sectorBreadcrumb = [
      if (item.level2Name != null && item.level2Name!.isNotEmpty)
        item.level2Name!,
      if (item.level3Name != null && item.level3Name!.isNotEmpty)
        item.level3Name!,
    ].join(' • ');

    final peer = item.toPeerEntity();
    final bool isCurrentUser = currentUserId != null &&
        (currentUserId == item.occupantUserId || currentUserId == item.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2.5),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            if (isCurrentUser) {
              Navigator.pushNamed(context, AppRoutes.profile);
            } else if (item.occupantUserId != null &&
                item.occupantUserId!.isNotEmpty) {
              Navigator.pushNamed(
                context,
                AppRoutes.peerProfile,
                arguments: item.occupantUserId,
              );
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColor.primaryBlue
                                      .withValues(alpha: 0.12)
                                  : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: isDark
                                    ? AppColor.primaryBlue
                                        .withValues(alpha: 0.25)
                                    : const Color(0xFFDBEAFE),
                                width: 0.6,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.sell_outlined,
                                  size: 9.5,
                                  color: AppColor.primaryBlue,
                                ),
                                const SizedBox(width: 3),
                                Flexible(
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.primaryBlue,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (sectorBreadcrumb.isNotEmpty) ...[
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                sectorBreadcrumb,
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w400,
                                  color: secondaryText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFFD97706).withValues(alpha: 0.15)
                            : const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFFD97706).withValues(alpha: 0.3)
                              : const Color(0xFFFDE68A),
                          width: 0.6,
                        ),
                      ),
                      child: const Text(
                        'OCCUPIED',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFD97706),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                CircleClosedCategoryOccupant(
                  peer: peer,
                  isCurrentUser: isCurrentUser,
                  isDark: isDark,
                  secondaryText: secondaryText,
                ),
                if (!isCurrentUser) ...[
                  const SizedBox(height: 5),
                  CircleClosedCategoryActions(
                    peer: peer,
                    isDark: isDark,
                    borderColor: borderColor,
                    secondaryText: secondaryText,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
