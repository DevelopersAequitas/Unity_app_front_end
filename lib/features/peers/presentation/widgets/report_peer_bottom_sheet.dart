import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_snack_bar.dart';

/// A bottom sheet for reporting a peer/user with radio reason selection and optional detail field.
class ReportPeerBottomSheet extends StatefulWidget {
  final String peerName;

  const ReportPeerBottomSheet({super.key, required this.peerName});

  static Future<void> show(BuildContext context, {required String peerName}) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ReportPeerBottomSheet(peerName: peerName),
    );
  }

  @override
  State<ReportPeerBottomSheet> createState() => _ReportPeerBottomSheetState();
}

class _ReportPeerBottomSheetState extends State<ReportPeerBottomSheet> {
  String? _selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  bool _isSubmitting = false;

  static const List<String> _reportReasons = [
    'Spam or Fake Account',
    'Harassment or Hate Speech',
    'Inappropriate Content',
    'Impersonation',
    'Something Else',
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkSurface : Colors.white;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              // Handle bar
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
              const SizedBox(height: 16),

              // Title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.flag_outlined, color: AppColor.error, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Report User',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: secondaryTextColor, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 6),
              Text(
                'Why are you reporting ${widget.peerName}? Your feedback helps keep Peers safe.',
                style: AppTypography.bodySmall.copyWith(color: secondaryTextColor, height: 1.4),
              ),
              const SizedBox(height: 12),

              // Radio options
              ..._reportReasons.map((reason) {
                final isSelected = _selectedReason == reason;
                return GestureDetector(
                  onTap: () => setState(() => _selectedReason = reason),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.error.withValues(alpha: 0.6)
                            : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      color: isSelected
                          ? AppColor.error.withValues(alpha: 0.05)
                          : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColor.error : secondaryTextColor,
                              width: isSelected ? 0 : 1.5,
                            ),
                            color: isSelected ? AppColor.error : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 11, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            reason,
                            style: AppTypography.bodySmall.copyWith(
                              color: primaryTextColor,
                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 4),

              // Additional details field
              TextField(
                controller: _detailsController,
                maxLines: 3,
                minLines: 2,
                style: AppTypography.bodySmall.copyWith(color: primaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Add more details (optional)...',
                  hintStyle: AppTypography.bodySmall.copyWith(color: secondaryTextColor),
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
                    borderSide: const BorderSide(color: AppColor.error),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),

              const SizedBox(height: 20),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          if (_selectedReason == null) {
                            AppSnackBar.showInfo(context, 'Please select a reason to report');
                            return;
                          }
                          setState(() => _isSubmitting = true);
                          await Future.delayed(const Duration(milliseconds: 500));
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          AppSnackBar.showSuccess(
                            context,
                            'Report submitted. Thank you for keeping Peers safe!',
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.error,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColor.error.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Submit Report',
                          style: AppTypography.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
