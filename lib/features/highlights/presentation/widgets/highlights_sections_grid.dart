import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/highlight_section.dart';
import 'highlights_grid_card.dart';

class HighlightsSectionsGrid extends StatelessWidget {
  final List<HighlightSection> sections;
  final ValueChanged<HighlightSection> onSectionTap;
  final bool isSearching;

  const HighlightsSectionsGrid({
    super.key,
    required this.sections,
    required this.onSectionTap,
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final crossAxisCount = isTablet ? 6 : 4;
    final cardAspectRatio = isTablet ? 0.95 : 0.84;

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
          final isHighlightsCategory = categoryTitle.trim().toLowerCase() == 'highlights';

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isHighlightsCategory && !isSearching) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 2, bottom: 12, top: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 3.5,
                          height: 14,
                          decoration: BoxDecoration(
                            gradient: AppColor.brandGradient,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          categoryTitle,
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isDark ? AppColor.darkTextPrimary : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 8,
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
            ),
          );
        }).toList(),
      ),
    );
  }
}

