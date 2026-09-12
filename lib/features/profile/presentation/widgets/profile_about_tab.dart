import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/profile_entity.dart';

class ProfileAboutTab extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileAboutTab({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Introducer Badge if available
          if (profile.introducedByUser != null) ...[
            _buildIntroducerCard(profile.introducedByUser!),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Skills Section
          if (profile.skills.isNotEmpty) ...[
            _buildSectionCard(
              title: 'SKILLS & EXPERTISE',
              icon: Icons.psychology_outlined,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: profile.skills.map((s) => _buildChip(s, AppColor.primary)).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Interests
          if (profile.interests.isNotEmpty) ...[
            _buildSectionCard(
              title: 'INTERESTS',
              icon: Icons.lightbulb_outline_rounded,
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: profile.interests.map((i) => _buildChip(i, AppColor.primaryGradientEnd)).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Networking: I Can Help With & Looking For
          if (profile.iCanHelpWith.isNotEmpty || profile.iAmLookingFor.isNotEmpty) ...[
            _buildSectionCard(
              title: 'NETWORKING & VALUE EXCHANGE',
              icon: Icons.handshake_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (profile.iCanHelpWith.isNotEmpty) ...[
                    Text(
                      'I can help with:',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: profile.iCanHelpWith
                          .map((h) => _buildChip(h, const Color(0xFF10B981)))
                          .toList(),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  if (profile.iAmLookingFor.isNotEmpty) ...[
                    Text(
                      'I am looking for:',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColor.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: profile.iAmLookingFor
                          .map((l) => _buildChip(l, const Color(0xFF8B5CF6)))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],

          // Business Details & Classification
          _buildBusinessDetailsCard(),
          const SizedBox(height: AppSpacing.sm),

          // Community & Availability Badges
          _buildCommunityTogglesCard(),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildIntroducerCard(IntroducedByUserEntity introducer) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs + 2),
      decoration: BoxDecoration(
        color: AppColor.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: introducer.profilePhotoUrl != null
                ? CachedNetworkImageProvider(introducer.profilePhotoUrl!)
                : null,
            child: introducer.profilePhotoUrl == null
                ? const Icon(Icons.person, size: 14, color: AppColor.primary)
                : null,
          ),
          const SizedBox(width: AppSpacing.xs + 2),
          Text(
            'Introduced by ',
            style: AppTypography.labelSmall.copyWith(color: AppColor.textTertiary),
          ),
          Text(
            introducer.name,
            style: AppTypography.labelSmall.copyWith(
              color: AppColor.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColor.textTertiary),
              const SizedBox(width: 4),
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: AppColor.textTertiary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          child,
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: accent,
        ),
      ),
    );
  }

  Widget _buildBusinessDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storefront_outlined, size: 14, color: AppColor.textTertiary),
              const SizedBox(width: 4),
              Text(
                'COMPANY & BUSINESS DETAILS',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: AppColor.textTertiary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          if (profile.companyName != null && profile.companyName!.isNotEmpty)
            _buildDetailRow('Company', profile.companyName!),
          if (profile.designation != null && profile.designation!.isNotEmpty)
            _buildDetailRow('Designation', profile.designation!),
          if (profile.companyType != null && profile.companyType!.isNotEmpty)
            _buildDetailRow('Company Type', profile.companyType!),
          if (profile.yearOfEstablishment != null)
            _buildDetailRow('Established', '${profile.yearOfEstablishment}'),
          if (profile.numberOfEmployees != null && profile.numberOfEmployees!.isNotEmpty)
            _buildDetailRow('Team Size', '${profile.numberOfEmployees} members'),
          if (profile.annualRevenueRange != null && profile.annualRevenueRange!.isNotEmpty)
            _buildDetailRow('Revenue Range', profile.annualRevenueRange!),
          if (profile.businessAddress != null && profile.businessAddress!.isNotEmpty)
            _buildDetailRow('Business Address', profile.businessAddress!),
          if (profile.businessSubCategory != null && profile.businessSubCategory!.isNotEmpty)
            _buildDetailRow('Sub-Category', profile.businessSubCategory!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppTypography.labelSmall.copyWith(color: AppColor.textTertiary, fontSize: 11),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                color: AppColor.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityTogglesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColor.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_outlined, size: 14, color: AppColor.textTertiary),
              const SizedBox(width: 4),
              Text(
                'COMMUNITY INVOLVEMENT',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  color: AppColor.textTertiary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          _buildToggleItem(
            'Willing to Mentor',
            profile.willingToMentor,
            Icons.school_outlined,
          ),
          _buildToggleItem(
            'Open to Cross-City Collaboration',
            profile.openToCrossCityCollaboration,
            Icons.explore_outlined,
          ),
          _buildToggleItem(
            'Open to Speaking at Events',
            profile.openToSpeakingAtEvents,
            Icons.record_voice_over_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String label, bool isAvailable, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isAvailable ? AppColor.primary : AppColor.textTertiary,
          ),
          const SizedBox(width: AppSpacing.xs + 2),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: isAvailable ? AppColor.textPrimary : AppColor.textTertiary,
                fontWeight: isAvailable ? FontWeight.w600 : FontWeight.w400,
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isAvailable ? const Color(0xFF10B981).withValues(alpha: 0.1) : AppColor.backgroundSubtle,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: Text(
              isAvailable ? 'Available' : 'No',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isAvailable ? const Color(0xFF10B981) : AppColor.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
