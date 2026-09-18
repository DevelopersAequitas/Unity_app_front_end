import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/image_source_picker_sheet.dart';

class TestimonialPhotoPicker extends StatelessWidget {
  final File? imageFile;
  final ValueChanged<File?> onImageChanged;

  const TestimonialPhotoPicker({
    super.key,
    required this.imageFile,
    required this.onImageChanged,
  });

  Future<void> _pickPhoto(BuildContext context) async {
    final picked = await ImageSourcePickerSheet.show(
      context,
      sheetTitle: 'Attach Photo',
      sheetSubtitle: 'Select a photo to include with your testimonial',
    );
    if (picked != null) {
      onImageChanged(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Photo (Optional)',
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColor.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        if (imageFile == null)
          InkWell(
            onTap: () => _pickPhoto(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColor.lightSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColor.primaryBlue.withValues(alpha: 0.35),
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.image_outlined,
                      size: 22,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add Image',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.5,
                      color: AppColor.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'JPG, PNG (Max 5MB)',
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 10.5,
                      color: AppColor.lightTextTertiary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  imageFile!,
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => onImageChanged(null),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColor.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
