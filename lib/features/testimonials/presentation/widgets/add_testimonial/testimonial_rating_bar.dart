import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class TestimonialRatingBar extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const TestimonialRatingBar({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  void _calculateAndSetRating(Offset localPosition, double totalWidth) {
    if (totalWidth <= 0) return;
    final starWidth = totalWidth / 5;
    final clampedX = localPosition.dx.clamp(0.0, totalWidth);
    final calculatedRating = ((clampedX / starWidth).ceil()).clamp(1, 5);
    if (calculatedRating != rating) {
      HapticFeedback.selectionClick();
      onRatingChanged(calculatedRating);
    }
  }

  String _getRatingText(int r) {
    switch (r) {
      case 1:
        return '1.0 · Needs Improvement';
      case 2:
        return '2.0 · Fair';
      case 3:
        return '3.0 · Good';
      case 4:
        return '4.0 · Very Good';
      case 5:
        return '5.0 · Outstanding';
      default:
        return 'Tap or swipe across stars to rate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rating (Optional)',
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: AppColor.lightTextPrimary,
              ),
            ),
            if (rating > 0)
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onRatingChanged(0);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'Clear',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.primaryBlue,
                      fontWeight: FontWeight.w500,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Swipeable & Tappable Stars Bar
        LayoutBuilder(
          builder: (context, constraints) {
            // Keep total bar width comfortable for easy finger dragging
            final maxBarWidth = 5 * 52.0;
            final barWidth = constraints.maxWidth < maxBarWidth
                ? constraints.maxWidth
                : maxBarWidth;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) =>
                  _calculateAndSetRating(details.localPosition, barWidth),
              onPanDown: (details) =>
                  _calculateAndSetRating(details.localPosition, barWidth),
              onPanUpdate: (details) =>
                  _calculateAndSetRating(details.localPosition, barWidth),
              child: SizedBox(
                width: barWidth,
                height: 52,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    final starNumber = index + 1;
                    final isFilled = starNumber <= rating;

                    return AnimatedScale(
                      scale: isFilled ? 1.12 : 1.0,
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOutBack,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          isFilled
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 38,
                          color: isFilled
                              ? const Color(0xFFF59E0B)
                              : AppColor.lightBorder,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 3),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            _getRatingText(rating),
            key: ValueKey<int>(rating),
            style: AppTypography.labelSmall.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: rating > 0
                  ? const Color(0xFFD97706)
                  : AppColor.lightTextTertiary,
            ),
          ),
        ),
      ],
    );
  }
}
