import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_entity.dart';
import '../circle_icon_helper.dart';

class CircleDetailHeader extends StatelessWidget {
  final CircleEntity circle;

  const CircleDetailHeader({super.key, required this.circle});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = CircleIconHelper.getCategoryConfig(circle.category, circle.circleKey);
    final hasCover = circle.coverImageUrl != null && circle.coverImageUrl!.isNotEmpty;
    final hasLogo = circle.logoUrl != null && circle.logoUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cover banner with overlapping logo/icon badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      config.tintColor.withValues(alpha: 0.85),
                      config.tintColor.withValues(alpha: 0.6),
                      config.bgTint,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: hasCover
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              circle.coverImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildFallbackBanner(config),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withValues(alpha: 0.4),
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.2),
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ],
                        )
                      : _buildFallbackBanner(config),
                ),
              ),
            ),
            Positioned(
              left: 28,
              bottom: -24,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDark ? AppColor.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColor.darkSurface : Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: hasLogo
                      ? Image.network(
                          circle.logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: config.bgTint,
                            child: Center(
                              child: Icon(config.icon, size: 28, color: config.tintColor),
                            ),
                          ),
                        )
                      : Container(
                          color: config.bgTint,
                          child: Center(
                            child: Icon(config.icon, size: 28, color: config.tintColor),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),

        // Title and meta info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      circle.name,
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusBadge(circle.membershipStatus),
                ],
              ),
              if (circle.category != null && circle.category!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  circle.category!,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 12,
                    color: isDark ? AppColor.darkTextSecondary : const Color(0xFF6B7280),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              _buildMetaRow(isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackBanner(CircleIconConfig config) {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Together for\na Better Tomorrow',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 4),
          Text(
            'Connect • Collaborate • Create Impact',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isPending = status.toLowerCase() == 'pending';
    final bg = isPending ? const Color(0xFFFFFBEB) : const Color(0xFFECFDF5);
    final text = isPending ? const Color(0xFFD97706) : const Color(0xFF059669);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(
        status.isNotEmpty ? status : 'Active',
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500, color: text),
      ),
    );
  }

  Widget _buildMetaRow(bool isDark) {
    final textColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final location = circle.formattedLocation;
    final stage = circle.stage ?? 'Active Circle';

    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: [
        if (location.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_outlined, size: 13, color: textColor),
              const SizedBox(width: 3),
              Text(location, style: AppTypography.labelSmall.copyWith(fontSize: 11, color: textColor)),
            ],
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.stars_rounded, size: 13, color: AppColor.primaryBlue),
            const SizedBox(width: 3),
            Text(stage, style: AppTypography.labelSmall.copyWith(fontSize: 11, color: textColor)),
          ],
        ),
        if (circle.rank != null && circle.rank!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.military_tech_outlined, size: 13, color: const Color(0xFFF59E0B)),
              const SizedBox(width: 3),
              Text('${circle.rank} Circle', style: AppTypography.labelSmall.copyWith(fontSize: 11, color: textColor)),
            ],
          ),
      ],
    );
  }
}
