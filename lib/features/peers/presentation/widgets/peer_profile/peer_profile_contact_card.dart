import 'package:flutter/material.dart';
import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/core/widgets/app_snack_bar.dart';
import 'package:unity_app/features/profile/domain/entities/profile_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class PeerProfileContactCard extends StatelessWidget {
  final ProfileEntity profile;

  const PeerProfileContactCard({super.key, required this.profile});

  bool get _isFullyVisible {
    final vis = (profile.contactVisibility ?? 'connected_only').toLowerCase();
    if (vis == 'anyone' || vis == 'public' || vis == 'everyone') return true;
    final conn = profile.connectionStatus.toLowerCase();
    return (vis == 'connected_only' || vis == 'connections_only' || vis == 'connections') &&
        (conn == 'connected' || conn == 'approved');
  }

  String _maskEmail(String email) {
    if (_isFullyVisible) return email;
    final parts = email.split('@');
    if (parts.length != 2) return '*****@gmail.com';
    final user = parts[0];
    final visiblePrefix = user.length > 2 ? user.substring(0, 2) : (user.isNotEmpty ? user[0] : '');
    return '$visiblePrefix*****@${parts[1]}';
  }

  String _maskPhone(String phone) {
    if (_isFullyVisible) return phone;
    if (phone.length < 6) return '*****';
    final prefix = phone.length > 5 ? phone.substring(0, phone.length - 6) : '';
    final suffix = phone.substring(phone.length - 2);
    return '$prefix*****$suffix';
  }

  Future<void> _handleAction(BuildContext context, String urlString, String actionName) async {
    if (!_isFullyVisible) {
      AppSnackBar.showInfo(context, 'Connect with ${profile.displayName} to $actionName');
      return;
    }
    final uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) AppSnackBar.showInfo(context, 'Could not open $actionName');
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = profile.email;
    final phone = profile.phone;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.phone_outlined, size: 16, color: AppColor.primaryBlue),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Contact Information',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColor.lightTextPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (email != null && email.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.mail_outline_rounded, size: 15, color: AppColor.lightTextSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _maskEmail(email),
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w400, color: AppColor.lightTextPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _handleAction(context, 'mailto:$email', 'send email'),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image.asset('assets/images/gmail.png', width: 20, height: 20, errorBuilder: (_, _, _) => const Icon(Icons.mail, size: 18, color: AppColor.primaryBlue)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (phone != null && phone.isNotEmpty) ...[
            Row(
              children: [
                const Icon(Icons.phone_in_talk_outlined, size: 15, color: AppColor.lightTextSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _maskPhone(phone),
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w400, color: AppColor.lightTextPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _handleAction(context, 'tel:$phone', 'make a call'),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.phone_rounded, size: 14, color: Color(0xFF10B981)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
