import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class LeadershipRoleFormFields extends StatelessWidget {
  final String? selectedRole;
  final ValueChanged<String?> onRoleChanged;
  final TextEditingController cityController;
  final TextEditingController domainController;
  final TextEditingController whyController;

  static const List<Map<String, String>> roles = [
    {'code': 'DED', 'label': 'District Executive Director (DED)'},
    {'code': 'ID', 'label': 'Industry Director (ID)'},
    {'code': 'CF', 'label': 'Circle Founder (CF)'},
    {'code': 'CD', 'label': 'Circle Director (CD)'},
    {'code': 'CC', 'label': 'Circle Chair / Vice Chair / Secretary'},
    {'code': 'RSL', 'label': 'Regional / State Leadership'},
    {'code': 'GLT', 'label': 'Global Leadership Team'},
  ];

  const LeadershipRoleFormFields({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.cityController,
    required this.domainController,
    required this.whyController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textSecondary =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          initialValue: selectedRole,
          isExpanded: true,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: _decoration('Preferred Leadership Role', Icons.badge_outlined, surfaceColor, borderColor, textSecondary),
          items: roles
              .map((r) => DropdownMenuItem(
                    value: r['code'],
                    child: Text(r['label']!, overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: onRoleChanged,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: cityController,
          style: AppTypography.bodyMedium,
          decoration: _decoration('City / Region of Contribution *', Icons.location_on_outlined, surfaceColor, borderColor, textSecondary),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: domainController,
          style: AppTypography.bodyMedium,
          decoration: _decoration('Primary Domain / Industry Expertise *', Icons.work_outline_rounded, surfaceColor, borderColor, textSecondary),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: whyController,
          maxLines: 3,
          style: AppTypography.bodyMedium,
          decoration: _decoration('Why are you interested in leading?', Icons.lightbulb_outline_rounded, surfaceColor, borderColor, textSecondary),
        ),
      ],
    );
  }

  InputDecoration _decoration(
    String label,
    IconData icon,
    Color surfaceColor,
    Color borderColor,
    Color textSecondary,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTypography.bodyMedium.copyWith(color: textSecondary),
      prefixIcon: Icon(icon, size: 20, color: textSecondary),
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5)),
    );
  }
}
