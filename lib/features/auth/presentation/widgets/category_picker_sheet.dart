import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/category_item_entity.dart';

class CategoryPickerSheet extends StatefulWidget {
  final String title;
  final List<CategoryItemEntity> categories;
  final dynamic selectedId;

  const CategoryPickerSheet({
    super.key,
    required this.title,
    required this.categories,
    this.selectedId,
  });

  static Future<CategoryItemEntity?> show(
    BuildContext context, {
    required String title,
    required List<CategoryItemEntity> categories,
    dynamic selectedId,
  }) {
    return showModalBottomSheet<CategoryItemEntity>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => CategoryPickerSheet(
        title: title,
        categories: categories,
        selectedId: selectedId,
      ),
    );
  }

  @override
  State<CategoryPickerSheet> createState() => _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends State<CategoryPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CategoryItemEntity> get _filteredList {
    if (_query.isEmpty) return widget.categories;
    return widget.categories
        .where((item) => item.name.toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final items = _filteredList;

    return Material(
      color: surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.72,
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: AppTypography.titleMedium.copyWith(
                        color: primaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AppTextField(
                  controller: _searchController,
                  hintText: 'Search category...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'No categories found',
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark
                                ? AppColor.darkTextSecondary
                                : AppColor.lightTextSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isSelected = widget.selectedId != null &&
                              (widget.selectedId == item.id ||
                                  (item.isOther && widget.selectedId == 'other'));

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: isSelected
                                      ? AppColor.primaryBlue
                                      : (isDark
                                          ? AppColor.darkBorder
                                          : AppColor.lightBorder),
                                ),
                              ),
                              tileColor: isSelected
                                  ? AppColor.primaryBlue.withValues(alpha: 0.08)
                                  : (isDark
                                      ? AppColor.darkBackground
                                      : Colors.grey.shade50),
                              title: Text(
                                item.name,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: isSelected
                                      ? AppColor.primaryBlue
                                      : primaryTextColor,
                                  fontWeight: isSelected
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColor.primaryBlue,
                                      size: 20,
                                    )
                                  : const Icon(
                                      Icons.chevron_right,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                              onTap: () => Navigator.of(context).pop(item),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
