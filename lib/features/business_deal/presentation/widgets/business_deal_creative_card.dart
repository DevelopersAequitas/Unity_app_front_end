import 'dart:io';
import 'package:flutter/material.dart';

class BusinessDealCreativeCard extends StatelessWidget {
  // Current User (Left)
  final String myName;
  final String? myCity;
  final String? myCompanyName;
  final String? myCategory;
  final String? myAvatarUrl;

  // Peer User (Right)
  final String peerName;
  final String? peerCity;
  final String? peerCompanyName;
  final String? peerCategory;
  final String? peerAvatarUrl;

  // Template & Branding
  final String? templateBackgroundUrl;
  final bool showLogo;

  const BusinessDealCreativeCard({
    super.key,
    required this.myName,
    this.myCity,
    this.myCompanyName,
    this.myCategory,
    this.myAvatarUrl,
    required this.peerName,
    this.peerCity,
    this.peerCompanyName,
    this.peerCategory,
    this.peerAvatarUrl,
    this.templateBackgroundUrl,
    this.showLogo = true,
  });

  // Default Business Deal template fallback
  static const String defaultTemplateUrl =
      'https://peersunity.com/storage/uploads/2026/05/27/63f8bb13-0c18-4b89-b3e8-b0e5d1a527df.webp';

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1080 / 1350,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth;
          final cardHeight = constraints.maxHeight;

          final leftCenterX = cardWidth * 0.2160;
          final leftCenterY = cardHeight * 0.5296;
          final leftDiameter = cardWidth * 0.2450;

          final rightCenterX = cardWidth * 0.7737;
          final rightCenterY = cardHeight * 0.5296;
          final rightDiameter = cardWidth * 0.2450;

          final backgroundUrl = (templateBackgroundUrl != null &&
                  templateBackgroundUrl!.isNotEmpty)
              ? templateBackgroundUrl!
              : defaultTemplateUrl;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. Background Template
              Positioned.fill(
                child: Image.network(
                  backgroundUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFF1E293B),
                    alignment: Alignment.center,
                    child: const Text(
                      'Template unavailable',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: Color(0xFF0038A8),
                        strokeWidth: 2,
                      ),
                    );
                  },
                ),
              ),

              // 2. Left User Avatar (Current User)
              Positioned(
                left: leftCenterX - (leftDiameter / 2),
                top: leftCenterY - (leftDiameter * 1.2 / 2),
                width: leftDiameter * 1.02,
                height: leftDiameter * 1.15,
                child: _buildAvatar(
                  imageUrl: myAvatarUrl,
                  name: myName,
                  diameter: leftDiameter,
                  fallbackColor: const Color(0xFF0038A8),
                ),
              ),

              // 3. Right User Avatar (Peer)
              Positioned(
                left: rightCenterX - (rightDiameter / 2),
                top: rightCenterY - (rightDiameter * 1.2 / 2),
                width: rightDiameter * 1.02,
                height: rightDiameter * 1.15,
                child: _buildAvatar(
                  imageUrl: peerAvatarUrl,
                  name: peerName,
                  diameter: rightDiameter,
                  fallbackColor: const Color(0xFFB90E0A),
                ),
              ),

              // 4. Left User Details
              Positioned(
                left: cardWidth * 0.02,
                width: cardWidth * 0.44,
                top: cardHeight * 0.67,
                height: cardHeight * 0.20,
                child: _buildUserDetailsColumn(
                  name: myName,
                  city: myCity,
                  companyName: myCompanyName,
                  category: myCategory,
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  isLeft: true,
                ),
              ),

              // 5. Right User Details
              Positioned(
                left: cardWidth * 0.54,
                width: cardWidth * 0.44,
                top: cardHeight * 0.67,
                height: cardHeight * 0.20,
                child: _buildUserDetailsColumn(
                  name: peerName,
                  city: peerCity,
                  companyName: peerCompanyName,
                  category: peerCategory,
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  isLeft: false,
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
    required Color fallbackColor,
  }) {
    final bool isNetwork = imageUrl != null &&
        imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: isNetwork
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildInitialsAvatar(name, diameter, fallbackColor),
              )
            : (imageUrl != null &&
                    imageUrl.isNotEmpty &&
                    File(imageUrl).existsSync()
                ? Image.file(
                    File(imageUrl),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildInitialsAvatar(name, diameter, fallbackColor),
                  )
                : _buildInitialsAvatar(name, diameter, fallbackColor)),

      ),
    );
  }

  Widget _buildInitialsAvatar(String name, double diameter, Color bgColor) {
    final initials = _getInitials(name);
    return Container(
      width: diameter,
      height: diameter,
      color: bgColor,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: diameter * 0.35,
        ),
      ),
    );
  }

  Widget _buildUserDetailsColumn({
    required String name,
    required String? city,
    required String? companyName,
    required String? category,
    required double cardWidth,
    required double cardHeight,
    required bool isLeft,
  }) {
    final titleColor =
        isLeft ? const Color(0xFF0038A8) : const Color(0xFFB90E0A);
    final cleanName = name.trim().toUpperCase();
    final cleanCity = city?.trim() ?? '';
    final cleanCompany = companyName?.trim() ?? '';
    final cleanCategory = category?.trim() ?? '';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            cleanName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w500,
              fontSize: cardWidth * 0.029,
              letterSpacing: 0.2,
              height: 1.1,
            ),
          ),
        ),
        if (cleanCity.isNotEmpty) ...[
          SizedBox(height: cardHeight * 0.0035),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              cleanCity,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF475569),
                fontWeight: FontWeight.w500,
                fontSize: cardWidth * 0.022,
                height: 1.1,
              ),
            ),
          ),
        ],
        if (cleanCompany.isNotEmpty) ...[
          SizedBox(height: cardHeight * 0.0035),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              cleanCompany,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w500,
                fontSize: cardWidth * 0.022,
                height: 1.1,
              ),
            ),
          ),
        ],
        if (cleanCategory.isNotEmpty) ...[
          SizedBox(height: cardHeight * 0.0035),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              cleanCategory,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w400,
                fontSize: cardWidth * 0.020,
                height: 1.1,
              ),
            ),
          ),
        ],
      ],
    );
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
    return '';
  }
}
