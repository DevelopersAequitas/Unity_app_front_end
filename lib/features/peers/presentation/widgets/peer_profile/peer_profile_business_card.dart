import 'package:flutter/material.dart';

import 'package:unity_app/core/theme/app_color.dart';
import 'package:unity_app/features/profile/domain/entities/profile_entity.dart';

class PeerProfileBusinessCard extends StatelessWidget {
  final ProfileEntity profile;

  const PeerProfileBusinessCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final company = profile.companyName ?? 'N/A';
    final subCategory =
        profile.businessSubCategory ?? profile.businessCategory ?? 'N/A';
    final mainCategory = profile.businessType ?? 'N/A';

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
              Icon(Icons.business_center_rounded, size: 16, color: AppColor.primaryBlue),
              SizedBox(width: 6),
              Text(
                'Business Information',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColor.lightTextPrimary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _BusinessInfoRow(icon: Icons.domain_outlined, title: 'Company', value: company),
          const SizedBox(height: 8),
          _BusinessInfoRow(icon: Icons.sell_outlined, title: 'Business Category', value: subCategory),
          const SizedBox(height: 8),
          _BusinessInfoRow(icon: Icons.grid_view_rounded, title: 'Main Category', value: mainCategory),
        ],
      ),
    );
  }
}

class _BusinessInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _BusinessInfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColor.lightTextSecondary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColor.lightTextSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColor.lightTextPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.chevron_right,
          size: 16,
          color: AppColor.lightTextSecondary,
        ),
      ],
    );
  }
}
