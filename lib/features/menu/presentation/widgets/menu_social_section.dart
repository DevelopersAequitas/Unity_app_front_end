import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class MenuSocialSection extends StatelessWidget {
  const MenuSocialSection({super.key});

  static const String _linkedinUrl = 'https://www.linkedin.com/company/peersglobal';
  static const String _instagramUrl = 'https://www.instagram.com/peersglobal';
  static const String _facebookUrl = 'https://www.facebook.com/PeersGlobalCommunity';
  static const String _websiteUrl = 'https://www.peersglobal.com';

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'CONNECT WITH US',
          style: AppTypography.labelSmall.copyWith(
            color: AppColor.lightTextDisabled,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialBtn(
              icon: FontAwesomeIcons.linkedinIn,
              color: const Color(0xFF0A66C2),
              onTap: () => _openUrl(_linkedinUrl),
            ),
            const SizedBox(width: 16),
            _buildSocialBtn(
              icon: FontAwesomeIcons.instagram,
              color: const Color(0xFFE1306C),
              onTap: () => _openUrl(_instagramUrl),
            ),
            const SizedBox(width: 16),
            _buildSocialBtn(
              icon: FontAwesomeIcons.facebookF,
              color: const Color(0xFF1877F2),
              onTap: () => _openUrl(_facebookUrl),
            ),
          ],
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _openUrl(_websiteUrl),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              'www.peersglobal.com',
              style: AppTypography.bodySmall.copyWith(
                color: AppColor.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialBtn({
    required dynamic icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColor.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.lightBorder),
        ),
        child: Center(
          child: FaIcon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
