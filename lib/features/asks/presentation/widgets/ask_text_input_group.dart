import 'package:flutter/material.dart';

class AskTextInputGroup extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final int maxLines;

  const AskTextInputGroup({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final fillBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final hintColor = isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: fillBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 0.8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: titleColor,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: hintColor,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: maxLines > 1 ? 10 : 12),
            ),
          ),
        ),
      ],
    );
  }
}
