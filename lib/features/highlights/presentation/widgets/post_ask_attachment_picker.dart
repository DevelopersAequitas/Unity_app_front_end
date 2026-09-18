import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class PostAskAttachmentPicker extends StatelessWidget {
  final File? selectedImage;
  final ValueChanged<File?> onImageSelected;
  final bool isUploading;

  const PostAskAttachmentPicker({
    super.key,
    required this.selectedImage,
    required this.onImageSelected,
    this.isUploading = false,
  });

  Future<void> _pick(BuildContext context, ImageSource source) async {
    Navigator.pop(context);
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        final file = File(picked.path);
        onImageSelected(file);
      }
    } catch (_) {}
  }

  void _showPickerModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColor.primaryBlue),
              title: Text('Choose from Gallery', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w400)),
              onTap: () => _pick(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColor.primaryBlue),
              title: Text('Take a Photo', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w400)),
              onTap: () => _pick(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (selectedImage != null) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isDark ? AppColor.darkBorder : AppColor.lightBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(selectedImage!, width: 56, height: 56, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Attachment Selected', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(
                    '${(selectedImage!.lengthSync() / 1024).toStringAsFixed(1)} KB',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, color: AppColor.error, size: 20),
              onPressed: () => onImageSelected(null),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: isUploading ? null : () => _showPickerModal(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.attach_file_rounded, color: AppColor.primaryBlue, size: 20),
            const SizedBox(width: 8),
            Text(
              'Attach Document / Image (Optional)',
              style: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            const Icon(Icons.add_photo_alternate_outlined, color: AppColor.primaryBlue, size: 18),
          ],
        ),
      ),
    );
  }
}
