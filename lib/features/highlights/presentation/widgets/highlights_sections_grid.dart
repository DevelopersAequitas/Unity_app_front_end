import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/highlight_section.dart';
import 'highlights_grid_card.dart';

class HighlightsSectionsGrid extends StatelessWidget {
  final List<HighlightSection> sections;
  final ValueChanged<HighlightSection> onSectionTap;

  const HighlightsSectionsGrid({
    super.key,
    required this.sections,
    required this.onSectionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final crossAxisCount = isTablet ? 6 : 4;
    final cardAspectRatio = isTablet ? 0.90 : 0.82;

    // Group sections by category preserving order
    final categories = <String, List<HighlightSection>>{};
    for (final s in sections) {
      categories.putIfAbsent(s.category, () => []).add(s);
    }

    int globalIndex = 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.entries.map((entry) {
          final categoryTitle = entry.key;
          final items = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (categoryTitle != 'Highlights') ...[
                const SizedBox(height: 18),
                Text(
                  categoryTitle,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 6,
                  childAspectRatio: cardAspectRatio,
                ),
                itemBuilder: (context, index) {
                  final section = items[index];
                  final itemIndex = globalIndex++;
                  return HighlightsGridCard(
                    item: section,
                    index: itemIndex,
                    onTap: () => onSectionTap(section),
                  );
                },
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
