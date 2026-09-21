import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final DioClient _dio = DioClient();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 5;
  String _category = 'General';
  String? _categoryId;
  bool _isSubmitting = false;
  File? _attachment;
  bool _isUploadingAttachment = false;

  List<Map<String, dynamic>> _loadedCategories = [];

  final List<String> _defaultCategories = [
    'General',
    'App Feature',
    'Networking',
    'Bug Report',
    'Suggestion',
  ];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final res = await _dio.dio.get(ApiEndpoints.feedbackCategories);
      final data = res.data;
      List? raw;
      if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is List) {
          raw = inner;
        } else if (inner is Map<String, dynamic>) {
          raw = inner['categories'] as List? ?? inner['items'] as List?;
        }
      } else if (data is List) {
        raw = data;
      }
      if (raw != null && raw.isNotEmpty && mounted) {
        final parsed = raw.whereType<Map<String, dynamic>>().toList();
        setState(() {
          _loadedCategories = parsed;
          if (_loadedCategories.isNotEmpty) {
            _category = _loadedCategories.first['name']?.toString() ?? 'General';
            _categoryId = _loadedCategories.first['id']?.toString();
          }
        });
      }
    } catch (_) {}
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
        return (inner['id'] ?? inner['file_id'] ?? '').toString();
      }
    } catch (_) {}
    if (mounted) setState(() => _isUploadingAttachment = false);
    return null;
  }

  Future<void> _submitFeedback() async {
    final text = _feedbackController.text.trim();
    final subject = _subjectController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write your feedback before submitting.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    String? mediaId;
    if (_attachment != null) {
      mediaId = await _uploadAttachment();
    }

    final payload = {
      'rating': _rating,
      'category': _category,
      if (_categoryId != null && _categoryId!.isNotEmpty) 'category_id': _categoryId,
      if (subject.isNotEmpty) 'subject': subject,
      'feedback': text,
      'question': text,
      'comment': text,
      if (mediaId != null && mediaId.isNotEmpty) 'media': [mediaId],
    };

    try {
      await _dio.dio.post(ApiEndpoints.feedback, data: payload);
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
              child: const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              'Thank You!',
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Your feedback has been received. Thank you for helping us make Peers Global Unity better!',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(color: AppColor.lightTextSecondary),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesList = _loadedCategories.isNotEmpty
        ? _loadedCategories.map((c) => c['name']?.toString() ?? '').where((c) => c.isNotEmpty).toList()
        : _defaultCategories;

    return Scaffold(
      backgroundColor: AppColor.lightScaffoldBg,
      appBar: AppBar(
        title: Text(
          'Submit Feedback',
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColor.brandGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'We value your experience',
                    style: AppTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Help us improve the Unity platform for all entrepreneurs.',
                    style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('HOW WOULD YOU RATE YOUR EXPERIENCE?', style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                return IconButton(
                  icon: Icon(
                    starIndex <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: starIndex <= _rating ? const Color(0xFFF59E0B) : AppColor.lightTextDisabled,
                    size: 36,
                  ),
                  onPressed: () => setState(() => _rating = starIndex),
                );
              }),
            ),
            const SizedBox(height: 24),
            Text('CATEGORY', style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categoriesList.map((cat) {
                final selected = _category == cat;
                return ChoiceChip(
                  label: Text(cat, style: AppTypography.labelSmall.copyWith(color: selected ? Colors.white : AppColor.lightTextPrimary, fontWeight: FontWeight.w500)),
                  selected: selected,
                  selectedColor: AppColor.primaryBlue,
                  backgroundColor: AppColor.lightSurface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onSelected: (v) {
                    if (v) {
                      setState(() {
                        _category = cat;
                        final match = _loadedCategories.where((c) => c['name'] == cat);
                        _categoryId = match.isNotEmpty ? match.first['id']?.toString() : null;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text('SUBJECT (OPTIONAL)', style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _subjectController,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Brief topic of your feedback',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextDisabled),
                filled: true,
                fillColor: AppColor.lightSurface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.lightBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.lightBorder)),
              ),
            ),
            const SizedBox(height: 16),
            Text('YOUR FEEDBACK', style: AppTypography.labelSmall.copyWith(color: AppColor.lightTextSecondary, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Tell us what you liked or how we can do better...',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColor.lightTextDisabled),
                filled: true,
                fillColor: AppColor.lightSurface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.lightBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.lightBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5)),
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
                      height: 130,
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
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColor.lightSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.lightBorder),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.add_photo_alternate_outlined, color: AppColor.primaryBlue, size: 26),
                      const SizedBox(height: 4),
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
                onPressed: (_isSubmitting || _isUploadingAttachment) ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: (_isSubmitting || _isUploadingAttachment)
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Submit Feedback', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


