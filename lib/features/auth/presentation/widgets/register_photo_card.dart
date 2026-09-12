import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class RegisterPhotoCard extends StatelessWidget {
  final String? photoPath;
  final VoidCallback onTap;

  const RegisterPhotoCard({super.key, this.photoPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final secondaryColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;
    final hasPhoto = photoPath != null && photoPath!.isNotEmpty;
    final photoFile = hasPhoto ? File(photoPath!) : null;
    final fileExists = photoFile != null && photoFile.existsSync();

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasPhoto
                ? AppColor.primaryBlue
                : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
            width: hasPhoto ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: hasPhoto
                        ? AppColor.primaryBlue.withValues(alpha: 0.15)
                        : AppColor.primaryBlue.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: hasPhoto
                          ? AppColor.primaryBlue
                          : AppColor.primaryBlue.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: fileExists
                        ? Image.file(
                            photoFile,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.person_rounded,
                              size: 26,
                              color: AppColor.primaryBlue,
                            ),
                          )
                        : Icon(
                            hasPhoto
                                ? Icons.check_circle_rounded
                                : Icons.person_rounded,
                            size: 26,
                            color: hasPhoto
                                ? AppColor.primaryBlue
                                : const Color(0xFF94A3B8),
                          ),
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: hasPhoto
                          ? AppColor.primaryBlue
                          : AppColor.primaryPink,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColor.darkSurface : Colors.white,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      hasPhoto ? Icons.edit_rounded : Icons.add_rounded,
                      size: 11,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: hasPhoto
                          ? 'Profile photo selected'
                          : 'Add profile photo',
                      style: AppTypography.titleMedium.copyWith(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        if (!hasPhoto)
                          const TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: AppColor.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasPhoto
                        ? 'Tap to change or crop photo'
                        : 'Upload a clear picture of yourself.',
                    style: AppTypography.bodySmall.copyWith(
                      color: hasPhoto ? AppColor.primaryBlue : secondaryColor,
                      fontSize: 12,
                      fontWeight: hasPhoto
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (hasPhoto)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColor.primaryBlue,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
