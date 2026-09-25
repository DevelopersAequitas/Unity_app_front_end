import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_phone_field.dart';
import '../../../../core/widgets/app_text_field.dart';
import 'country_code_sheet.dart';

class LoginPhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final String dialCode;
  final String flag;
  final ValueChanged<({String dialCode, String flag})> onCountryChanged;
  final VoidCallback onSubmitted;

  const LoginPhoneInput({
    super.key,
    required this.controller,
    required this.dialCode,
    required this.flag,
    required this.onCountryChanged,
    required this.onSubmitted,
  });

  Future<void> _pickCountry(BuildContext context) async {
    final selected = await CountryCodeSheet.show(context, dialCode);
    if (selected != null) {
      onCountryChanged((
        dialCode: selected.dialCode,
        flag: selected.flag.isNotEmpty ? selected.flag : '🌐',
      ));
    }
  }

  void _onChanged(String val) {
    if (val.startsWith('0')) {
      final clean = val.replaceFirst(RegExp(r'^0+'), '');
      controller.value = TextEditingValue(
        text: clean,
        selection: TextSelection.collapsed(offset: clean.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return AppTextField(
      controller: controller,
      hintText: 'Phone number',
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      onChanged: _onChanged,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        const NoLeadingZeroFormatter(),
        LengthLimitingTextInputFormatter(10),
      ],
      onSubmitted: (_) => onSubmitted(),
      prefixIcon: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _pickCountry(context),
        child: Padding(
          padding: const EdgeInsets.only(left: 14, right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                flag.isNotEmpty ? flag : '🌐',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 6),
              Text(
                dialCode,
                style: AppTypography.bodyMedium.copyWith(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: secondaryTextColor,
              ),
              const SizedBox(width: 8),
              Container(
                height: 20,
                width: 1,
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
