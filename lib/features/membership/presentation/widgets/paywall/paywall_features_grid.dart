import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class PaywallFeaturesGrid extends StatelessWidget {
  const PaywallFeaturesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.white;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final primaryText = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;

    final features = [
      _FeatureItem(
        icon: Icons.chat_bubble_rounded,
        color: const Color(0xFF3B82F6),
        bg: const Color(0xFFEFF6FF),
        title: 'Peer Messaging',
        subtitle: 'Direct 1-on-1 chat with peers',
      ),
      _FeatureItem(
        icon: Icons.groups_rounded,
        color: const Color(0xFF8B5CF6),
        bg: const Color(0xFFF5F3FF),
        title: 'Circle Seat Access',
        subtitle: 'Join exclusive peer circles',
      ),
      _FeatureItem(
        icon: Icons.calendar_month_rounded,
        color: const Color(0xFFEC4899),
        bg: const Color(0xFFFDF2F8),
        title: 'Global Events',
        subtitle: 'Join online & offline sessions',
      ),
      _FeatureItem(
        icon: Icons.description_rounded,
        color: const Color(0xFFF97316),
        bg: const Color(0xFFFFF7ED),
        title: 'Requirements',
        subtitle: 'Post & discover business leads',
      ),
      _FeatureItem(
        icon: Icons.link_rounded,
        color: const Color(0xFF10B981),
        bg: const Color(0xFFECFDF5),
        title: 'Collaborations',
        subtitle: 'Build high-trust partnerships',
      ),
      _FeatureItem(
        icon: Icons.military_tech_rounded,
        color: const Color(0xFFF59E0B),
        bg: const Color(0xFFFEF3C7),
        title: 'Pro Recognition',
        subtitle: 'Featured badge across network',
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 0.8),
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
          Text(
            'Peers Global Pro Benefits',
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14.5,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: features.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 58,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final item = features[index];
              return Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark ? item.color.withValues(alpha: 0.15) : item.bg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(item.icon, color: item.color, size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 11.5,
                            color: primaryText,
                            height: 1.15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 9.5,
                            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                            height: 1.15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final Color color;
  final Color bg;
  final String title;
  final String subtitle;

  _FeatureItem({
    required this.icon,
    required this.color,
    required this.bg,
    required this.title,
    required this.subtitle,
  });
}
