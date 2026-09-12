import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_color.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final bool showOnlineBadge;
  final bool isOnline;

  const AppAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 52,
    this.showOnlineBadge = false,
    this.isOnline = false,
  });

  static final List<LinearGradient> _avatarGradients = [
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)], // Indigo to Purple
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0284C7), Color(0xFF2563EB)], // Sky to Royal Blue
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF059669), Color(0xFF0D9488)], // Emerald to Teal
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE11D48), Color(0xFFC026D3)], // Rose to Fuchsia
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFEA580C), Color(0xFFDC2626)], // Orange to Red
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFD97706), Color(0xFFCA8A04)], // Amber to Warm Gold
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF7C3AED), Color(0xFFDB2777)], // Violet to Pink
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0891B2), Color(0xFF059669)], // Cyan to Mint
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF475569), Color(0xFF1E293B)], // Slate to Navy
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF9333EA), Color(0xFF4F46E5)], // Purple to Indigo
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2563EB), Color(0xFF06B6D4)], // Blue to Cyan
    ),
    const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF10B981), Color(0xFF84CC16)], // Green to Lime
    ),
  ];

  static LinearGradient getGradientForName(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return _avatarGradients.first;
    int hash = 0;
    for (int i = 0; i < clean.length; i++) {
      hash = clean.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return _avatarGradients[hash.abs() % _avatarGradients.length];
  }

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isNotEmpty
        ? name
            .trim()
            .split(RegExp(r'\s+'))
            .where((e) => e.isNotEmpty)
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : 'P';

    final hasValidUrl = imageUrl != null &&
        imageUrl!.trim().isNotEmpty &&
        !imageUrl!.contains('peersuser.png') &&
        imageUrl!.trim() != 'null';

    final gradient = getGradientForName(name);

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColor.white.withValues(alpha: 0.9),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: hasValidUrl
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => _buildInitials(initials, gradient),
                  errorWidget: (_, _, _) => _buildInitials(initials, gradient),
                )
              : _buildInitials(initials, gradient),
        ),
        if (showOnlineBadge)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.26,
              height: size * 0.26,
              decoration: BoxDecoration(
                color: isOnline
                    ? const Color(0xFF22C55E)
                    : const Color(0xFF94A3B8),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.8),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitials(String initials, LinearGradient gradient) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.38,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}
