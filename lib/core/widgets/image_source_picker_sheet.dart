import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';

class ImageSourcePickerSheet extends StatelessWidget {
  final String sheetTitle;
  final String sheetSubtitle;

  const ImageSourcePickerSheet({
    super.key,
    this.sheetTitle = 'Select Photo',
    this.sheetSubtitle = 'Choose a source to upload your photo',
  });

  static Future<XFile?> show(
    BuildContext context, {
    String sheetTitle = 'Select Photo',
    String sheetSubtitle = 'Choose a source to upload your photo',
    String cropperTitle = 'Crop Photo',
    CropAspectRatio aspectRatio = const CropAspectRatio(ratioX: 1, ratioY: 1),
    CropStyle cropStyle = CropStyle.rectangle,
    CropAspectRatioPreset initAspectRatio = CropAspectRatioPreset.square,
    List<CropAspectRatioPreset> aspectRatioPresets = const [
      CropAspectRatioPreset.square,
    ],
    bool lockAspectRatio = true,
    int maxWidth = 1600,
    int maxHeight = 1600,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => ImageSourcePickerSheet(
        sheetTitle: sheetTitle,
        sheetSubtitle: sheetSubtitle,
      ),
    );

    if (source != null) {
      try {
        final picker = ImagePicker();
        final picked = await picker.pickImage(
          source: source,
          imageQuality: 90,
          maxWidth: maxWidth.toDouble(),
          maxHeight: maxHeight.toDouble(),
        );
        if (picked == null) return null;

        final cropped = await ImageCropper().cropImage(
          sourcePath: picked.path,
          compressQuality: 88,
          aspectRatio: aspectRatio,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: cropperTitle,
              toolbarColor: isDark ? AppColor.darkSurface : AppColor.primaryBlue,
              toolbarWidgetColor: Colors.white,
              activeControlsWidgetColor: AppColor.primaryBlue,
              initAspectRatio: initAspectRatio,
              lockAspectRatio: lockAspectRatio,
              cropStyle: cropStyle,
              hideBottomControls: false,
              aspectRatioPresets: aspectRatioPresets,
            ),
            IOSUiSettings(
              title: cropperTitle,
              doneButtonTitle: 'Done',
              cancelButtonTitle: 'Cancel',
              cropStyle: cropStyle,
              aspectRatioLockEnabled: lockAspectRatio,
              resetAspectRatioEnabled: false,
              aspectRatioPickerButtonHidden: lockAspectRatio,
              resetButtonHidden: false,
              rotateButtonsHidden: false,
              rotateClockwiseButtonHidden: false,
              aspectRatioPresets: aspectRatioPresets,
            ),
          ],
        );

        if (cropped != null) {
          return XFile(cropped.path);
        }
        return null;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static Future<XFile?> showProfilePhotoCropper(BuildContext context) {
    return show(
      context,
      sheetTitle: 'Select Profile Photo',
      sheetSubtitle: 'Choose a source to upload your profile photo',
      cropperTitle: 'Crop Profile Photo (1:1 Square)',
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      cropStyle: CropStyle.circle,
      initAspectRatio: CropAspectRatioPreset.square,
      aspectRatioPresets: const [CropAspectRatioPreset.square],
      lockAspectRatio: true,
      maxWidth: 1200,
      maxHeight: 1200,
    );
  }

  static Future<XFile?> showCoverPhotoCropper(BuildContext context) {
    return show(
      context,
      sheetTitle: 'Select Cover Banner Photo',
      sheetSubtitle: 'Choose a source to upload your cover banner',
      cropperTitle: 'Crop Cover Photo (3:1 Banner)',
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 1),
      cropStyle: CropStyle.rectangle,
      initAspectRatio: CropAspectRatioPreset.ratio16x9,
      aspectRatioPresets: const [
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.original,
      ],
      lockAspectRatio: true,
      maxWidth: 1920,
      maxHeight: 1080,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: secondaryTextColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                sheetTitle,
                style: AppTypography.titleMedium.copyWith(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                sheetSubtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                context: context,
                icon: Icons.camera_alt_outlined,
                title: 'Take Photo',
                subtitle: 'Use camera to take a new picture',
                source: ImageSource.camera,
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                context: context,
                icon: Icons.photo_library_outlined,
                title: 'Choose from Gallery',
                subtitle: 'Select an existing image from gallery',
                source: ImageSource.gallery,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required ImageSource source,
    required bool isDark,
  }) {
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(source),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColor.primaryBlue.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColor.primaryBlue, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                        color: primaryTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: secondaryTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: secondaryTextColor.withValues(alpha: 0.6),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
