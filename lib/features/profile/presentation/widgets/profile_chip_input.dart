import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

class ProfileChipInput extends StatelessWidget {
  final String label;
  final List<String> items;
  final ValueChanged<List<String>> onChanged;
  final String hintText;
  final Color accentColor;

  const ProfileChipInput({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.hintText = 'Add item',
    this.accentColor = AppColor.primary,
  });

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusMd)),
          title: Text('Add $label', style: AppTypography.titleSmall),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusSm)),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                final updated = List<String>.from(items)..add(value.trim());
                onChanged(updated);
                Navigator.of(dialogContext).pop();
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  final updated = List<String>.from(items)..add(controller.text.trim());
                  onChanged(updated);
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
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
              label,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
            InkWell(
              onTap: () => _showAddDialog(context),
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Row(
                  children: [
                    Icon(Icons.add_rounded, size: 14, color: accentColor),
                    const SizedBox(width: 2),
                    Text(
                      'Add',
                      style: AppTypography.labelSmall.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColor.backgroundSubtle,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: AppColor.borderSubtle),
          ),
          constraints: const BoxConstraints(minHeight: 48),
          child: items.isEmpty
              ? GestureDetector(
                  onTap: () => _showAddDialog(context),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Text(
                      'Tap "+ Add" to add $label',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColor.textTertiary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                )
              : Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: items.map((item) {
                    return Container(
                      padding: const EdgeInsets.only(left: 8, right: 4, top: 2, bottom: 2),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                        border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              final updated = List<String>.from(items)..remove(item);
                              onChanged(updated);
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: accentColor.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
