import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/utils/app_date_formatter.dart';

class DealDatePickerField extends StatelessWidget {
  final String dealDate; // 'YYYY-MM-DD'
  final ValueChanged<String> onDateSelected;

  const DealDatePickerField({
    super.key,
    required this.dealDate,
    required this.onDateSelected,
  });

  Future<void> _pickDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    try {
      if (dealDate.isNotEmpty) {
        initialDate = DateTime.parse(dealDate);
      }
    } catch (_) {}

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primaryBlue,
              onPrimary: AppColor.white,
              onSurface: AppColor.lightTextPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final yyyy = picked.year.toString().padLeft(4, '0');
      final mm = picked.month.toString().padLeft(2, '0');
      final dd = picked.day.toString().padLeft(2, '0');
      onDateSelected('$yyyy-$mm-$dd');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = dealDate.isNotEmpty
        ? AppDateFormatter.format(dealDate, defaultValue: dealDate)
        : 'Select deal date';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deal Date',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColor.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickDate(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: AppColor.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.lightBorder),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColor.primaryBlue,
                ),
                const SizedBox(width: 10),
                Text(
                  displayDate,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightTextPrimary,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 22,
                  color: AppColor.lightTextTertiary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
