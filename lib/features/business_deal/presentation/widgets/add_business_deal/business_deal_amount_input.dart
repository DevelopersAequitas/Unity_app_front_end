import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';

class BusinessDealAmountInput extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const BusinessDealAmountInput({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<BusinessDealAmountInput> createState() =>
      _BusinessDealAmountInputState();
}

class _BusinessDealAmountInputState extends State<BusinessDealAmountInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant BusinessDealAmountInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text &&
        widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addAmount(double addValue) {
    final current = double.tryParse(_controller.text.replaceAll(',', '')) ?? 0.0;
    final updated = current + addValue;
    final formatted = updated % 1 == 0
        ? updated.toInt().toString()
        : updated.toStringAsFixed(2);
    _controller.text = formatted;
    widget.onChanged(formatted);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deal Amount (INR)',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColor.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: AppColor.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.lightBorder),
          ),
          child: Row(
            children: [
              Text(
                '₹',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: AppColor.primaryBlue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  onChanged: widget.onChanged,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColor.lightTextPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. 50000',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColor.lightTextTertiary,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Quick amount helper chips
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _buildQuickChip('+₹10K', 10000),
            _buildQuickChip('+₹25K', 25000),
            _buildQuickChip('+₹50K', 50000),
            _buildQuickChip('+₹1 Lakh', 100000),
            _buildQuickChip('+₹5 Lakh', 500000),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickChip(String label, double val) {
    return InkWell(
      onTap: () => _addAmount(val),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColor.primaryBlue.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColor.primaryBlue.withValues(alpha: 0.2),
            width: 0.8,
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColor.primaryBlue,
          ),
        ),
      ),
    );
  }
}
