import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import '../utils/app_error_handler.dart';
import '../utils/app_screenshot_manager.dart';
import 'support_prompt_sheet.dart';

/// Common, reusable error view displayed whenever an API, server, or network error occurs.
/// Shows a Retry button and a Help & Support button centered on the screen.
class AppErrorView extends StatelessWidget {
  final String? title;
  final String? message;
  final dynamic error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final String? screenName;
  final bool isCompact;
  final EdgeInsetsGeometry? padding;

  const AppErrorView({
    super.key,
    this.title,
    this.message,
    this.error,
    this.stackTrace,
    this.onRetry,
    this.retryLabel,
    this.screenName,
    this.isCompact = false,
    this.padding,
  });

  Future<void> _handleHelpSupport(BuildContext context) async {
    // Capture screenshot before opening the bottom sheet
    File? screenshotFile;
    try {
      screenshotFile = await AppScreenshotManager.captureScreen();
    } catch (_) {}

    if (context.mounted) {
      await SupportPromptSheet.show(
        context,
        errorMessage: _resolvedMessage,
        originalError: error,
        screenName: screenName,
        screenshotFile: screenshotFile,
      );
    }
  }

  String get _resolvedMessage {
    if (message != null && message!.isNotEmpty) {
      return AppErrorHandler.toUserFriendlyMessage(message);
    }
    if (error != null) {
      return AppErrorHandler.toUserFriendlyMessage(error, stackTrace);
    }
    return 'Unable to load data. Please check your internet connection and try again.';
  }

  @override
  Widget build(BuildContext context) {
    final displayMsg = _resolvedMessage;
    final displayTitle = title ?? 'Unable to Load Data';

    if (isCompact) {
      return Padding(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: AppColor.error,
              ),
              const SizedBox(height: 8),
              Text(
                displayMsg,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColor.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (onRetry != null)
                    OutlinedButton.icon(
                      onPressed: onRetry,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.primaryBlue,
                        side: const BorderSide(color: AppColor.primaryBlue),
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 14),
                      label: Text(retryLabel ?? 'Retry'),
                    ),
                  TextButton.icon(
                    onPressed: () => _handleHelpSupport(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColor.lightTextSecondary,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.help_outline_rounded, size: 14),
                    label: const Text('Help & Support'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon container with subtle soft background
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColor.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 36,
                  color: AppColor.error,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Title
            Text(
              displayTitle,
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColor.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Description
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                displayMsg,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColor.lightTextSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Retry Button
            if (onRetry != null)
              SizedBox(
                width: 200,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: Text(
                    retryLabel ?? 'Retry',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 12),

            // Help & Support Button
            SizedBox(
              width: 200,
              height: 40,
              child: OutlinedButton.icon(
                onPressed: () => _handleHelpSupport(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.lightTextPrimary,
                  side: const BorderSide(color: AppColor.lightBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.help_outline_rounded,
                  size: 16,
                  color: AppColor.primaryBlue,
                ),
                label: Text(
                  'Help & Support',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.lightTextPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
