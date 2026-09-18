import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';

/// A reusable, celebratory bottom sheet displayed after actions that award Coins and Impact.
/// Features compact content spacing, white card design with primary-colored metrics,
/// compact row-based action buttons, safe area support, and a soft ambient bluish skyline artwork.
class CommonRewardSheet extends StatelessWidget {
  /// Header title text
  final String title;

  /// Optional header subtitle/description text
  final String? subtitle;

  /// Coins value (int or String, e.g. 5000 or "+5000")
  final dynamic coinsValue;

  /// Custom coins title text (e.g. "+5000 Coins", "50 Points").
  /// If null, auto-formatted from [coinsValue] or [coinsEarned].
  final String? coinsTitle;

  /// Custom coins subtitle text (default: "Reward Earned")
  final String? coinsSubtitle;

  /// Custom coins icon
  final IconData coinsIcon;

  /// Impact value (int or String, e.g. 5 or "+5")
  final dynamic impactValue;

  /// Custom impact title text (e.g. "+5 Impact", "3 Connections").
  /// If null, auto-formatted from [impactValue] or [impactEarned].
  final String? impactTitle;

  /// Custom impact subtitle text (default: "Life Impacted")
  final String? impactSubtitle;

  /// Custom impact icon
  final IconData impactIcon;

  /// Legacy helper for integer coins
  final int? coinsEarned;

  /// Legacy helper for integer impact
  final int? impactEarned;

  /// Explicit toggle to show/hide coins card
  final bool? showCoins;

  /// Explicit toggle to show/hide impact card
  final bool? showImpact;

  /// Optional custom reward widgets to show instead of / in addition to default reward cards
  final List<Widget>? customRewardWidgets;

  /// Optional extra widget to render between the reward cards and action buttons
  final Widget? extraContent;

  /// Primary button label
  final String primaryButtonText;

  /// Secondary button label (optional)
  final String? secondaryButtonText;

  /// Primary button callback
  final VoidCallback onPrimaryTap;

  /// Secondary button callback (optional)
  final VoidCallback? onSecondaryTap;

  /// Top-right close button callback (defaults to [onPrimaryTap])
  final VoidCallback? onCloseTap;

  /// Whether to show the top-right close 'X' button
  final bool showCloseButton;

  /// Whether to show the skyline illustration at the bottom
  final bool showSkyline;

  /// Custom celebration badge or icon widget. If null, displays the animated checkmark badge.
  final Widget? customBadge;

  /// Custom icon inside the default celebration badge
  final IconData badgeIcon;

  const CommonRewardSheet({
    super.key,
    this.title = 'Testimonial Shared!',
    this.subtitle = 'Your words can make a real difference.',
    this.coinsValue,
    this.coinsTitle,
    this.coinsSubtitle = 'Reward Earned',
    this.coinsIcon = Icons.toll_rounded,
    this.impactValue,
    this.impactTitle,
    this.impactSubtitle = 'Life Impacted',
    this.impactIcon = Icons.auto_awesome_rounded,
    this.coinsEarned,
    this.impactEarned,
    this.showCoins,
    this.showImpact,
    this.customRewardWidgets,
    this.extraContent,
    this.primaryButtonText = 'Back to Testimonials',
    this.secondaryButtonText = 'Add Another',
    required this.onPrimaryTap,
    this.onSecondaryTap,
    this.onCloseTap,
    this.showCloseButton = true,
    this.showSkyline = true,
    this.customBadge,
    this.badgeIcon = Icons.check_rounded,
  });

  /// Displays the [CommonRewardSheet] as a modal bottom sheet.
  static Future<T?> show<T>(
    BuildContext context, {
    String title = 'Testimonial Shared!',
    String? subtitle = 'Your words can make a real difference.',
    dynamic coinsValue,
    String? coinsTitle,
    String? coinsSubtitle = 'Reward Earned',
    IconData coinsIcon = Icons.toll_rounded,
    dynamic impactValue,
    String? impactTitle,
    String? impactSubtitle = 'Life Impacted',
    IconData impactIcon = Icons.auto_awesome_rounded,
    int? coinsEarned,
    int? impactEarned,
    bool? showCoins,
    bool? showImpact,
    List<Widget>? customRewardWidgets,
    Widget? extraContent,
    String primaryButtonText = 'Back to Testimonials',
    String? secondaryButtonText = 'Add Another',
    required VoidCallback onPrimaryTap,
    VoidCallback? onSecondaryTap,
    VoidCallback? onCloseTap,
    bool showCloseButton = true,
    bool showSkyline = true,
    Widget? customBadge,
    IconData badgeIcon = Icons.check_rounded,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CommonRewardSheet(
        title: title,
        subtitle: subtitle,
        coinsValue: coinsValue,
        coinsTitle: coinsTitle,
        coinsSubtitle: coinsSubtitle,
        coinsIcon: coinsIcon,
        impactValue: impactValue,
        impactTitle: impactTitle,
        impactSubtitle: impactSubtitle,
        impactIcon: impactIcon,
        coinsEarned: coinsEarned,
        impactEarned: impactEarned,
        showCoins: showCoins,
        showImpact: showImpact,
        customRewardWidgets: customRewardWidgets,
        extraContent: extraContent,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryTap: onPrimaryTap,
        onSecondaryTap: onSecondaryTap,
        onCloseTap: onCloseTap,
        showCloseButton: showCloseButton,
        showSkyline: showSkyline,
        customBadge: customBadge,
        badgeIcon: badgeIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.lightSurface,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFFAFCFF),
            Color(0xFFF0F7FF),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 32,
                  height: 3.5,
                  decoration: BoxDecoration(
                    color: AppColor.lightBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Close 'X' Button on Top Right
              if (showCloseButton)
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 14),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: onCloseTap ?? onPrimaryTap,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColor.lightSurfaceSubtle,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColor.lightBorder.withValues(alpha: 0.6),
                            width: 0.8,
                          ),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: AppColor.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    // Compact Celebration Checkmark Badge / Custom Badge
                    customBadge ?? _buildCelebrationBadge(),

                    const SizedBox(height: 10),

                    // Heading
                    Text(
                      title,
                      style: AppTypography.titleLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.5,
                        color: AppColor.lightTextPrimary,
                        letterSpacing: -0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: AppColor.lightTextTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    const SizedBox(height: 14),

                    // Compact Dynamic Reward Cards (Clean White Cards)
                    _buildRewardsSection(),

                    // Extra Custom Content (if provided)
                    if (extraContent != null) ...[
                      const SizedBox(height: 10),
                      extraContent!,
                    ],

                    const SizedBox(height: 14),

                    // Compact Action Buttons in a Row
                    _buildActionButtonsRow(),

                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // Bottom Skyline Artwork with Soft Ambient Bluish Fade
              if (showSkyline) _buildSkylineFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCelebrationBadge() {
    return SizedBox(
      width: 100,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Radial Glowing Circle
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0F2FE),
                  Color(0xFFD1FAE5),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF38BDF8).withValues(alpha: 0.25),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                badgeIcon,
                size: 30,
                color: const Color(0xFF2563EB),
              ),
            ),
          ),

          // Confetti Dash 1 (Top Left)
          Positioned(
            top: 8,
            left: 16,
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: Container(
                width: 11,
                height: 3.5,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          ),

          // Confetti Dash 2 (Top Right)
          Positioned(
            top: 9,
            right: 16,
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Container(
                width: 11,
                height: 3.5,
                decoration: BoxDecoration(
                  color: const Color(0xFF34D399),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          ),

          // Confetti Dash 3 (Bottom Left)
          Positioned(
            bottom: 9,
            left: 14,
            child: Transform.rotate(
              angle: math.pi / 6,
              child: Container(
                width: 9,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFA78BFA),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          ),

          // Confetti Dash 4 (Bottom Right)
          Positioned(
            bottom: 9,
            right: 14,
            child: Transform.rotate(
              angle: -math.pi / 6,
              child: Container(
                width: 9,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFFF472B6),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsSection() {
    if (customRewardWidgets != null && customRewardWidgets!.isNotEmpty) {
      return Row(
        children: customRewardWidgets!
            .map((w) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: w,
                  ),
                ))
            .toList(),
      );
    }

    bool isNonZero(dynamic val, int? earned) {
      if (earned != null) return earned > 0;
      if (val != null) {
        final str = val.toString().replaceAll('+', '').trim();
        final numVal = int.tryParse(str);
        if (numVal != null) return numVal > 0;
        return str.isNotEmpty && str != '0';
      }
      return false;
    }

    final hasCoins = showCoins ??
        (coinsTitle != null ? coinsTitle!.isNotEmpty : isNonZero(coinsValue, coinsEarned));
    final hasImpact = showImpact ??
        (impactTitle != null ? impactTitle!.isNotEmpty : isNonZero(impactValue, impactEarned));

    if (!hasCoins && !hasImpact) {
      return const SizedBox.shrink();
    }

    // Determine formatted strings
    final finalCoinsTitle = coinsTitle ?? _formatCoinsTitle();
    final finalCoinsSubtitle = coinsSubtitle ?? 'Reward Earned';

    final finalImpactTitle = impactTitle ?? _formatImpactTitle();
    final finalImpactSubtitle = impactSubtitle ?? 'Life Impacted';

    return Row(
      children: [
        if (hasCoins) ...[
          Expanded(
            child: _buildWhiteRewardCard(
              icon: coinsIcon,
              title: finalCoinsTitle,
              subtitle: finalCoinsSubtitle,
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF2563EB),
              borderColor: const Color(0xFFE2E8F0),
            ),
          ),
        ],
        if (hasCoins && hasImpact) const SizedBox(width: 8),
        if (hasImpact) ...[
          Expanded(
            child: _buildWhiteRewardCard(
              icon: impactIcon,
              title: finalImpactTitle,
              subtitle: finalImpactSubtitle,
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF2563EB),
              borderColor: const Color(0xFFE2E8F0),
            ),
          ),
        ],
      ],
    );
  }

  String _formatCoinsTitle() {
    if (coinsValue != null) {
      final str = coinsValue.toString().trim();
      return str.startsWith('+') ? '$str Coins' : '+$str Coins';
    }
    final count = coinsEarned ?? 0;
    return '+$count Coins';
  }

  String _formatImpactTitle() {
    if (impactValue != null) {
      final str = impactValue.toString().trim();
      return str.startsWith('+') ? '$str Impact' : '+$str Impact';
    }
    final count = impactEarned ?? 0;
    return '+$count Impact';
  }

  Widget _buildWhiteRewardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBgColor,
    required Color iconColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: borderColor,
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D4ED8),
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsRow() {
    final hasSecondary = secondaryButtonText != null && onSecondaryTap != null;

    final primaryBtn = SizedBox(
      height: 36,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1D4ED8),
              Color(0xFF3B82F6),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1D4ED8).withValues(alpha: 0.24),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPrimaryTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: AppColor.white,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              primaryButtonText,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.5,
                letterSpacing: 0.1,
                color: AppColor.white,
              ),
            ),
          ),
        ),
      ),
    );

    if (!hasSecondary) {
      return SizedBox(
        width: double.infinity,
        child: primaryBtn,
      );
    }

    final secondaryBtn = SizedBox(
      height: 36,
      child: OutlinedButton(
        onPressed: onSecondaryTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1D4ED8),
          backgroundColor: AppColor.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          side: BorderSide(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.5),
            width: 1.1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            secondaryButtonText!,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.5,
              letterSpacing: 0.1,
              color: Color(0xFF1D4ED8),
            ),
          ),
        ),
      ),
    );

    return Row(
      children: [
        Expanded(child: secondaryBtn),
        const SizedBox(width: 8),
        Expanded(child: primaryBtn),
      ],
    );
  }

  Widget _buildSkylineFooter() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.0),
            const Color(0xFFE0F0FE).withValues(alpha: 0.5),
            const Color(0xFFD0E8FC).withValues(alpha: 0.9),
          ],
        ),
      ),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
            ],
            stops: [0.0, 0.25],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: Image.asset(
            'assets/images/complete_sheet.png',
            width: double.infinity,
            height: 120,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            errorBuilder: (_, _, _) => Image.asset(
              'assets/images/skyline_banner.png',
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
              errorBuilder: (_, _, _) => const SizedBox(height: 20),
            ),
          ),
        ),
      ),
    );
  }
}
