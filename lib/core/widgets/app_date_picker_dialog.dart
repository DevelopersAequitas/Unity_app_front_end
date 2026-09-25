import 'package:flutter/material.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import '../utils/app_date_formatter.dart';
import '../utils/date_input_formatter.dart';

class AppDatePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String title;
  final String? helpText;

  const AppDatePickerDialog({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.title = 'Select Date',
    this.helpText,
  });

  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String title = 'Select Date',
    String? helpText,
  }) {
    return showDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AppDatePickerDialog(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        title: title,
        helpText: helpText,
      ),
    );
  }

  @override
  State<AppDatePickerDialog> createState() => _AppDatePickerDialogState();
}

class _AppDatePickerDialogState extends State<AppDatePickerDialog> {
  late DateTime _selectedDate;
  late DateTime _viewMonth;
  late final DateTime _firstDate;
  late final DateTime _lastDate;

  late final TextEditingController _manualInputController;
  bool _isSelectingYear = false;

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static const List<String> _weekDayLabels = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _firstDate = widget.firstDate ?? DateTime(1930);
    _lastDate = widget.lastDate ?? DateTime(now.year + 10, 12, 31);

    final initial = widget.initialDate ?? now;
    if (initial.isBefore(_firstDate)) {
      _selectedDate = _firstDate;
    } else if (initial.isAfter(_lastDate)) {
      _selectedDate = _lastDate;
    } else {
      _selectedDate = initial;
    }

    _viewMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _manualInputController = TextEditingController(text: _formatSlashDate(_selectedDate));
  }

  @override
  void dispose() {
    _manualInputController.dispose();
    super.dispose();
  }

  String _formatSlashDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _onManualChanged(String value) {
    if (value.trim().length >= 8) {
      final parsed = AppDateFormatter.parseFlexible(value.trim());
      if (parsed != null && !parsed.isBefore(_firstDate) && !parsed.isAfter(_lastDate)) {
        setState(() {
          _selectedDate = parsed;
          _viewMonth = DateTime(parsed.year, parsed.month);
        });
      }
    }
  }

  void _onDaySelected(DateTime day) {
    setState(() {
      _selectedDate = day;
      _viewMonth = DateTime(day.year, day.month);
      _manualInputController.text = _formatSlashDate(day);
    });
  }

  void _previousMonth() {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: AppTypography.titleMedium.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      color: secondaryTextColor,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Manual Input Field with auto-slash
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Type date or select below (DD/MM/YYYY)',
                      style: AppTypography.labelSmall.copyWith(
                        color: secondaryTextColor,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _manualInputController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        DateAutoSlashInputFormatter(),
                      ],
                      onChanged: _onManualChanged,
                      style: AppTypography.bodyMedium.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                      decoration: InputDecoration(
                        hintText: 'DD/MM/YYYY',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColor.darkTextDisabled : AppColor.lightTextDisabled,
                          letterSpacing: 1.2,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        prefixIcon: const Icon(
                          Icons.edit_calendar_rounded,
                          size: 18,
                          color: AppColor.primaryBlue,
                        ),
                        filled: true,
                        fillColor: isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Month / Year Navigation Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => setState(() => _isSelectingYear = !_isSelectingYear),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              '${_monthNames[_viewMonth.month - 1]} ${_viewMonth.year}',
                              style: AppTypography.titleSmall.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _isSelectingYear ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                              size: 20,
                              color: AppColor.primaryBlue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!_isSelectingYear)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left_rounded, size: 22),
                            color: secondaryTextColor,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            onPressed: _viewMonth.isAfter(DateTime(_firstDate.year, _firstDate.month))
                                ? _previousMonth
                                : null,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.chevron_right_rounded, size: 22),
                            color: secondaryTextColor,
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            onPressed: _viewMonth.isBefore(DateTime(_lastDate.year, _lastDate.month))
                                ? _nextMonth
                                : null,
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Year selector grid OR Calendar Days grid
                if (_isSelectingYear)
                  _buildYearGrid(isDark, textColor, secondaryTextColor)
                else
                  _buildCalendarGrid(isDark, textColor, secondaryTextColor),

                const SizedBox(height: 16),

                // Action Buttons (Cancel / Confirm)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          side: BorderSide(color: borderColor),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Cancel',
                          style: AppTypography.labelLarge.copyWith(
                            color: secondaryTextColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColor.brandGradient,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.primaryBlue.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            final parsed = AppDateFormatter.parseFlexible(_manualInputController.text.trim());
                            final dateToReturn = parsed ?? _selectedDate;
                            Navigator.of(context).pop(dateToReturn);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            'Confirm',
                            style: AppTypography.labelLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYearGrid(bool isDark, Color textColor, Color secondaryTextColor) {
    final startYear = _firstDate.year;
    final endYear = _lastDate.year;
    final years = List<int>.generate(endYear - startYear + 1, (i) => endYear - i);

    return SizedBox(
      height: 220,
      child: GridView.builder(
        itemCount: years.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final year = years[index];
          final isSelected = year == _viewMonth.year;

          return InkWell(
            onTap: () {
              setState(() {
                _viewMonth = DateTime(year, _viewMonth.month);
                _isSelectingYear = false;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primaryBlue
                    : (isDark ? AppColor.darkSurfaceSubtle : AppColor.lightSurfaceSubtle),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$year',
                style: AppTypography.bodySmall.copyWith(
                  color: isSelected ? Colors.white : textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendarGrid(bool isDark, Color textColor, Color secondaryTextColor) {
    final firstDayOfMonth = DateTime(_viewMonth.year, _viewMonth.month, 1);
    final daysInMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0, Monday = 1, ...

    final totalCells = startWeekday + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: [
        // Weekday header
        Row(
          children: _weekDayLabels.map((label) {
            return Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: secondaryTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),

        // Days Grid
        SizedBox(
          height: rows * 34.0,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows * 7,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              if (index < startWeekday || index >= startWeekday + daysInMonth) {
                return const SizedBox.shrink();
              }

              final dayNum = index - startWeekday + 1;
              final cellDate = DateTime(_viewMonth.year, _viewMonth.month, dayNum);

              final isSelected = cellDate.year == _selectedDate.year &&
                  cellDate.month == _selectedDate.month &&
                  cellDate.day == _selectedDate.day;

              final isDisabled = cellDate.isBefore(_firstDate) || cellDate.isAfter(_lastDate);

              return InkWell(
                onTap: isDisabled ? null : () => _onDaySelected(cellDate),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '$dayNum',
                      style: AppTypography.bodySmall.copyWith(
                        color: isSelected
                            ? Colors.white
                            : (isDisabled
                                ? (isDark ? AppColor.darkTextDisabled : AppColor.lightTextDisabled)
                                : textColor),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
