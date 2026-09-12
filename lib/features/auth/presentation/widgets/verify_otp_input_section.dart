import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class VerifyOtpInputSection extends StatefulWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final ValueChanged<String>? onCompleted;

  const VerifyOtpInputSection({
    super.key,
    required this.controllers,
    required this.focusNodes,
    this.onCompleted,
  });

  @override
  State<VerifyOtpInputSection> createState() => _VerifyOtpInputSectionState();
}

class _VerifyOtpInputSectionState extends State<VerifyOtpInputSection> {
  @override
  void initState() {
    super.initState();
    for (final node in widget.focusNodes) {
      node.addListener(_onFocusChange);
    }
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final node in widget.focusNodes) {
      node.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (value.length > 1) {
        final digits = value.replaceAll(RegExp(r'\D'), '');
        for (int i = 0; i < 4 && i < digits.length; i++) {
          widget.controllers[i].text = digits[i];
        }
        if (digits.length >= 4) {
          widget.focusNodes[3].unfocus();
          widget.onCompleted?.call(digits.substring(0, 4));
        }
        setState(() {});
        return;
      }
      if (index < 3) {
        widget.focusNodes[index + 1].requestFocus();
      } else {
        widget.focusNodes[index].unfocus();
        final otp = widget.controllers.map((c) => c.text).join();
        if (otp.length == 4) {
          widget.onCompleted?.call(otp);
        }
      }
    }
    setState(() {});
  }

  void _onBackKey(int index) {
    if (widget.controllers[index].text.isEmpty && index > 0) {
      widget.controllers[index - 1].clear();
      widget.focusNodes[index - 1].requestFocus();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        final isFocused = widget.focusNodes[index].hasFocus;
        final isFilled = widget.controllers[index].text.isNotEmpty;
        final borderColor = isFocused
            ? AppColor.primaryBlue
            : (isFilled
                  ? AppColor.primaryBlue.withValues(alpha: 0.6)
                  : (isDark ? AppColor.darkBorder : AppColor.lightBorder));

        return Focus(
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.backspace) {
              _onBackKey(index);
            }
            return KeyEventResult.ignored;
          },
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
              border: Border.all(
                color: borderColor,
                width: isFocused ? 1.8 : 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: widget.controllers[index],
              focusNode: widget.focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: AppTypography.titleLarge.copyWith(
                color: textColor,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (val) => _onChanged(val, index),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
                counterText: '',
              ),
            ),
          ),
        );
      }),
    );
  }
}
