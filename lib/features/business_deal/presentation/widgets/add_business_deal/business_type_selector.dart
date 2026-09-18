import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class BusinessTypeSelector extends StatelessWidget {
  final String selectedType; // 'new' or 'repeat'
  final ValueChanged<String> onChanged;

  const BusinessTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isNew = selectedType.toLowerCase() == 'new';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Type',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColor.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                title: 'New Business',
                subtitle: 'First deal with peer',
                isSelected: isNew,
                icon: Icons.fiber_new_rounded,
                activeColor: const Color(0xFF059669),
                activeBg: const Color(0xFF10B981).withValues(alpha: 0.08),
                onTap: () => onChanged('new'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildTypeCard(
                title: 'Repeat Business',
                subtitle: 'Subsequent deal',
                isSelected: !isNew,
                icon: Icons.repeat_rounded,
                activeColor: const Color(0xFF4F46E5),
                activeBg: const Color(0xFF6366F1).withValues(alpha: 0.08),
                onTap: () => onChanged('repeat'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required IconData icon,
    required Color activeColor,
    required Color activeBg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : AppColor.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : AppColor.lightBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withValues(alpha: 0.15)
                    : AppColor.lightSurfaceSubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: isSelected ? activeColor : AppColor.lightTextTertiary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 12.5,
                      color: isSelected ? activeColor : AppColor.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 10,
                      color: AppColor.lightTextTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
