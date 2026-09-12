import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/brand_partner_entity.dart';

/// Full-width banner carousel for brand partners.
///
/// - Single partner: shows one static banner
/// - Multiple: horizontal PageView with auto-advance every 4 s
/// - Each card shows the cover image, logo, partner name, offer badge,
///   coupon code, and a "Visit" CTA
class HomeBrandPartnersSection extends StatefulWidget {
  final List<BrandPartnerEntity> brandPartners;
  final void Function(BrandPartnerEntity partner)? onPartnerTap;

  const HomeBrandPartnersSection({
    super.key,
    required this.brandPartners,
    this.onPartnerTap,
  });

  @override
  State<HomeBrandPartnersSection> createState() => _HomeBrandPartnersSectionState();
}

class _HomeBrandPartnersSectionState extends State<HomeBrandPartnersSection> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Start at a random page so each app launch shows a different partner
    _currentPage = widget.brandPartners.isNotEmpty
        ? DateTime.now().millisecondsSinceEpoch % widget.brandPartners.length
        : 0;
    _pageController = PageController(initialPage: _currentPage);
    if (widget.brandPartners.length > 1) _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % widget.brandPartners.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.brandPartners.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColor.darkTextPrimary : AppColor.lightTextPrimary;
    final partners = widget.brandPartners;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Brand Partners',
                style: AppTypography.titleMedium.copyWith(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (partners.length > 1)
                Row(
                  children: List.generate(partners.length, (i) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(left: 4),
                      width: _currentPage == i ? 16 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentPage == i
                            ? AppColor.primaryBlue
                            : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: partners.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: index == partners.length - 1 ? 16 : 8,
                ),
                child: _BrandBannerCard(
                  partner: partners[index],
                  isDark: isDark,
                  onTap: () => widget.onPartnerTap?.call(partners[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BrandBannerCard extends StatelessWidget {
  final BrandPartnerEntity partner;
  final bool isDark;
  final VoidCallback? onTap;

  const _BrandBannerCard({required this.partner, required this.isDark, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColor.darkSurface : const Color(0xFFF8F9FF);
    final borderColor = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final hasImage = partner.coverImageUrl != null && partner.coverImageUrl!.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover image
            if (hasImage)
              CachedNetworkImage(
                imageUrl: partner.coverImageUrl!,
                fit: BoxFit.cover,
                memCacheWidth: 720,
                errorWidget: (_, _, _) => _PlaceholderBg(isDark: isDark),
              )
            else
              _PlaceholderBg(isDark: isDark),

            // Dark gradient overlay bottom
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.72),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.35, 1.0],
                  ),
                ),
              ),
            ),

            // Sponsored badge top-right
            if (partner.isSponsored)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColor.primaryBlue.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Sponsored',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColor.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            // Bottom content row
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Logo
                    _LogoCircle(logoUrl: partner.logoUrl, isDark: isDark),
                    const SizedBox(width: 10),
                    // Name + offer
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            partner.name,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColor.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (partner.offerTitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              partner.offerTitle!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColor.white.withValues(alpha: 0.85),
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Coupon badge
                    if (partner.couponCode != null) ...[
                      const SizedBox(width: 8),
                      _CouponBadge(code: partner.couponCode!),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoCircle extends StatelessWidget {
  final String? logoUrl;
  final bool isDark;
  const _LogoCircle({this.logoUrl, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final hasLogo = logoUrl != null && logoUrl!.isNotEmpty;
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? AppColor.darkSurface : AppColor.white,
        border: Border.all(color: AppColor.white.withValues(alpha: 0.5), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasLogo
          ? CachedNetworkImage(
              imageUrl: logoUrl!,
              fit: BoxFit.cover,
              memCacheWidth: 120,
              errorWidget: (_, _, _) => const Icon(Icons.business_outlined, size: 20, color: AppColor.primaryBlue),
            )
          : const Icon(Icons.business_outlined, size: 20, color: AppColor.primaryBlue),
    );
  }
}

class _CouponBadge extends StatelessWidget {
  final String code;
  const _CouponBadge({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.primaryPink.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.white.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        code,
        style: AppTypography.labelSmall.copyWith(
          color: AppColor.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _PlaceholderBg extends StatelessWidget {
  final bool isDark;
  const _PlaceholderBg({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E222D), const Color(0xFF2A2F3D)]
              : [const Color(0xFFEFF3FF), const Color(0xFFDDE3F8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.business_center_outlined,
          size: 48,
          color: AppColor.primaryBlue.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
