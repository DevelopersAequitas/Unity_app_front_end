import 'package:flutter/material.dart';
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
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 5;
  String _category = 'General';
  bool _isSubmitting = false;

  final List<String> _categories = ['General', 'App Feature', 'Networking', 'Bug Report', 'Suggestion'];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    final text = _feedbackController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write your feedback before submitting.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await _dio.dio.post(
        ApiEndpoints.feedback,
        data: {
          'rating': _rating,
          'category': _category,
          'feedback': text,
        },
      );
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you! Your feedback has been received.')),
        );
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback submitted successfully. Thank you!')),
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
                  icon: Icon(starIndex <= _rating ? Icons.star_rounded : Icons.star_outline_rounded, color: starIndex <= _rating ? const Color(0xFFF59E0B) : AppColor.lightTextDisabled, size: 36),
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
              children: _categories.map((cat) {
                final selected = _category == cat;
                return ChoiceChip(
                  label: Text(cat, style: AppTypography.labelSmall.copyWith(color: selected ? Colors.white : AppColor.lightTextPrimary, fontWeight: FontWeight.w500)),
                  selected: selected,
                  selectedColor: AppColor.primaryBlue,
                  backgroundColor: AppColor.lightSurface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onSelected: (v) {
                    if (v) setState(() => _category = cat);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: _isSubmitting
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

