import 'package:flutter/material.dart';
import 'package:unity_app/core/widgets/app_snack_bar.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/primary_pill_button.dart';
import '../../../circles/domain/entities/flat_open_category_item.dart';

class EventRequestBottomSheet extends StatefulWidget {
  final bool isVisitor;
  final String? initialCity;
  final FlatOpenCategoryItem? selectedCategory;
  final VoidCallback? onSelectCategory;
  final Function(String reason, String couponCode) onSubmit;

  const EventRequestBottomSheet({
    super.key,
    this.isVisitor = false,
    this.initialCity,
    this.selectedCategory,
    this.onSelectCategory,
    required this.onSubmit,
  });

  @override
  State<EventRequestBottomSheet> createState() =>
      _EventRequestBottomSheetState();
}

class _EventRequestBottomSheetState extends State<EventRequestBottomSheet> {
  final _reasonController = TextEditingController();
  final _couponController = TextEditingController();
  String? _reasonError;

  @override
  void dispose() {
    _reasonController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  void _submit() {
    final reason = _reasonController.text.trim();
    if (widget.isVisitor && widget.selectedCategory == null) {
      AppSnackBar.showError(context, 'Please select your business category');
      return;
    }
    if (reason.isEmpty) {
      setState(() {
        _reasonError = 'Reason for attending is required';
      });
      AppSnackBar.showError(context, 'Please enter a reason for attending');
      return;
    }
    final coupon = _couponController.text.trim();
    Navigator.pop(context);
    widget.onSubmit(reason, coupon);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColor.primaryBlue;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.isVisitor
                    ? 'Register as Visitor'
                    : 'Request to Attend Event',
                style: AppTypography.titleMedium.copyWith(
                  color: isDark
                      ? AppColor.darkTextPrimary
                      : AppColor.lightTextPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Submit a request for admin approval or apply a coupon code to join instantly.',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColor.darkTextSecondary
                      : AppColor.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 16),
              // Category Picker if visitor (not own circle)
              if (widget.isVisitor) ...[
                Text(
                  'Your Business Category *',
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark
                        ? AppColor.darkTextSecondary
                        : AppColor.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: widget.onSelectCategory,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColor.darkBackground
                          : AppColor.lightBackground,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? AppColor.darkBorder
                            : AppColor.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.category_outlined, size: 18, color: primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.selectedCategory?.name ??
                                'Select your category in this circle',
                            style: AppTypography.bodyLarge.copyWith(
                              color: widget.selectedCategory != null
                                  ? (isDark
                                        ? AppColor.darkTextPrimary
                                        : AppColor.lightTextPrimary)
                                  : (isDark
                                        ? AppColor.darkTextSecondary
                                        : AppColor.lightTextSecondary),
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              // Reason Input (Required)
              Text(
                'Reason for Attending *',
                style: AppTypography.labelSmall.copyWith(
                  color: isDark
                      ? AppColor.darkTextSecondary
                      : AppColor.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _reasonController,
                maxLines: 2,
                onChanged: (_) {
                  if (_reasonError != null) {
                    setState(() => _reasonError = null);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'e.g. Exploring business collaborations...',
                  errorText: _reasonError,
                  filled: true,
                  fillColor: isDark
                      ? AppColor.darkBackground
                      : AppColor.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColor.darkBorder
                          : AppColor.lightBorder,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 12),
              // Coupon Code Input
              Text(
                'Have a Coupon Code?',
                style: AppTypography.labelSmall.copyWith(
                  color: isDark
                      ? AppColor.darkTextSecondary
                      : AppColor.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _couponController,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Enter coupon code (e.g. PEERSVIP)',
                  prefixIcon: const Icon(
                    Icons.confirmation_number_outlined,
                    size: 18,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? AppColor.darkBackground
                      : AppColor.lightBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColor.darkBorder
                          : AppColor.lightBorder,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Submit Button
              PrimaryPillButton(
                label: _couponController.text.trim().isNotEmpty
                    ? 'Apply & Join'
                    : 'Submit Request',
                onPressed: _submit,
                gradient: AppColor.brandGradient,
                showArrow: false,
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
