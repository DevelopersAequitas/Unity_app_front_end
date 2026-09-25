import 'package:flutter/material.dart';
import '../../../../core/services/app_update_service.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_update_dialog.dart';

class ProfileAppVersionTile extends StatefulWidget {
  final bool isCard;

  const ProfileAppVersionTile({
    super.key,
    this.isCard = true,
  });

  @override
  State<ProfileAppVersionTile> createState() => _ProfileAppVersionTileState();
}

class _ProfileAppVersionTileState extends State<ProfileAppVersionTile> {
  String _currentVersion = '...';
  String _buildNumber = '';
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    final ver = await AppUpdateService.instance.getCurrentVersion();
    final build = await AppUpdateService.instance.getBuildNumber();
    if (mounted) {
      setState(() {
        _currentVersion = ver;
        _buildNumber = build;
      });
    }
  }

  Future<void> _handleCheckUpdate() async {
    if (_isChecking) return;

    setState(() => _isChecking = true);
    try {
      final result = await AppUpdateService.instance.checkUpdate();
      if (!mounted) return;

      if (result.isForceUpdate || result.isOptionalUpdate) {
        AppUpdateDialog.show(context, result: result);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "You're using the latest version (v$_currentVersion)",
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColor.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            content: const Text(
              'Unable to check for updates. Please check your internet connection.',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColor.darkSurface : AppColor.lightSurface;
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final textPrimary = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final textSecondary = isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary;

    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColor.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.phone_android_rounded,
              color: AppColor.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'App Version',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _buildNumber.isNotEmpty
                      ? 'v$_currentVersion (Build $_buildNumber)'
                      : 'v$_currentVersion',
                  style: TextStyle(
                    fontSize: 13,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _isChecking ? null : _handleCheckUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: const Size(0, 34),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: _isChecking
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh_rounded, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Check',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );

    if (!widget.isCard) return content;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 0.8),
      ),
      child: content,
    );
  }
}
