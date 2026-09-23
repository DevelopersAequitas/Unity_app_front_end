import 'package:flutter/material.dart';
import '../services/network_connectivity_service.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import 'primary_pill_button.dart';

class OfflineGuard {
  OfflineGuard._();

  /// Checks if the device is currently online.
  /// If offline, displays the premium offline prompt modal and returns `false`.
  /// If online, returns `true` so the action can proceed immediately.
  static bool check(
    BuildContext context, {
    String actionName = 'perform this action',
  }) {
    if (NetworkConnectivityService.instance.isOffline) {
      showOfflinePrompt(context, actionName: actionName);
      return false;
    }
    return true;
  }

  /// Displays the offline prompt dialog.
  static Future<void> showOfflinePrompt(
    BuildContext context, {
    String actionName = 'perform this action',
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => OfflinePromptDialog(actionName: actionName),
    );
  }
}

class OfflinePromptDialog extends StatelessWidget {
  final String actionName;

  const OfflinePromptDialog({
    super.key,
    this.actionName = 'perform this action',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryTextColor =
        isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Material(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColor.error.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 34,
                  color: AppColor.error,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "You're Offline",
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  color: primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please connect to the internet to $actionName. Check your Wi-Fi or mobile data connection and try again.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: secondaryTextColor,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              PrimaryPillButton(
                label: 'Got It',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
