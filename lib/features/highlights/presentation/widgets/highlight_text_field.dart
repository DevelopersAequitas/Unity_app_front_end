import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_phone_field.dart';
import '../../../auth/presentation/widgets/country_code_sheet.dart';

class HighlightTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final String countryCode;
  final String countryFlag;
  final ValueChanged<String>? onCountryCodeChanged;

  const HighlightTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.countryCode = '+91',
    this.countryFlag = '🇮🇳',
    this.onCountryCodeChanged,
  });

  @override
  State<HighlightTextField> createState() => _HighlightTextFieldState();
}

class _HighlightTextFieldState extends State<HighlightTextField> {
  late String _dialCode;
  late String _flag;

  @override
  void initState() {
    super.initState();
    _dialCode = widget.countryCode;
    _flag = widget.countryFlag.isNotEmpty ? widget.countryFlag : '🌐';
    _sanitizePhone();
  }

  @override
  void didUpdateWidget(covariant HighlightTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.countryCode != oldWidget.countryCode) {
      _dialCode = widget.countryCode;
    }
    if (widget.countryFlag != oldWidget.countryFlag) {
      _flag = widget.countryFlag.isNotEmpty ? widget.countryFlag : '🌐';
    }
    _sanitizePhone();
  }

  void _sanitizePhone() {
    if (widget.keyboardType == TextInputType.phone && widget.controller.text.startsWith('0')) {
      final clean = widget.controller.text.replaceFirst(RegExp(r'^0+'), '');
      widget.controller.value = TextEditingValue(
        text: clean,
        selection: TextSelection.collapsed(offset: clean.length),
      );
    }
  }

  Future<void> _pickCountry(BuildContext context) async {
    final selected = await CountryCodeSheet.show(context, _dialCode);
    if (selected != null && mounted) {
      setState(() {
        _dialCode = selected.dialCode;
        _flag = selected.flag.isNotEmpty ? selected.flag : '🌐';
      });
      if (widget.onCountryCodeChanged != null) {
        widget.onCountryCodeChanged!(selected.dialCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPhone = widget.keyboardType == TextInputType.phone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          validator: widget.validator,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          inputFormatters: isPhone
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  const NoLeadingZeroFormatter(),
                  LengthLimitingTextInputFormatter(10),
                ]
              : null,
          style: AppTypography.bodyMedium.copyWith(
            color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: (isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary)
                  .withValues(alpha: 0.6),
            ),
            prefixIcon: isPhone
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _pickCountry(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_flag, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 4),
                          Text(
                            _dialCode,
                            style: AppTypography.bodyMedium.copyWith(
                              color: isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 1,
                            height: 18,
                            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
            suffixIcon: widget.suffixIcon,
            filled: true,
            fillColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
