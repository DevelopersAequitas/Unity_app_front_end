import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/circle_entity.dart';
import '../circle_icon_helper.dart';

class CircleDetailAbout extends StatefulWidget {
  final CircleEntity circle;

  const CircleDetailAbout({super.key, required this.circle});

  @override
  State<CircleDetailAbout> createState() => _CircleDetailAboutState();
}

class _CircleDetailAboutState extends State<CircleDetailAbout> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = CircleIconHelper.getCategoryConfig(widget.circle.category, widget.circle.circleKey);
    final cardBg = isDark ? AppColor.darkSurface : Colors.white;
    final borderColor = isDark
        ? AppColor.darkBorder
        : config.tintColor.withValues(alpha: 0.18);

    final defaultAbout =
        'The ${widget.circle.name} brings together professionals, leaders, and service providers on one platform. It creates opportunities to build trusted connections, exchange knowledge, generate referrals, and explore business collaborations.';
    final text = (widget.circle.description != null && widget.circle.description!.isNotEmpty)
        ? widget.circle.description!
        : defaultAbout;

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
                    child: Icon(Icons.info_outline_rounded, size: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'About Circle',
                  style: AppTypography.titleSmall.copyWith(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12.5,
                color: isDark ? AppColor.darkTextSecondary : const Color(0xFF4B5563),
                height: 1.5,
              ),
              maxLines: _isExpanded ? null : 4,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (text.length > 180) ...[
              const SizedBox(height: 6),
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isExpanded ? 'Read less' : 'Read more',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColor.primaryBlue,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.5,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: AppColor.primaryBlue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

