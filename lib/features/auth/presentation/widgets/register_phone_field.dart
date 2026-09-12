import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import 'country_code_sheet.dart';

class RegisterPhoneField extends StatefulWidget {
  final TextEditingController controller;
  final String countryCode;
  final ValueChanged<String>? onCountryCodeChanged;
  final ValueChanged<String>? onChanged;

  const RegisterPhoneField({
    super.key,
    required this.controller,
    this.countryCode = '+91',
    this.onCountryCodeChanged,
    this.onChanged,
  });

  @override
  State<RegisterPhoneField> createState() => _RegisterPhoneFieldState();
}

class _RegisterPhoneFieldState extends State<RegisterPhoneField> {
  bool _hasPromptedHint = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _triggerPhoneHintOnce();
    }
  }

  void _triggerPhoneHintOnce() {
    if (!_hasPromptedHint && widget.controller.text.isEmpty) {
      _hasPromptedHint = true;
      _requestNativePhoneHint();
    }
  }

  Future<void> _openCountryPicker(BuildContext context) async {
    final picked = await CountryCodeSheet.show(context, widget.countryCode);
    if (picked != null && widget.onCountryCodeChanged != null) {
      widget.onCountryCodeChanged!(picked.dialCode);
    }
  }

  Future<void> _requestNativePhoneHint() async {
    try {
      final phone = await SmsAutoFill().hint;
      if (phone != null && phone.isNotEmpty && mounted) {
        var clean = phone.replaceAll(RegExp(r'\D'), '');
        final dialDigits = widget.countryCode.replaceAll(RegExp(r'\D'), '');
        if (dialDigits.isNotEmpty && clean.startsWith(dialDigits)) {
          clean = clean.substring(dialDigits.length);
        }
        clean = clean.replaceFirst(RegExp(r'^0+'), '');
        widget.controller.value = TextEditingValue(
          text: clean,
          selection: TextSelection.collapsed(offset: clean.length),
        );
        if (widget.onChanged != null) {
          widget.onChanged!(clean);
        }
      }
    } catch (_) {}
  }

  void _onPhoneChanged(String val) {
    String cleanVal = val;
    if (val.startsWith('0')) {
      cleanVal = val.replaceFirst(RegExp(r'^0+'), '');
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

    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.phone_outlined, size: 20, color: Color(0xFF64748B)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _openCountryPicker(context),
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.countryCode,
                  style: AppTypography.bodyLarge.copyWith(
                    color: isDark
                        ? AppColor.darkTextPrimary
                        : AppColor.lightTextPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: Color(0xFF64748B),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 1,
            height: 24,
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onTap: _triggerPhoneHintOnce,
              autofillHints: const [
                AutofillHints.telephoneNumber,
                AutofillHints.telephoneNumberNational,
                AutofillHints.telephoneNumberDevice,
              ],
              onChanged: _onPhoneChanged,
              style: AppTypography.bodyLarge.copyWith(
                color: isDark
                    ? AppColor.darkTextPrimary
                    : AppColor.lightTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Phone number',
                hintStyle: AppTypography.bodyLarge.copyWith(
                  color: isDark
                      ? AppColor.darkTextDisabled
                      : AppColor.lightTextDisabled,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
