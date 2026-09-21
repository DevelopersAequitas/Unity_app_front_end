import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/claim_activity_entity.dart';

class ClaimActivityBottomSheet extends StatefulWidget {
  final ClaimActivityEntity activity;

  const ClaimActivityBottomSheet({super.key, required this.activity});

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required ClaimActivityEntity activity,
  }) {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ClaimActivityBottomSheet(activity: activity),
    );
  }

  @override
  State<ClaimActivityBottomSheet> createState() =>
      _ClaimActivityBottomSheetState();
}

class _ClaimActivityBottomSheetState extends State<ClaimActivityBottomSheet> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, DateTime> _dates = {};
  File? _attachedFile;

  @override
  void initState() {
    super.initState();
    for (final field in widget.activity.fields) {
      if (field.type == 'date') {
        _dates[field.key] = DateTime.now();
      } else if (field.type != 'file') {
        _controllers[field.key] = TextEditingController();
      }
    }
    if (_controllers.isEmpty && _dates.isEmpty && widget.activity.fields.isEmpty) {
      _controllers['description'] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final fields = <String, dynamic>{};
    _controllers.forEach((k, v) => fields[k] = v.text.trim());
    _dates.forEach((k, v) => fields[k] = _formatIsoDate(v));

    Navigator.of(context).pop({
      'activity_code': widget.activity.code,
      'fields': fields,
      'proof_file': _attachedFile,
    });
  }

  String _formatIsoDate(DateTime d) => AppDateFormatter.toUtcDateString(d);

  String _formatDisplayDate(DateTime d) => AppDateFormatter.format(d);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.activity.label,
                    style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            if (widget.activity.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                widget.activity.description,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (widget.activity.fields.isEmpty) ...[
              Text('Description / Remarks', style: AppTypography.labelSmall),
              const SizedBox(height: 4),
              _buildTextField(
                controller: _controllers['description']!,
                hintText: 'Enter details of your activity...',
                isDark: isDark,
              ),
            ] else
              ...widget.activity.fields.map((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(field.label, style: AppTypography.labelSmall),
                      const SizedBox(height: 4),
                      if (field.type == 'date')
                        _buildDatePicker(
                          currentDate: _dates[field.key] ?? DateTime.now(),
                          isDark: isDark,
                          onDateSelected: (d) => setState(() => _dates[field.key] = d),
                        )
                      else if (field.type == 'file' ||
                          field.key.contains('proof') ||
                          field.key.contains('file'))
                        _buildFilePicker(isDark: isDark)
                      else
                        _buildTextField(
                          controller: _controllers.putIfAbsent(
                            field.key,
                            () => TextEditingController(),
                          ),
                          hintText: field.placeholder ?? 'Enter ${field.label.toLowerCase()}',
                          isDark: isDark,
                          keyboardType: field.type == 'url'
                              ? TextInputType.url
                              : (field.type == 'phone' || field.key.contains('mobile')
                                  ? TextInputType.phone
                                  : (field.type == 'email' || field.key.contains('email')
                                      ? TextInputType.emailAddress
                                      : TextInputType.text)),
                        ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Submit Claim Request',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E212B) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: AppTypography.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required DateTime currentDate,
    required bool isDark,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    final displayDate = _formatDisplayDate(currentDate);
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onDateSelected(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E212B) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(displayDate, style: AppTypography.bodyMedium),
            const Icon(Icons.calendar_today_outlined, size: 16, color: AppColor.primaryBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePicker({required bool isDark}) {
    if (_attachedFile != null) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E212B) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF059669)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _attachedFile!.path.split(RegExp(r'[/\\]')).last,
                style: AppTypography.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 16),
              onPressed: () => setState(() => _attachedFile = null),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () async {
        final picker = ImagePicker();
        final img = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        );
        if (img != null) {
          setState(() => _attachedFile = File(img.path));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E212B) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.attach_file_rounded, size: 16, color: AppColor.primaryBlue),
            const SizedBox(width: 6),
            Text(
              'Attach Proof File / Receipt',
              style: AppTypography.bodySmall.copyWith(
                color: AppColor.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
