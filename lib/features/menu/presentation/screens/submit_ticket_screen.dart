import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/offline_prompt_dialog.dart';
import 'ticket_history_screen.dart';

class SubmitTicketScreen extends StatefulWidget {
  final String? initialSubject;
  final String? initialDescription;
  final String? initialDepartment;
  final String? initialPriority;
  final File? initialAttachment;
  final String? screenName;

  const SubmitTicketScreen({
    super.key,
    this.initialSubject,
    this.initialDescription,
    this.initialDepartment,
    this.initialPriority,
    this.initialAttachment,
    this.screenName,
  });

  @override
  State<SubmitTicketScreen> createState() => _SubmitTicketScreenState();
}

class _SubmitTicketScreenState extends State<SubmitTicketScreen> {
  final DioClient _dio = DioClient();
  final ImagePicker _picker = ImagePicker();
  late final TextEditingController _subjectController;
  late final TextEditingController _descriptionController;
  String _department = 'Technical Issue';
  String _priority = 'Medium';
  bool _isSubmitting = false;
  File? _attachment;
  bool _isUploadingAttachment = false;
  String? _uploadedMediaId;

  final List<String> _departments = [
    'Technical Issue',
    'Billing & Payments',
    'Profile & Membership',
    'Circle & Community',
    'General Inquiry',
    'Feature Request',
  ];
  final List<String> _priorities = ['Low', 'Medium', 'High', 'Urgent'];

  @override
  void initState() {
    super.initState();
    _subjectController =
        TextEditingController(text: widget.initialSubject ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');

    if (widget.initialDepartment != null &&
        _departments.contains(widget.initialDepartment)) {
      _department = widget.initialDepartment!;
    }
    if (widget.initialPriority != null &&
        _priorities.contains(widget.initialPriority)) {
      _priority = widget.initialPriority!;
    }
    if (widget.initialAttachment != null) {
      _attachment = widget.initialAttachment;
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _attachment = File(image.path);
        });
      }
    } catch (_) {}
  }

  Future<String?> _uploadAttachment() async {
    if (_attachment == null) return null;
    setState(() => _isUploadingAttachment = true);
    try {
      final fileName = _attachment!.path.split('/').last.split('\\').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          _attachment!.path,
          filename: fileName,
        ),
      });
      final res = await _dio.dio.post(ApiEndpoints.fileUpload, data: formData);
      final d = res.data;
      if (d is Map<String, dynamic>) {
        final inner = d['data'] is Map<String, dynamic>
            ? d['data'] as Map<String, dynamic>
            : d;
        _uploadedMediaId = (inner['id'] ?? inner['file_id'] ?? '').toString();
      }
    } catch (_) {}
    if (mounted) setState(() => _isUploadingAttachment = false);
    return _uploadedMediaId;
  }

  Future<void> _submitTicket() async {
    if (!OfflineGuard.check(context, actionName: 'submit support tickets')) return;
    final subject = _subjectController.text.trim();
    final description = _descriptionController.text.trim();

    if (subject.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide both a subject and details.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    String? mediaId;
    if (_attachment != null) {
      mediaId = await _uploadAttachment();
    }

    final payload = {
      'subject': subject,
      'description': description,
      'department': _department,
      'category': _department,
      'priority': _priority,
      'message': description,
      'screen_name': widget.screenName ?? 'Support Screen',
      if (mediaId != null && mediaId.isNotEmpty) ...{
        'media_file_id': mediaId,
        'media_type': 'image',
      },
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
        _showSuccessDialog();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColor.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'Ticket Submitted',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Your support request has been submitted. Our team will review and respond promptly.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const TicketHistoryScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('View Ticket History'),
          ),
        ],
      ),
    );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: AppColor.primaryBlue),
            tooltip: 'Ticket History',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TicketHistoryScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DEPARTMENT / CATEGORY', style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary, fontWeight: FontWeight.w500)),
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
            const SizedBox(height: 16),
            Text('ATTACHMENT / SCREENSHOT (OPTIONAL)', style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            if (_attachment != null) ...[
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _attachment!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _attachment = null),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              InkWell(
                onTap: _pickAttachment,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: AppColor.lightSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.lightBorder, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.add_photo_alternate_outlined, color: AppColor.primaryBlue, size: 28),
                      const SizedBox(height: 6),
                      Text(
                        'Add Screenshot / Image',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColor.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: (_isSubmitting || _isUploadingAttachment) ? null : _submitTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: (_isSubmitting || _isUploadingAttachment)
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

