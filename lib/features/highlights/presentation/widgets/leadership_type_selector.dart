import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class LeadershipTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const LeadershipTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
      ),
      child: Row(
        children: [
          _buildSegmentTab('Apply for Myself', 'myself', Icons.person_outline_rounded),
          _buildSegmentTab('Nominate a Peer', 'referring_friend', Icons.group_add_outlined),
        ],
      ),
    );
  }

  Widget _buildSegmentTab(String title, String value, IconData icon) {
    final isSelected = selectedType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTypeChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : AppColor.lightTextSecondary),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected ? Colors.white : AppColor.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
