import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/industry.dart';

class IndustryPickerField extends StatefulWidget {
  final List<IndustryParent> industries;
  final Industry? selectedIndustry;
  final ValueChanged<Industry?> onIndustrySelected;

  const IndustryPickerField({
    super.key,
    required this.industries,
    this.selectedIndustry,
    required this.onIndustrySelected,
  });

  @override
  State<IndustryPickerField> createState() => _IndustryPickerFieldState();
}

class _IndustryPickerFieldState extends State<IndustryPickerField> {
  IndustryParent? _selectedParent;

  void _showChildPicker(bool isDark) {
    if (_selectedParent == null || _selectedParent!.children.isEmpty) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Select Specific Industry',
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _selectedParent!.children.length,
                    itemBuilder: (_, index) {
                      final opt = _selectedParent!.children[index];
                      final isSelected = widget.selectedIndustry?.id == opt.id;
                      return ListTile(
                        title: Text(
                          opt.label,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isSelected ? AppColor.primaryBlue : (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary),
                            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                        trailing: isSelected ? const Icon(Icons.check, color: AppColor.primaryBlue) : null,
                        onTap: () {
                          widget.onIndustrySelected(opt);
                          Navigator.pop(sheetContext);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Industry Sector *',
          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500, color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<IndustryParent>(
          isExpanded: true,
          initialValue: _selectedParent,
          dropdownColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          hint: Text('Select industry sector', style: AppTypography.bodyMedium.copyWith(color: (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary).withValues(alpha: 0.6))),
          decoration: _decoration(isDark),
          items: widget.industries.map((p) => DropdownMenuItem(value: p, child: Text(p.name, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: (val) {
            setState(() {
              _selectedParent = val;
              widget.onIndustrySelected(null);
            });
            if (val != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _selectedParent == val) _showChildPicker(isDark);
              });
            }
          },
          validator: (v) => v == null ? 'Please select industry sector' : null,
        ),
        if (_selectedParent != null) ...[
          const SizedBox(height: 14),
          Text(
            'Specific Industry *',
            style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500, color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: () => _showChildPicker(isDark),
            borderRadius: BorderRadius.circular(10),
            child: InputDecorator(
              decoration: _decoration(isDark),
              child: Text(
                widget.selectedIndustry?.label ?? 'Tap to select specific industry',
                style: AppTypography.bodyMedium.copyWith(
                  color: widget.selectedIndustry != null ? (isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary) : (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary).withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _decoration(bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColor.darkBorder : AppColor.lightBorder)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? AppColor.darkBorder : AppColor.lightBorder)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5)),
    );
  }
}
