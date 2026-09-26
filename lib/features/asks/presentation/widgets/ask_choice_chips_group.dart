import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/ask_form_config_entity.dart';

class AskChoiceChipsGroup extends StatelessWidget {
  final AskOptionGroupEntity group;
  final Set<String> selectedCodes;
  final void Function(String code) onOptionToggled;

  const AskChoiceChipsGroup({
    super.key,
    required this.group,
    required this.selectedCodes,
    required this.onOptionToggled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final chipBg = isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.name,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: group.options.map((option) {
            final isSelected = selectedCodes.contains(option.code);

            return Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              elevation: 0,
              child: InkWell(
                onTap: () => onOptionToggled(option.code),
                borderRadius: BorderRadius.circular(20),
                splashColor: AppColor.primaryBlue.withValues(alpha: 0.15),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6.5),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColor.brandGradient : null,
                    color: isSelected ? null : chipBg,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: borderColor,
                            width: 0.8,
                          ),
                  ),
                  child: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.white : titleColor,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
