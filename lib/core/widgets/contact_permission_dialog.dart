import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/contacts_sync_service.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import 'primary_pill_button.dart';

class ContactPermissionDialog extends StatelessWidget {
  const ContactPermissionDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const ContactPermissionDialog(),
    );
    return result ?? false;
  }

  Future<void> _onAllow(BuildContext context) async {
    final status = await Permission.contacts.request();
    if (context.mounted) {
      Navigator.of(context).pop(status.isGranted);
    }
    if (status.isGranted) {
      ContactsSyncService.instance.syncAddressBookInBackground();
    }
  }

  void _onDeny(BuildContext context) {
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final primaryTextColor = isDark
        ? AppColor.darkTextPrimary
        : AppColor.lightTextPrimary;
    final secondaryTextColor = isDark
        ? AppColor.darkTextSecondary
        : AppColor.lightTextSecondary;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Material(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.contacts_rounded,
                  size: 32,
                  color: AppColor.primaryBlue,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Sync Your Contacts',
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  color: primaryTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'To easily connect with your peers and network across the platform, allow Peers Unity access to your contacts.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: secondaryTextColor,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your contacts are encrypted and securely synced to link your network.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: secondaryTextColor.withValues(alpha: 0.75),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
              PrimaryPillButton(
                label: 'Continue',
                onPressed: () => _onAllow(context),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _onDeny(context),
                child: Text(
                  'Not now',
                  style: AppTypography.bodyMedium.copyWith(
                    color: secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
