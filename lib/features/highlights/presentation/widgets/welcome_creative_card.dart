import 'dart:io';
import 'package:flutter/material.dart';

/// Renders the dynamic Welcome Creative card for onboarding / member celebrations.
///
/// Coordinate calculations and layer stacking maintain exact proportions on any
/// screen density using a fixed 1122x1402 (0.80028) aspect ratio.
class WelcomeCreativeCard extends StatelessWidget {
  final String memberName;
  final String? cityName;
  final String? companyName;
  final String? designation;
  final String? category;
  final String? subCategory;
  final String? avatarUrl;
  final String? templateBackgroundUrl;
  final bool showLogo;
  final bool isCompletedCreative;

  const WelcomeCreativeCard({
    super.key,
    required this.memberName,
    this.cityName,
    this.companyName,
    this.designation,
    this.category,
    this.subCategory,
    this.avatarUrl,
    this.templateBackgroundUrl,
    this.showLogo = false,
    this.isCompletedCreative = false,
  });

  /// High-fidelity natural graphic template URL (1122 x 1402)
  static const String defaultTemplateUrl =
      'https://peersunity.com/storage/uploads/2026/05/27/d806d2e9-05ae-427a-9359-026ea10d7f64.webp';

  @override
  Widget build(BuildContext context) {
    final String backgroundUrl =
        (templateBackgroundUrl != null && templateBackgroundUrl!.isNotEmpty)
        ? templateBackgroundUrl!
        : defaultTemplateUrl;

    if (isCompletedCreative) {
      return AspectRatio(
        aspectRatio: 1122 / 1402,
        child: Image.network(
          backgroundUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFF002F6C),
            alignment: Alignment.center,
            child: const Text(
              'Welcome to Peers Global',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1122 / 1402,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double cardWidth = constraints.maxWidth;
          final double cardHeight = cardWidth * 1402 / 1122;

          // Calculated ring coordinates
          final double avatarDiameter = cardWidth * 0.392;
          final double avatarLeft = cardWidth * 0.503 - (avatarDiameter / 2);
          final double avatarTop = cardHeight * 0.5133 - (avatarDiameter / 2);

          final String cityCompanyText = _buildCityCompanyLine();

          final bool hasCategory =
              (category != null && category!.trim().isNotEmpty) ||
              (subCategory != null && subCategory!.trim().isNotEmpty);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // ─── Layer 1: Base Template ──────────────────────────────────
              Positioned.fill(
                child: Image.network(
                  backgroundUrl,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF002F6C),
                    alignment: Alignment.center,
                    child: const Text(
                      'Welcome to Peers Global',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: Color(0xFF002F6C),
                        strokeWidth: 2,
                      ),
                    );
                  },
                ),
              ),

              // ─── Layer 2: Dynamic User Avatar ────────────────────────────
              Positioned(
                left: avatarLeft,
                top: avatarTop,
                width: avatarDiameter,
                height: avatarDiameter,
                child: _buildAvatar(
                  imageUrl: avatarUrl,
                  name: memberName,
                  diameter: avatarDiameter,
                ),
              ),

              // ─── Layer 4: User Details Column ────────────────────────────
              Positioned(
                left: cardWidth * 0.06,
                right: cardWidth * 0.06,
                top: cardHeight * 0.708,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. Peer Name
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _formatWithHyphenation(memberName),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF002F6C),
                          fontWeight: FontWeight.w800,
                          fontSize: cardWidth * 0.046,
                          letterSpacing: 0.6,
                          height: 1.15,
                        ),
                      ),
                    ),

                    // 2. Below Peer Name: City • Company Name (with character limit)
                    if (cityCompanyText.isNotEmpty) ...[
                      SizedBox(height: cardHeight * 0.004),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          cityCompanyText,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF616161),
                            fontWeight: FontWeight.w600,
                            fontSize: cardWidth * 0.027,
                            letterSpacing: 0.3,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],

                    // 3. Split Brand Divider
                    SizedBox(height: cardHeight * 0.007),
                    _buildSplitBrandDivider(cardWidth * 0.45),
                    SizedBox(height: cardHeight * 0.007),

                    // 4. Below Divider: Business Category / Subcategory in Brand Gradient Color
                    if (hasCategory) ...[
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: _buildGradientCategoryText(cardWidth: cardWidth),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAvatar({
    required String? imageUrl,
    required String name,
    required double diameter,
  }) {
    final bool isNetwork =
        imageUrl != null &&
        imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipOval(
        child: isNetwork
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildInitialsAvatar(name, diameter),
              )
            : (imageUrl != null &&
                      imageUrl.isNotEmpty &&
                      File(imageUrl).existsSync()
                  ? Image.file(
                      File(imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          _buildInitialsAvatar(name, diameter),
                    )
                  : _buildInitialsAvatar(name, diameter)),
      ),
    );
  }

  Widget _buildInitialsAvatar(String name, double diameter) {
    final initials = _getInitials(name);
    return Container(
      width: diameter,
      height: diameter,
      color: const Color(0xFF002F6C),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: diameter * 0.36,
        ),
      ),
    );
  }

  Widget _buildSplitBrandDivider(double width) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 1.2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0xFF002F6C)],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 4.5,
            height: 4.5,
            decoration: const BoxDecoration(
              color: Color(0xFFB22222),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Container(
              height: 1.2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB22222), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildCityCompanyLine({int maxChars = 36}) {
    final parts = <String>[];
    if (cityName != null && cityName!.trim().isNotEmpty) {
      parts.add(cityName!.trim());
    }
    if (companyName != null && companyName!.trim().isNotEmpty) {
      parts.add(companyName!.trim());
    } else if (designation != null && designation!.trim().isNotEmpty) {
      parts.add(designation!.trim());
    }

    String result = parts.join(' • ').toUpperCase();
    if (result.length > maxChars) {
      result = '${result.substring(0, maxChars - 3).trim()}...';
    }
    return result;
  }

  Widget _buildGradientCategoryText({
    required double cardWidth,
    int maxChars = 30,
  }) {
    final cat = (category != null && category!.trim().isNotEmpty)
        ? category!.trim()
        : subCategory?.trim();

    if (cat == null || cat.isEmpty) return const SizedBox.shrink();

    String displayText = cat.toUpperCase();
    if (displayText.length > maxChars) {
      displayText = '${displayText.substring(0, maxChars - 3).trim()}...';
    }

    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFF002F6C), // Deep Peers Navy
          Color(0xFF1D4ED8), // Primary Blue
          Color(0xFFE11D48), // Vibrant Brand Red/Pink
        ],
        stops: [0.0, 0.45, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(
        displayText,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: cardWidth * 0.0235,
          letterSpacing: 0.4,
          height: 1.15,
        ),
      ),
    );
  }

  String _formatWithHyphenation(String text, {int maxChars = 26}) {
    String formatted = text.trim().toUpperCase();
    if (formatted.length > maxChars) {
      formatted = '${formatted.substring(0, maxChars - 3).trim()}...';
    }
    return formatted;
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].length >= 2) {
      return parts[0].substring(0, 2).toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }
}
