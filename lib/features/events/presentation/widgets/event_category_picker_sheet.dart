import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../circles/domain/entities/flat_open_category_item.dart';

class EventCategoryPickerSheet extends StatefulWidget {
  final List<FlatOpenCategoryItem> categories;
  final ValueChanged<FlatOpenCategoryItem> onSelected;

  const EventCategoryPickerSheet({
    super.key,
    required this.categories,
    required this.onSelected,
  });

  @override
  State<EventCategoryPickerSheet> createState() => _EventCategoryPickerSheetState();
}

class _EventCategoryPickerSheetState extends State<EventCategoryPickerSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColor.primaryBlue : AppColor.primaryBlue;

    final q = _searchQuery.trim().toLowerCase();
    final filtered = q.isEmpty
        ? widget.categories
        : widget.categories.where((c) {
            return c.name.toLowerCase().contains(q) ||
                c.sectorName.toLowerCase().contains(q) ||
                (c.subcategoryName ?? '').toLowerCase().contains(q);
          }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select Business Category',
            style: AppTypography.titleMedium.copyWith(
              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search category or sector...',
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: isDark ? AppColor.darkBackground : AppColor.lightBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No categories found',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                    ),
                    itemBuilder: (ctx, idx) {
                      final item = filtered[idx];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          item.name,
                          style: AppTypography.bodyLarge.copyWith(
                            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '${item.sectorName}${item.subcategoryName != null ? ' · ${item.subcategoryName}' : ''}',
                          style: AppTypography.bodySmall.copyWith(
                            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                          ),
                        ),
                        trailing: Icon(Icons.chevron_right_rounded, size: 20, color: primary),
                        onTap: () {
                          Navigator.pop(ctx);
                          widget.onSelected(item);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
