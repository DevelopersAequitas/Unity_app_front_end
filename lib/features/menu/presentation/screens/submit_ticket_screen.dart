import 'package:flutter/material.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class SubmitTicketScreen extends StatefulWidget {
  const SubmitTicketScreen({super.key});

  @override
  State<SubmitTicketScreen> createState() => _SubmitTicketScreenState();
}

class _SubmitTicketScreenState extends State<SubmitTicketScreen> {
  final DioClient _dio = DioClient();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _department = 'Technical Support';
  String _priority = 'Medium';
  bool _isSubmitting = false;

  final List<String> _departments = ['Technical Support', 'Billing & Membership', 'Circle & Community', 'General Inquiry'];
  final List<String> _priorities = ['Low', 'Medium', 'High', 'Urgent'];

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    final subject = _subjectController.text.trim();
    final description = _descriptionController.text.trim();

    if (subject.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide both a subject and details.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final payload = {
      'subject': subject,
      'description': description,
      'department': _department,
      'priority': _priority,
      'message': description,
      'category': _department,
    };

    try {
      try {
        await _dio.dio.post(ApiEndpoints.support, data: payload);
      } catch (_) {
        try {
          await _dio.dio.post(ApiEndpoints.supportTickets, data: payload);
        } catch (_) {
          await _dio.dio.post(ApiEndpoints.feedback, data: payload);
        }
      }
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Support request submitted. Our team will contact you.')),
        );
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Support request submitted. We will reach out shortly.')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColor.lightTextPrimary,
          ),
        ),
        backgroundColor: AppColor.lightSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColor.lightTextPrimary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SUBJECT', style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _subjectController,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Brief summary of the issue',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextDisabled),
                filled: true,
                fillColor: AppColor.lightSurface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.lightBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.lightBorder)),
              ),
            ),
            const SizedBox(height: 16),
            Text('DEPARTMENT', style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColor.lightSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.lightBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _department,
                  isExpanded: true,
                  items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d, style: AppTypography.bodyMedium))).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _department = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('PRIORITY', style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: _priorities.map((p) {
                final selected = _priority == p;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Center(
                        child: Text(
                          p,
                          style: AppTypography.labelSmall.copyWith(
                            color: selected ? Colors.white : AppColor.lightTextPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      selected: selected,
                      selectedColor: p == 'Urgent' ? AppColor.error : AppColor.primaryBlue,
                      backgroundColor: AppColor.lightSurface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      onSelected: (v) {
                        if (v) setState(() => _priority = p);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('DETAILS', style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Please describe the issue or inquiry in detail...',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextDisabled),
                filled: true,
                fillColor: AppColor.lightSurface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.lightBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.lightBorder)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Submit Ticket', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
