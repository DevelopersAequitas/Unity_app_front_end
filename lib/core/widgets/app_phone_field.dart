import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../features/auth/presentation/widgets/country_code_sheet.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';

/// Formatter that prevents the user from typing or pasting a leading '0'
/// in phone number input fields.
class NoLeadingZeroFormatter extends TextInputFormatter {
  const NoLeadingZeroFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith('0')) {
      final stripped = newValue.text.replaceFirst(RegExp(r'^0+'), '');
      return TextEditingValue(
        text: stripped,
        selection: TextSelection.collapsed(offset: stripped.length),
      );
    }
    return newValue;
  }
}

class AppPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String hintText;
  final String countryCode;
  final String flag;
  final ValueChanged<({String dialCode, String flag})>? onCountryChanged;
  final ValueChanged<String>? onCountryCodeChanged;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final int maxLength;

  const AppPhoneField({
    super.key,
    required this.controller,
    this.label,
    this.hintText = 'Enter phone number',
    this.countryCode = '+91',
    this.flag = '🇮🇳',
    this.onCountryChanged,
    this.onCountryCodeChanged,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.suffixIcon,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.maxLength = 15,
  });

  @override
  State<AppPhoneField> createState() => _AppPhoneFieldState();
}

class _AppPhoneFieldState extends State<AppPhoneField> {
  late String _currentCode;
  late String _currentFlag;

  @override
  void initState() {
    super.initState();
    _currentCode = widget.countryCode;
    _currentFlag = widget.flag.isNotEmpty ? widget.flag : '🌐';
    _sanitizeInitialText();
  }

  @override
  void didUpdateWidget(covariant AppPhoneField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.countryCode != oldWidget.countryCode) {
      _currentCode = widget.countryCode;
    }
    if (widget.flag != oldWidget.flag) {
      _currentFlag = widget.flag.isNotEmpty ? widget.flag : '🌐';
    }
    _sanitizeInitialText();
  }

  void _sanitizeInitialText() {
    if (widget.controller.text.startsWith('0')) {
      final clean = widget.controller.text.replaceFirst(RegExp(r'^0+'), '');
      widget.controller.value = TextEditingValue(
        text: clean,
        selection: TextSelection.collapsed(offset: clean.length),
      );
    }
  }

  Future<void> _openCountryPicker(BuildContext context) async {
    if (!widget.enabled) return;
    final picked = await CountryCodeSheet.show(context, _currentCode);
    if (picked != null && mounted) {
      setState(() {
        _currentCode = picked.dialCode;
        _currentFlag = picked.flag.isNotEmpty ? picked.flag : '🌐';
      });
      if (widget.onCountryChanged != null) {
        widget.onCountryChanged!((
          dialCode: picked.dialCode,
          flag: _currentFlag,
        ));
      }
      if (widget.onCountryCodeChanged != null) {
        widget.onCountryCodeChanged!(picked.dialCode);
      }
    }
  }

  void _handleChanged(String value) {
    String cleanVal = value;
    if (value.startsWith('0')) {
      cleanVal = value.replaceFirst(RegExp(r'^0+'), '');
      widget.controller.value = TextEditingValue(
        text: cleanVal,
        selection: TextSelection.collapsed(offset: cleanVal.length),
      );
    }
    if (widget.onChanged != null) {
      widget.onChanged!(cleanVal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null && widget.label!.isNotEmpty) ...[
          Text(
            widget.label!,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _openCountryPicker(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentFlag,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _currentCode,
                        style: AppTypography.bodyMedium.copyWith(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 1,
                        height: 20,
                        color: borderColor,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  autofocus: widget.autofocus,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  onChanged: _handleChanged,
                  onFieldSubmitted: widget.onSubmitted,
                  validator: widget.validator,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    const NoLeadingZeroFormatter(),
                    LengthLimitingTextInputFormatter(widget.maxLength),
                  ],
                  style: AppTypography.bodyMedium.copyWith(
                    color: primaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColor.darkTextDisabled : AppColor.lightTextDisabled,
                    ),
                    suffixIcon: widget.suffixIcon,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
