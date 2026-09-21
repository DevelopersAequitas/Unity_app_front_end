import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/event_entity.dart';

class EventDetailHeaderImage extends StatelessWidget {
  final EventEntity event;
  final VoidCallback? onShareTap;

  const EventDetailHeaderImage({
    super.key,
    required this.event,
    this.onShareTap,
  });

  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
  ];

  String _formatCategory(String cat) {
    if (cat.isEmpty) return 'Summit';
    final formatted = cat.replaceAll('_', ' ');
    return formatted.split(' ').map((w) {
      if (w.isEmpty) return '';
      return w[0].toUpperCase() + w.substring(1).toLowerCase();
    }).join(' ');
  }

  String _formatMode(String mode) {
    if (mode.toLowerCase().contains('online') ||
        mode.toLowerCase().contains('virtual')) {
      return 'Online';
    }
    return 'In-Person';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dt = event.startAt;

    final dayStr = dt != null ? dt.day.toString().padLeft(2, '0') : '--';
    final monthStr = dt != null
        ? '${_months[dt.month - 1]} ${dt.year}'
        : '';
    final hasImage =
        event.imageUrl != null && event.imageUrl!.trim().isNotEmpty;

    final categoryStr = _formatCategory(event.eventCategory);
    final modeStr = _formatMode(event.mode);

    // Only show category/mode if non-empty and not 'null' / 'one_time'
    final showCategory = categoryStr.isNotEmpty &&
        categoryStr.toLowerCase() != 'null' &&
        categoryStr.toLowerCase() != 'none';
    final showMode = modeStr.isNotEmpty &&
        modeStr.toLowerCase() != 'null' &&
        modeStr.toLowerCase() != 'none' &&
        modeStr.toLowerCase() != 'one_time' &&
        modeStr.toLowerCase() != 'one time';

    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full-width hero image
          hasImage
              ? CachedNetworkImage(
                  imageUrl: event.imageUrl!.trim(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildPlaceholder(isDark),
                  errorWidget: (context, error, stackTrace) =>
                      _buildPlaceholder(isDark),
                )
              : _buildPlaceholder(isDark),

          // Bottom gradient scrim
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 130,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.68),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Overlay row: Date badge + pills + share button
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Date badge (white card)
                Container(
                  width: 58,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dayStr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFE11D48),
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        monthStr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Category pill — only if real value
                if (showCategory) ...[
                  _overlayPill(
                    categoryStr,
                    const Color(0xFF2563EB),
                    const Color(0xFFEFF6FF),
                  ),
                  const SizedBox(width: 8),
                ],

                // Mode pill — only if real value
                if (showMode)
                  _overlayPill(
                    modeStr,
                    const Color(0xFF475569),
                    const Color(0xFFF1F5F9),
                  ),

                const Spacer(),

                // Share button
                GestureDetector(
                  onTap: onShareTap,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? AppColor.darkSurface : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.share_outlined,
                      size: 19,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _overlayPill(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_seat_rounded, size: 48, color: Colors.white54),
            const SizedBox(height: 8),
            Text(
              event.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
