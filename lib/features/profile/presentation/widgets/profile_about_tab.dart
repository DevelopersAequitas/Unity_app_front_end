import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/profile_entity.dart';
import 'profile_about_skills_card.dart';
import 'profile_about_business_card.dart';

class ProfileAboutTab extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileAboutTab({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profile.introducedByUser != null) ...[
          _buildIntroducerCard(profile.introducedByUser!),
          const SizedBox(height: 12),
        ],
        if (profile.bio != null && profile.bio!.trim().isNotEmpty) ...[
          _buildBioCard(profile.bio!),
          const SizedBox(height: 12),
        ],
        ProfileAboutSkillsCard(profile: profile),
        ProfileAboutBusinessCard(profile: profile),
      ],
    );
  }

  Widget _buildIntroducerCard(IntroducedByUserEntity introducer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.primaryBlue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColor.primaryBlue.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: introducer.profilePhotoUrl != null
                ? CachedNetworkImageProvider(introducer.profilePhotoUrl!)
                : null,
            child: introducer.profilePhotoUrl == null
                ? const Icon(Icons.person_outline, size: 14, color: AppColor.primaryBlue)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            'Introduced by ',
            style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColor.lightTextTertiary),
          ),
          Text(
            introducer.name,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColor.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioCard(String bio) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.format_quote_outlined, size: 16, color: AppColor.lightTextTertiary),
              const SizedBox(width: 6),
              Text(
                'About',
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.5,
                  color: AppColor.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            bio,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 12,
              color: AppColor.lightTextSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
