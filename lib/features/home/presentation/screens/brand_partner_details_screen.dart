import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_common_bar.dart';
import '../../../../core/widgets/app_gradient_background.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../domain/entities/brand_partner_entity.dart';

/// Full-screen details page for a brand partner.
/// Receives a [BrandPartnerEntity] via Navigator push argument.
class BrandPartnerDetailsScreen extends StatefulWidget {
  final BrandPartnerEntity partner;

  const BrandPartnerDetailsScreen({super.key, required this.partner});

  @override
  State<BrandPartnerDetailsScreen> createState() =>
      _BrandPartnerDetailsScreenState();
}

class _BrandPartnerDetailsScreenState extends State<BrandPartnerDetailsScreen> {
  bool _isAboutExpanded = false;

  BrandPartnerEntity get partner => widget.partner;

  // ── Helpers ───────────────────────────────────────────────────────────────────

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _makePhoneCall(String phone) async {
    final clean = phone.replaceAll(RegExp(r'[^\d+]'), '');
    await launchUrl(Uri(scheme: 'tel', path: clean),
        mode: LaunchMode.externalApplication);
  }

  Future<void> _openWhatsApp(String number) async {
    final clean = number.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('https://wa.me/$clean');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _sendEmail(String email) async {
    await launchUrl(Uri(scheme: 'mailto', path: email.trim()),
        mode: LaunchMode.externalApplication);
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    AppSnackBar.showSuccess(context, 'Copied to clipboard!');
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'BP';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppCommonBar(
          title: 'Brand Partner',
          showBack: true,
          onBackTap: () => Navigator.pop(context),
          showSearch: false,
          showChat: false,
          showNotifications: false,
          showProfile: false,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeroCard(context, isDark),
              _buildCoverCard(context, isDark),
              _buildOfferCard(context, isDark),
              _buildAboutCard(context, isDark),
              _buildContactAndLocationCard(context, isDark),
              _buildTermsCard(context, isDark),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Hero Section (Compressed Header) ───────────────────────────────────────────

  Widget _buildHeroCard(BuildContext context, bool isDark) {
    final initials = _getInitials(partner.name);
    final website = partner.websiteUrl?.trim() ?? '';
    final discount = partner.discountValue;
    final discountType = partner.discountType;

    final hasBadges = partner.isFeatured ||
        partner.isSponsored ||
        partner.isVerified ||
        (discount != null && discount > 0);

    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.brandGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryBlue.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: partner.logoUrl != null && partner.logoUrl!.trim().isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: partner.logoUrl!.trim(),
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => _initialsWidget(initials),
                        )
                      : _initialsWidget(initials),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            partner.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (partner.isVerified) ...[
                          const SizedBox(width: 6),
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                              size: 17,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if ((partner.shortDescription ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        partner.shortDescription!.trim(),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (website.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () => _launchUrl(website),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.link_rounded,
                              size: 13,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                website,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white70,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (hasBadges) ...[
            const SizedBox(height: 12),
            // Embedded Badges Row
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (partner.isFeatured)
                  _heroBadge('Featured', Icons.star_rounded, Colors.amber),
                if (partner.isSponsored)
                  _heroBadge('Sponsored', Icons.campaign_rounded, Colors.lightBlueAccent),
                if (partner.isVerified)
                  _heroBadge('Verified Partner', Icons.verified_rounded, const Color(0xFF6EE7B7)),
                if (discount != null && discount > 0)
                  _heroBadge(
                    '${discount.toStringAsFixed(0)}${discountType == 'percentage' ? '%' : '₹'} OFF',
                    Icons.local_offer_rounded,
                    const Color(0xFF34D399),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _heroBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _initialsWidget(String initials) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColor.brandGradient),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  // ── Cover Showcase ─────────────────────────────────────────────────────────────

  Widget _buildCoverCard(BuildContext context, bool isDark) {
    final coverUrl = partner.coverImageUrl?.trim();
    if (coverUrl == null || coverUrl.isEmpty || !coverUrl.startsWith('http')) {
      return const SizedBox.shrink();
    }

    return CachedNetworkImage(
      imageUrl: coverUrl,
      imageBuilder: (context, imageProvider) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      placeholder: (_, _) => const SizedBox.shrink(),
      errorWidget: (_, _, _) => const SizedBox.shrink(),
    );
  }

  // ── Exclusive Offer (Compressed) ───────────────────────────────────────────────

  Widget _buildOfferCard(BuildContext context, bool isDark) {
    final title = partner.offerTitle?.trim();
    final desc = partner.offerDescription?.trim();
    final coupon = partner.couponCode?.trim();
    final discount = partner.discountValue;
    final discountType = partner.discountType;
    final validFrom = _formatDate(partner.validFrom);
    final validTo = _formatDate(partner.validTo);
    final hasOffer = (title != null && title.isNotEmpty) ||
        (coupon != null && coupon.isNotEmpty) || (discount != null && discount > 0);
    if (!hasOffer) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF064E3B).withValues(alpha: 0.5),
                    const Color(0xFF022C22).withValues(alpha: 0.6)
                  ]
                : [const Color(0xFFECFDF5), const Color(0xFFF0FDF4)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? const Color(0xFF059669).withValues(alpha: 0.4)
                : const Color(0xFFA7F3D0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.local_offer_rounded,
                        color: Colors.white, size: 13),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'EXCLUSIVE OFFER',
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                if (discount != null && discount > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${discount.toStringAsFixed(0)}${discountType == 'percentage' ? '%' : '₹'} OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            if (title != null && title.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? const Color(0xFFA7F3D0)
                      : const Color(0xFF065F46),
                ),
              ),
            ],
            if (desc != null && desc.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF6EE7B7)
                      : const Color(0xFF047857),
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
            if (coupon != null && coupon.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColor.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF059669).withValues(alpha: 0.4)
                        : const Color(0xFF6EE7B7),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'COUPON CODE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                            letterSpacing: 0.6,
                          ),
                        ),
                        Text(
                          coupon,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? Colors.white : const Color(0xFF047857),
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _copyToClipboard(context, coupon),
                      icon: const Icon(Icons.copy_rounded, size: 12),
                      label: const Text('Copy'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (validFrom.isNotEmpty || validTo.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 12, color: Color(0xFF059669)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      validFrom.isNotEmpty && validTo.isNotEmpty
                          ? 'Valid: $validFrom – $validTo'
                          : validTo.isNotEmpty
                              ? 'Valid till $validTo'
                              : 'Valid from $validFrom',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF059669),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── About Brand (Compressed with Read More) ───────────────────────────────────

  Widget _buildAboutCard(BuildContext context, bool isDark) {
    final body = partner.description ??
        partner.shortDescription ??
        '${partner.name} is an official verified brand partner of Peers Unity.';
    final isLongText = body.length > 130;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: _card(
        isDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(
                'About the Brand', Icons.info_outline_rounded, isDark),
            const SizedBox(height: 8),
            Text(
              body,
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColor.darkTextSecondary
                    : const Color(0xFF475569),
                height: 1.5,
                fontSize: 12.5,
              ),
              maxLines: _isAboutExpanded ? null : 3,
              overflow: _isAboutExpanded ? null : TextOverflow.ellipsis,
            ),
            if (isLongText) ...[
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () =>
                    setState(() => _isAboutExpanded = !_isAboutExpanded),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isAboutExpanded ? 'Read less' : 'Read more',
                      style: const TextStyle(
                        color: AppColor.primaryBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      _isAboutExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: AppColor.primaryBlue,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Contact & Location (Consolidated into One Section) ──────────────────────────

  Widget _buildContactAndLocationCard(BuildContext context, bool isDark) {
    final address = partner.address ?? '';
    final website = partner.websiteUrl ?? '';
    final email = partner.contactEmail ?? '';
    final phone = partner.contactNumber ?? '';
    final whatsapp = partner.whatsapp ?? '';

    final hasContact = website.isNotEmpty ||
        email.isNotEmpty ||
        phone.isNotEmpty ||
        whatsapp.isNotEmpty;
    final hasAddress = address.isNotEmpty;

    if (!hasContact && !hasAddress) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: _card(
        isDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Contact & Location',
                Icons.connect_without_contact_rounded, isDark),
            if (hasAddress) ...[
              const SizedBox(height: 10),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => _launchUrl(
                      'https://maps.google.com/?q=${Uri.encodeComponent(address)}'),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColor.darkSurfaceSubtle
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? AppColor.darkBorder
                            : const Color(0xFFE2E8F0),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            gradient: AppColor.brandGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.location_on_rounded,
                                color: Colors.white, size: 15),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            address,
                            style: TextStyle(
                              color: isDark
                                  ? AppColor.darkTextPrimary
                                  : const Color(0xFF1E293B),
                              fontSize: 12,
                              height: 1.35,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          Icons.open_in_new_rounded,
                          size: 14,
                          color: isDark
                              ? AppColor.darkTextSecondary
                              : AppColor.primaryBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            if (hasContact) ...[
              const SizedBox(height: 8),
              if (website.isNotEmpty)
                _compactContactRow(
                  isDark,
                  icon: Icons.language_rounded,
                  label: 'Website',
                  value: website,
                  onTap: () => _launchUrl(website),
                ),
              if (email.isNotEmpty)
                _compactContactRow(
                  isDark,
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: email,
                  onTap: () => _sendEmail(email),
                  onLongPress: () => _copyToClipboard(context, email),
                ),
              if (phone.isNotEmpty)
                _compactContactRow(
                  isDark,
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: phone,
                  onTap: () => _makePhoneCall(phone),
                  onLongPress: () => _copyToClipboard(context, phone),
                ),
              if (whatsapp.isNotEmpty)
                _compactContactRow(
                  isDark,
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  value: whatsapp,
                  iconColor: const Color(0xFF25D366),
                  onTap: () => _openWhatsApp(whatsapp),
                  onLongPress: () => _copyToClipboard(context, whatsapp),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _compactContactRow(
    bool isDark, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
    Color? iconColor,
  }) {
    final ic = iconColor ?? AppColor.primaryBlue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.darkSurfaceSubtle
                      : ic.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Icon(icon, color: ic, size: 14)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColor.darkTextSecondary
                            : const Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColor.darkTextPrimary
                            : const Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: isDark
                    ? AppColor.darkTextSecondary
                    : AppColor.lightTextSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Terms & Conditions (Compressed) ───────────────────────────────────────────

  Widget _buildTermsCard(BuildContext context, bool isDark) {
    final terms = partner.termsAndConditions;
    if (terms == null || terms.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: _card(
        isDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Terms & Conditions', Icons.gavel_rounded, isDark),
            const SizedBox(height: 8),
            Text(
              terms,
              style: AppTypography.bodySmall.copyWith(
                color:
                    isDark ? AppColor.darkTextSecondary : const Color(0xFF64748B),
                fontSize: 11.5,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shared Card & Header Widgets ───────────────────────────────────────────────

  Widget _card(bool isDark, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColor.darkBorder : const Color(0xFFE2E8F0),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }

  Widget _sectionHeader(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            gradient: AppColor.brandGradient,
            shape: BoxShape.circle,
          ),
          child: Center(child: Icon(icon, color: Colors.white, size: 14)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColor.darkTextPrimary : const Color(0xFF0F172A),
              fontSize: 14.5,
            ),
          ),
        ),
      ],
    );
  }
}
