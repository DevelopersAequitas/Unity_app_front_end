import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';

class BlockedUserTile extends StatelessWidget {
  final String id;
  final String name;
  final String avatar;
  final VoidCallback onUnblock;

  const BlockedUserTile({
    super.key,
    required this.id,
    required this.name,
    required this.avatar,
    required this.onUnblock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColor.lightSurfaceSubtle,
            backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
            child: avatar.isEmpty
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: AppTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColor.lightTextPrimary,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: onUnblock,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColor.primaryBlue),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(
              'Unblock',
              style: AppTypography.labelSmall.copyWith(
                color: AppColor.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
