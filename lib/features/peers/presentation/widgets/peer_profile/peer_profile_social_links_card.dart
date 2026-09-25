import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_snack_bar.dart';
import '../../../../profile/domain/entities/profile_entity.dart';

/// Displays clickable social link icon buttons on a peer's profile.
/// Renders nothing if the peer has no social links set.
class PeerProfileSocialLinksCard extends StatelessWidget {
  final ProfileEntity profile;

  const PeerProfileSocialLinksCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final links = profile.socialLinks;

    // Build active links list
    final activeLinks = <Map<String, dynamic>>[];

    void addIfValid(String platform, String? value, Widget icon, String prefix) {
      if (value == null || value.trim().isEmpty) return;
      String url = value.trim();
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        if (url.contains('.') && !url.startsWith('@')) {
          url = 'https://$url';
        } else {
          final handle = url.startsWith('@') ? url.substring(1) : url;
          url = '$prefix$handle';
        }
      }
      activeLinks.add({'platform': platform, 'url': url, 'icon': icon});
    }

    addIfValid(
      'LinkedIn',
      links?.linkedin,
      const FaIcon(FontAwesomeIcons.linkedin, color: Color(0xFF0A66C2), size: 20),
      'https://linkedin.com/in/',
    );
    addIfValid(
      'Instagram',
      links?.instagram,
      const FaIcon(FontAwesomeIcons.instagram, color: Color(0xFFE1306C), size: 20),
      'https://instagram.com/',
    );
    addIfValid(
      'Facebook',
      links?.facebook,
      const FaIcon(FontAwesomeIcons.facebook, color: Color(0xFF1877F2), size: 20),
      'https://facebook.com/',
    );
    addIfValid(
      'Twitter / X',
      links?.twitter,
      const FaIcon(FontAwesomeIcons.xTwitter, color: Colors.black87, size: 19),
      'https://x.com/',
    );
    addIfValid(
      'YouTube',
      links?.youtube,
      const FaIcon(FontAwesomeIcons.youtube, color: Color(0xFFFF0000), size: 20),
      'https://youtube.com/@',
    );
    addIfValid(
      'Website',
      links?.website ?? profile.businessWebsite,
      const Icon(Icons.language_rounded, color: AppColor.primaryBlue, size: 21),
      'https://',
    );

    if (activeLinks.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.link_rounded, size: 15, color: AppColor.primaryBlue),
              const SizedBox(width: 6),
              Text(
                'Social Connections',
                style: AppTypography.labelSmall.copyWith(
                  color: isDark ? AppColor.darkTextSecondary : AppColor.lightTextSecondary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: activeLinks.map((link) {
              return Tooltip(
                message: link['platform'] as String,
                child: GestureDetector(
                  onTap: () => _launchUrl(context, link['url'] as String, link['platform'] as String),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? AppColor.darkBackground : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: link['icon'] as Widget,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String urlString, String label) async {
    try {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch';
      }
    } catch (_) {
      if (context.mounted) {
        AppSnackBar.showInfo(context, 'Could not open $label');
      }
    }
  }
}
