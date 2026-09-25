import 'dart:io';
import 'package:flutter/material.dart';
import '../services/app_update_service.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';

class AppUpdateDialog extends StatelessWidget {
  final AppUpdateResult result;
  final VoidCallback? onDismiss;

  const AppUpdateDialog({
    super.key,
    required this.result,
    this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    required AppUpdateResult result,
    VoidCallback? onDismiss,
  }) {
    final isForce = result.isForceUpdate;
    return showDialog(
      context: context,
      barrierDismissible: !isForce,
      barrierColor: Colors.black.withValues(alpha: isForce ? 0.85 : 0.6),
      builder: (ctx) => AppUpdateDialog(
        result: result,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isForce = result.isForceUpdate;
    final config = result.config;
    final targetVersion = config?.effectiveLatestVersion ?? 'Latest';
    final releaseNotes = config?.releaseNotes.trim() ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColor.darkSurface : Colors.white;
    final textColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final subtitleColor = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return PopScope(
      canPop: !isForce,
      child: Dialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 16,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Icon Badge
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isForce
                        ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                        : [AppColor.primaryBlue, const Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isForce ? const Color(0xFFEF4444) : AppColor.primaryBlue)
                          .withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  isForce ? Icons.system_security_update_rounded : Icons.system_update_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),

              // Title
              Text(
                isForce ? 'Mandatory Update Required' : 'New Update Available',
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),

              // Version Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: (isForce ? const Color(0xFFEF4444) : AppColor.primaryBlue)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'v$targetVersion is now available',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isForce ? const Color(0xFFEF4444) : AppColor.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Description Message
              Text(
                isForce
                    ? 'A critical update is required to continue using Peers Global Unity securely. Please update your application to continue.'
                    : 'A new version of Peers Global Unity is available with improved performance, networking tools, and bug fixes.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: subtitleColor,
                ),
              ),

              // Release Notes Box (if available)
              if (releaseNotes.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxHeight: 140),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColor.darkSurfaceSubtle
                        : AppColor.lightSurfaceSubtle,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                      width: 0.8,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 15,
                              color: isForce ? const Color(0xFFEF4444) : AppColor.primaryBlue,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "What's New:",
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          releaseNotes,
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            color: textColor.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  if (!isForce) ...[
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: BorderSide(
                            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          onDismiss?.call();
                        },
                        child: Text(
                          'Later',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: subtitleColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isForce
                            ? const Color(0xFFEF4444)
                            : AppColor.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        await AppUpdateService.instance.launchStoreUpdate();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Platform.isIOS ? Icons.apple : Icons.shop_rounded,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Update Now',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
